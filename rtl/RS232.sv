module RS232 #(
  parameter int BASEADDRESS = 32'h6000_0000,
  // Register 0 for TX (Write only)
  // Register 1 for RX (Read only)
  parameter int CLOCK_FREQ  = 50_000_000,
  parameter int BAUD_RATE   = 115200,
  parameter int FIFO_WIDTH  = 64
) (
  input       logic         ACLK,
  input       logic         RESET,
  input       logic [31:00] DATA_I,
  output      logic [31:00] DATA_O,
  input       logic [31:00] ADDR,
  input       logic         WRSTB,
  input       logic         RDSTB,
  //////////// RS232 //////////
  input 		  logic     		UART_CTS,
  output		  logic     		UART_RTS,
  input 		  logic     		UART_RXD,
  output		  logic     		UART_TXD
);
  // fifo buffer for rx data
  logic [07:00] fifo_rx [0:FIFO_WIDTH-1];

  // addresses for the read and write heads of the rx fifo
  logic [$clog2(FIFO_WIDTH)-1:00] fifo_rx_read_addr;
  logic [$clog2(FIFO_WIDTH)-1:00] fifo_rx_write_addr;

  // number of valid words (8-bit) in the rx fifo
  logic [$clog2(FIFO_WIDTH)  :00] fifo_rx_len;

  // fifo buffer for tx data
  logic [07:00] fifo_tx [0:FIFO_WIDTH-1];

  // addresses for the read and write heads of the tx fifo
  logic [$clog2(FIFO_WIDTH)-1:00] fifo_tx_read_addr;
  logic [$clog2(FIFO_WIDTH)-1:00] fifo_tx_write_addr;

  // number of valid words (8-bit) in the tx fifo
  logic [$clog2(FIFO_WIDTH)  :00] fifo_tx_len;

  // register to hold the read data
  logic [07:00] RX_DATA;
  // register to hold the read data valid bit
  logic         RX_DATA_VALID;
  // register to hold the read command bit
  logic         RX_DATA_READ;

  // register to hold the write data
  logic [07:00] TX_DATA;
  // register to hold the write data valid bit
  logic         TX_DATA_VALID;
  // register to hold the write command bit
  logic         TX_DATA_READ;
  // register to hold whether the TX module is Idle or not
  logic         TX_IDLE;

  // assign UART_RTS = fifo_tx_len > 'd0;

  UART_RX rx (
    .ACLK(ACLK),
    .RESET(RESET),
    .RXD(UART_RXD),
    .RX_DATA_READ(RX_DATA_READ),
    .RX_DATA(RX_DATA),
    .RX_DATA_VALID(RX_DATA_VALID)
  );

  UART_TX tx (
    .ACLK(ACLK),
    .RESET(RESET),
    .TXD(UART_TXD),
    .TX_DATA_READ(TX_DATA_READ),
    .TX_DATA(TX_DATA),
    .TX_DATA_VALID(TX_DATA_VALID),
    .UART_CTS(UART_CTS),
    .UART_RTS(UART_RTS),
    .TX_IDLE(TX_IDLE)
  );



  // push data to the read fifo and update the write address
  // pop data from the read fifo and update the read address
  always_ff @(posedge ACLK or posedge RESET) begin : readRXData
    if (RESET == 1) begin
      fifo_rx_write_addr  <= 'd0;
      fifo_rx_read_addr   <= 'd0;
      RX_DATA_READ        <= 1'd0;
      fifo_rx_len         <= 'd0;
    end else begin
      if (RDSTB && (ADDR >= BASEADDRESS) && (ADDR[0] == 1'b1) && fifo_rx_len > 0) begin
          DATA_O                       <= fifo_rx[fifo_rx_read_addr];
          fifo_rx_read_addr            <= fifo_rx_read_addr + 6'd1;
          fifo_rx_len                  <= fifo_rx_len - 7'd1;
      end
      else begin
        DATA_O                         <= 32'dz;
        if (RX_DATA_VALID == 1'b1 && fifo_rx_len <= FIFO_WIDTH) begin
          fifo_rx[fifo_rx_write_addr]  <= RX_DATA;
          fifo_rx_write_addr           <= fifo_rx_write_addr + 6'd1;
          RX_DATA_READ                 <= 1'd1;
          fifo_rx_len                  <= fifo_rx_len + 7'd1;
        end
        else begin
          RX_DATA_READ                  <= 1'd0;
        end
      end
    end
  end : readRXData


  // push data to the write fifo and update the write address
  // pop data from the write fifo and update the read address
  always_ff @(posedge ACLK or posedge RESET) begin : writeTXFIFO
    if (RESET == 1) begin
      fifo_tx_write_addr  <= 'd0;
      fifo_tx_read_addr   <= 'd0;
      fifo_tx_len         <= 'd0;
    end else begin
      if (WRSTB && (ADDR >= BASEADDRESS) && (ADDR[0] == 1'b0) && fifo_tx_len <= FIFO_WIDTH) begin
        fifo_tx[fifo_rx_write_addr]    <= DATA_I[07:00];
        fifo_tx_write_addr             <= fifo_tx_write_addr + 6'd1;
        fifo_tx_len                    <= fifo_tx_len + 7'd1;
      end
      else if (TX_IDLE == 1'b1) begin
        TX_DATA                        <= fifo_tx[fifo_tx_read_addr];
        TX_DATA_VALID                  <= 1'b1;
        fifo_tx_read_addr              <= fifo_tx_read_addr + 6'd1;
        fifo_tx_len                    <= fifo_tx_len - 7'd1;
      end
    end
  end : writeTXFIFO

endmodule