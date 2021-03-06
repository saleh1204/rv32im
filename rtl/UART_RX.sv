module UART_RX #(
    parameter int CLOCK_FREQ = 50_000_000,
    parameter int BAUD_RATE  = 115200
) (
    input  logic         ACLK,
    input  logic         RESET,
    input  logic         RXD,
    input  logic         RX_DATA_READ,
    output logic [07:00] RX_DATA,
    output logic         RX_DATA_VALID
);
  localparam CLOCKS_PER_BIT = CLOCK_FREQ / BAUD_RATE;

  logic [$clog2(CLOCKS_PER_BIT)-1:00] counter;
  logic         counterReset;
  logic         counterInc;
  logic [02:00] bitIndex;
  logic         bitIndexReset;
  logic         bitIndexInc;
  logic         readBit;

  typedef enum logic [02:00] {
    IDLE,
    START_BIT,
    DATA_BITS,
    VALID_DATA
  } state;

  state currState, nextState;
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
    nextState     = currState;  // default is to stay in current state
    bitIndexReset = 1'b0;
    bitIndexInc   = 1'b0;
    counterReset  = 1'b0;
    counterInc    = 1'b0;
    readBit       = 1'b0;
    RX_DATA_VALID = (currState == VALID_DATA);
    case (currState)
      IDLE: begin
        if (RXD == 1'b0) begin
          nextState     = START_BIT;
          counterReset  = 1'b1;
        end
      end
      START_BIT: begin
        if (counter == (CLOCKS_PER_BIT - 1) / 2) begin
          if (RXD == 1'b0) begin
            nextState     = DATA_BITS;
            bitIndexReset = 1'b1;
            counterReset  = 1'b1;
          end else begin
            nextState     = IDLE;
          end
        end
        else begin
          counterInc      = 1'b1;
          nextState       = START_BIT;
        end
      end
      DATA_BITS: begin
        if (bitIndex == 7 && counter == CLOCKS_PER_BIT - 1) begin
          readBit        = 1'b1;
          nextState      = VALID_DATA;
        end
        else begin
          if (counter == CLOCKS_PER_BIT - 1) begin
            readBit      = 1'b1;
            bitIndexInc  = 1'b1;
            counterReset = 1'b1;
          end
          else begin
            counterInc   = 1'b1;
          end
          nextState      = DATA_BITS;
        end
      end
      VALID_DATA: begin
        if (RX_DATA_READ == 1'b1) begin
          nextState = IDLE;
        end else begin
          nextState = VALID_DATA;
        end
      end
      default: begin
        nextState = IDLE;
      end
    endcase
  end : nextStateLogic

  // bitIndex register
  always_ff @(posedge ACLK or posedge RESET) begin : updateIndexReg
    if (RESET == 1) begin
      bitIndex <= 3'd0;
    end else begin
      if (bitIndexReset == 1'b1) begin
        bitIndex <= 3'd0;
      end
      else if (bitIndexInc == 1'b1) begin
        bitIndex <= bitIndex + 3'd1;
      end
    end
  end : updateIndexReg


  // counter register
  always_ff @(posedge ACLK or posedge RESET) begin : updateCounterReg
    if (RESET == 1) begin
      counter <= 'd0;
    end else begin
      if (counterReset == 1'b1) begin
        counter <= 'd0;
      end
      else if (counterInc == 1'b1) begin
        counter <= counter + 9'd1;
      end
    end
  end : updateCounterReg

  // data register
  always_ff @(posedge ACLK or posedge RESET) begin : updateDataReg
    if (RESET == 1) begin
      RX_DATA <= 8'd0;
    end else begin
      if (readBit == 1'b1) begin
        RX_DATA[bitIndex] <= RXD;
      end
    end
  end : updateDataReg

endmodule
