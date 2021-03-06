module UART_TX #(
    parameter int CLOCK_FREQ = 50_000_000,
    parameter int BAUD_RATE  = 115200
) (
    input  logic         ACLK,
    input  logic         RESET,
    output logic         TXD,
    output logic         TX_DATA_READ,
    input  logic [07:00] TX_DATA,
    input  logic         TX_DATA_VALID,
    input  logic         UART_CTS,
    output logic         UART_RTS,
    output logic         TX_IDLE
);
  localparam CLOCKS_PER_BIT = CLOCK_FREQ / BAUD_RATE;

  logic [$clog2(CLOCKS_PER_BIT)-1:00] counter;
  logic         counterReset;
  logic         counterInc;
  logic [02:00] bitIndex;
  logic         bitIndexReset;
  logic         bitIndexInc;
  logic         writeBit;
  logic [07:00] TX_DATA_REG;

  typedef enum logic [02:00] {
    IDLE,
    WAIT_FOR_CTS,
    START_BIT,
    DATA_BITS
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
    counterInc    = 1'b0;
    counterReset  = 1'b0;
    writeBit      = 1'b0;
    TX_DATA_READ  = 1'b0;
    TX_IDLE       = 1'b0;
	 UART_RTS      = 1'b0;
    case (currState)
      IDLE: begin
        if (TX_DATA_VALID == 1'b1) begin
          nextState     = WAIT_FOR_CTS;
          counterReset  = 1'b1;
          TX_DATA_READ  = 1'b1;
          TX_IDLE       = 1'b1;
          UART_RTS      = 1'b1;
        end
      end
      WAIT_FOR_CTS: begin
        if (UART_CTS == 1'b1) begin
          nextState = START_BIT;
        end else begin
          nextState = WAIT_FOR_CTS;
			 UART_RTS  = 1'b1;
        end
      end
      START_BIT: begin
        if (counter == (CLOCKS_PER_BIT - 1)) begin
          counterReset  = 1'b1;
          bitIndexReset = 1'b1;
          nextState     = DATA_BITS;
        end
        else begin
          counterInc    = 1'b1;
          nextState     = START_BIT;
        end
      end
      DATA_BITS: begin
        writeBit      = 1'b1;
        if (bitIndex == 7 && counter == CLOCKS_PER_BIT - 1) begin
          nextState       = IDLE;
        end
        else begin
          if (counter == CLOCKS_PER_BIT - 1) begin
            bitIndexInc   = 1'b1;
            counterReset  = 1'b1;
          end
          else begin
            counterInc    = 1'b1;
          end
          nextState      = DATA_BITS;
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

  // TXD output
  always_ff @(posedge ACLK or posedge RESET) begin : updateTXD
    if (RESET == 1) begin
      TXD <= 1'd1;
    end else begin
      if (currState == START_BIT) begin
        TXD <= 1'd0;
      end
      else if (writeBit == 1'b1) begin
        TXD <= TX_DATA_REG[bitIndex];
      end
      else begin
        TXD <= 1'd1;
      end
    end
  end : updateTXD

  // data register
  always_ff @(posedge ACLK or posedge RESET) begin : updateDataReg
    if (RESET == 1) begin
      TX_DATA_REG <= 8'd0;
    end else begin
      if (TX_DATA_READ == 1'b1) begin
        TX_DATA_REG <= TX_DATA;
      end
    end
  end : updateDataReg

endmodule
