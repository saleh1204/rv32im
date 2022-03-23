module LCD #(
    parameter int BASEADDRESS = 32'h5000_0000

) (
    input       logic         ACLK,
    input       logic         RESET,
    input       logic [31:00] DATA_I,
    input       logic [31:00] ADDR,
    input       logic         WRSTB,

    //////////// LCD //////////
    output      logic         LCD_BLON,
    inout  wire logic [07:00] LCD_DATA,
    output      logic         LCD_EN,
    output      logic         LCD_ON,
    output      logic         LCD_RS,    // 0 = command, 1 = data
    output      logic         LCD_RW     // 0 = write  , 1 = read
);
  // registered LCD data
  logic [07:00] data;
  // registered enable bit
  logic         enable;
  // registered RS bit
  logic         rs;
  // write enable register
  logic         we;
  // counter value for the delay
  logic [16:00] counter;

  enum bit [1:0] {
    IDLE,
    SEND_COMMAND,
    SEND_DATA,
    DELAY
  }
      currState, nextState;

  // Backlight Display always ON
  assign LCD_BLON = 1'b1;
  // Display is always ON
  assign LCD_ON   = 1'b1;
  // We always write to display
  assign LCD_RW   = 1'b0;
  // connect LCD_output to register
  assign LCD_DATA = data;
  // connect LCD enable register
  assign LCD_EN = enable;
  // connect LCD RS register
  assign LCD_RS = rs;



  // Current state registers
  always_ff @(posedge ACLK or posedge RESET) begin : currStateRegs
    if (RESET == 1) begin
      currState <= IDLE;
    end else begin
      currState <= nextState;
    end
  end : currStateRegs

  // next state logic
  always_comb begin : nextStateLogic
    nextState = currState;  // default is to stay in current state
    we = 0;
    case (currState)
      IDLE:
        begin
          if (WRSTB && (ADDR >= BASEADDRESS) && (ADDR <= BASEADDRESS + 1)) begin
            we = 1;
            if (ADDR[0] == 1'b0) begin
              nextState = SEND_COMMAND;
            end
            else begin
              nextState = SEND_DATA;
            end
          end
        end
      SEND_COMMAND:
        begin
          nextState = DELAY;
        end
      SEND_DATA:
        begin
          nextState = DELAY;
        end
      DELAY:
        begin
          if (counter == 'd0) begin
            nextState = IDLE;
          end
          else begin
            nextState = DELAY;
          end
        end
      default:
        begin
          nextState = IDLE;
        end
    endcase
  end : nextStateLogic

  // updating lcd data, enable, and rs registers
  always_ff @(posedge ACLK or posedge RESET) begin : regsUpdate
    if (RESET == 1) begin
      data      <= 8'd0;
      enable    <= 1'd0;
      rs        <= 1'd0;
      counter   <= 17'd0;
    end else begin
      if (we == 1'b1) begin
        data    <= DATA_I[07:00];
      end
      if (currState == SEND_COMMAND || currState == SEND_DATA || currState == DELAY) begin
        enable  <= 1'b1;
      end
      else begin
        enable  <= 1'b0;
      end
      if (currState == SEND_COMMAND) begin
        rs      <= 1'd0;
      end
      else if (currState == SEND_DATA) begin
        rs      <= 1'd1;
      end
      if (currState == SEND_COMMAND || currState == SEND_DATA) begin
        counter <= 17'd100000; // 1 ms for 50 MHz
      end
      else if (currState == DELAY) begin
        counter <= counter - 17'd1;
      end
    end
  end : regsUpdate

endmodule : LCD
