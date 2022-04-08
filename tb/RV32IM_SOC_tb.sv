`timescale 1 ps/ 1 ps
module RV32IM_SOC_tb;

  logic 		    CLK;
  logic         RESET;
  //////////// VGA //////////
  logic [07:00] VGA_B;
  logic         VGA_BLANK_N;
  logic         VGA_CLK;
  logic [07:00] VGA_G;
  logic         VGA_HS;
  logic [07:00] VGA_R;
  logic         VGA_SYNC_N;
  logic         VGA_VS;
  //////////// LED //////////
  logic [08:00] LEDG;
  logic [17:00] LEDR;
  //////////// SW //////////
  logic [17:00] SW;
  //////////// SRAM //////////
  logic [19:00] SRAM_ADDR;
  logic         SRAM_CE_N;
  wire logic [15:00] SRAM_DQ;
  logic         SRAM_LB_N;
  logic         SRAM_OE_N;
  logic         SRAM_UB_N;
  logic         SRAM_WE_N;
  //////////// SEG7 //////////
  logic [06:00]	HEX0;
  logic [06:00] HEX1;
  logic [06:00] HEX2;
  logic [06:00] HEX3;
  logic [06:00] HEX4;
  logic [06:00] HEX5;
  logic [06:00] HEX6;
  logic [06:00] HEX7;
  //////////// LCD //////////
  logic         LCD_BLON;
  wire logic [07:00] LCD_DATA;
  logic         LCD_EN;
  logic         LCD_ON;
  logic         LCD_RS;
  logic         LCD_R;
  //////////// RS232 //////////
  logic UART_CTS;
  logic UART_RTS;
  logic UART_RXD;
  logic UART_TXD;


  RV32IM_SOC dut (
            .ACLK(CLK),
            .ARESETN(RESET),
            //////////// VGA //////////
            .VGA_HS(VGA_HS),
            .VGA_VS(VGA_VS),
            .VGA_CLK(VGA_CLK),
            .VGA_BLANK_N(VGA_BLANK_N),
            .VGA_SYNC_N(VGA_SYNC_N),
            .VGA_R(VGA_R),
            .VGA_G(VGA_G),
            .VGA_B(VGA_B),
            //////////// LED //////////
            .LEDG(LEDG),
            .LEDR(LEDR),
            //////////// SW //////////
            .SW(SW),
            //////////// SRAM //////////
            .SRAM_ADDR(SRAM_ADDR),
            .SRAM_CE_N(SRAM_CE_N),
            .SRAM_DQ(SRAM_DQ),
            .SRAM_LB_N(SRAM_LB_N),
            .SRAM_OE_N(SRAM_OE_N),
            .SRAM_UB_N(SRAM_UB_N),
            .SRAM_WE_N(SRAM_WE_N),
            //////////// SEG7 //////////
            .HEX0(HEX0),
            .HEX1(HEX1),
            .HEX2(HEX2),
            .HEX3(HEX3),
            .HEX4(HEX4),
            .HEX5(HEX5),
            .HEX6(HEX6),
            .HEX7(HEX7),
            //////////// LCD //////////
            .LCD_BLON(LCD_BLON),
            .LCD_DATA(LCD_DATA),
            .LCD_EN(LCD_EN),
            .LCD_ON(LCD_ON),
            .LCD_RS(LCD_RS),
            .LCD_RW(LCD_RW),
            //////////// RS232 //////////
            .UART_CTS(UART_CTS),
            .UART_RTS(UART_RTS),
            .UART_RXD(UART_RXD),
            .UART_TXD(UART_TXD)
  );

  initial begin
    $dumpfile("rv32im_soc.vcd");
    $dumpvars(0, RV32IM_SOC_tb);
    RESET = 1'b1;
    CLK = 1'b0;
    @(negedge CLK)
    RESET = 1'b0;
    repeat(10) @(negedge CLK);
    RESET = 1'b1;
    repeat(10000) @(negedge CLK);
    $stop;
  end
  always begin
    #5 CLK = ~CLK;
  end

endmodule: RV32IM_SOC_tb
