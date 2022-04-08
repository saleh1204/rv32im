module RV32IM_SOC (
  input       logic         ACLK,          // global clock
  input       logic         ARESETN,       // asynchronous reset (active low)
  //////////// VGA //////////
  output      logic [07:00] VGA_B,
  output      logic         VGA_BLANK_N,
  output      logic         VGA_CLK,
  output      logic [07:00] VGA_G,
  output      logic         VGA_HS,
  output      logic [07:00] VGA_R,
  output      logic         VGA_SYNC_N,
  output      logic         VGA_VS,
  //////////// LED //////////
  output      logic [08:00] LEDG,
  output      logic [17:00] LEDR,
  //////////// SW //////////
  input       logic [17:00] SW,
  //////////// SRAM //////////
  output      logic [19:00] SRAM_ADDR,
  output      logic         SRAM_CE_N,
  inout  wire logic [15:00] SRAM_DQ,
  output      logic         SRAM_LB_N,
  output      logic         SRAM_OE_N,
  output      logic         SRAM_UB_N,
  output      logic         SRAM_WE_N,
  //////////// SEG7 //////////
	output		  logic [06:00]	HEX0,
	output		  logic [06:00] HEX1,
	output		  logic [06:00] HEX2,
	output		  logic [06:00] HEX3,
	output		  logic [06:00] HEX4,
	output		  logic [06:00] HEX5,
	output		  logic [06:00] HEX6,
	output		  logic [06:00] HEX7,
  //////////// LCD //////////
	output      logic         LCD_BLON,
	inout  wire logic [07:00] LCD_DATA,
	output		  logic         LCD_EN,
	output      logic         LCD_ON,
	output      logic         LCD_RS,
	output      logic         LCD_RW,
  //////////// RS232 //////////
  input 		          		UART_CTS,
  output		          		UART_RTS,
  input 		          		UART_RXD,
  output		          		UART_TXD
);

  logic [31:00] ADDR;
  logic [31:00] DATA_IN_CPU;
  logic [31:00] DATA_OUT_CPU;
  logic WRSTB, RDSTB;

  CPU cpu (
    .ACLK(ACLK),
    .RESET(~ARESETN),
    .ADDR(ADDR),
    .DATA_I(DATA_IN_CPU),
    .DATA_O(DATA_OUT_CPU),
    .WRSTB(WRSTB),
    .RDSTB(RDSTB)
  );

  DataMemory dm (
    .ACLK(ACLK),
    .ADDR(ADDR),
    .DATA_I(DATA_OUT_CPU),
    .DATA_O(DATA_IN_CPU),
    .WRSTB(WRSTB),
    .RDSTB(RDSTB)
  );

  VGA vga (
    .ACLK(ACLK),
    .RESET(~ARESETN),
    .DATA_I(DATA_OUT_CPU),
    .ADDR(ADDR),
    .WRSTB(WRSTB),
    .VGA_HS(VGA_HS),
    .VGA_VS(VGA_VS),
    .VGA_CLK(VGA_CLK),
    .VGA_BLANK_N(VGA_BLANK_N),
    .VGA_SYNC_N(VGA_SYNC_N),
    .RED(VGA_R),
    .GREEN(VGA_G),
    .BLUE(VGA_B),
	  //////////// SRAM //////////
    .SRAM_ADDR(SRAM_ADDR),
    .SRAM_CE_N(SRAM_CE_N),
    .SRAM_DQ(SRAM_DQ),
    .SRAM_LB_N(SRAM_LB_N),
    .SRAM_OE_N(SRAM_OE_N),
    .SRAM_UB_N(SRAM_UB_N),
    .SRAM_WE_N(SRAM_WE_N)
	);

  GPIO gpio (
    .ACLK(ACLK),
    .RESET(~ARESETN),
    .ADDR(ADDR),
    .DATA_I(DATA_OUT_CPU),
    .DATA_O(DATA_IN_CPU),
    .WRSTB(WRSTB),
    .RDSTB(RDSTB),
    .LEDR(LEDR),
    .LEDG(LEDG),
    .SW(SW),
	  //////////// SEG7 //////////
	  .HEX0(HEX0),
	  .HEX1(HEX1),
	  .HEX2(HEX2),
	  .HEX3(HEX3),
	  .HEX4(HEX4),
	  .HEX5(HEX5),
	  .HEX6(HEX6),
	  .HEX7(HEX7)
  );

  LCD lcd (
    .ACLK(ACLK),
    .RESET(~ARESETN),
    .ADDR(ADDR),
    .DATA_I(DATA_OUT_CPU),
    .WRSTB(WRSTB),
    .LCD_BLON(LCD_BLON),
    .LCD_DATA(LCD_DATA),
    .LCD_EN(LCD_EN),
    .LCD_ON(LCD_ON),
    .LCD_RS(LCD_RS),
    .LCD_RW(LCD_RW)
  );

  RS232 rs232 (
    .ACLK(ACLK),
    .RESET(~ARESETN),
    .ADDR(ADDR),
    .DATA_I(DATA_OUT_CPU),
    .DATA_O(DATA_IN_CPU),
    .WRSTB(WRSTB),
    .RDSTB(RDSTB),
    //////////// RS232 //////////
    .UART_CTS(UART_CTS),
    .UART_RTS(UART_RTS),
    .UART_RXD(UART_RXD),
    .UART_TXD(UART_TXD)
  );

endmodule: RV32IM_SOC
