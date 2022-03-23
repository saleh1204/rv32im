//  Project: RISC-V CPU (RV32IM)
//  Module : VGA
//  Author : Saleh AlSaleh
module VGA #(
  parameter int WidthPixels  = 640, // c
  parameter int HFrontPorch  = 16,  // d
  parameter int HSyncPulse   = 96,  // a
  parameter int HBackPorch   = 48,  // b
  parameter int HeightPixels = 480, // c
  parameter int VFrontPorch  = 10,  // d
  parameter int VSyncPulse   = 2,   // a
  parameter int VBackPorch   = 33,  // b
  parameter int BASEADDRESS  = 32'h4000_0000
  // 	Pixel Frequency should be 25.175 MHz
)(
  input       logic         ACLK,
  input       logic         RESET,
  input       logic [31:00] DATA_I,
  input       logic [31:00] ADDR,
  input       logic         WRSTB,
  output      logic         VGA_HS,
  output      logic         VGA_VS,
  output      logic         VGA_CLK,
  output      logic         VGA_BLANK_N,
  output      logic         VGA_SYNC_N,
  output      logic [07:00] RED,
  output      logic [07:00] GREEN,
  output      logic [07:00] BLUE,
  //////////// SRAM //////////
  output      logic [19:00] SRAM_ADDR,
  output      logic         SRAM_CE_N,
  inout  wire logic [15:00] SRAM_DQ,
  output      logic         SRAM_LB_N,
  output      logic         SRAM_OE_N,
  output      logic         SRAM_UB_N,
  output      logic         SRAM_WE_N
);
  //  timeunit 1ns / 1ps;
  localparam int WholeLine = WidthPixels + HFrontPorch + HSyncPulse + HBackPorch;
  localparam int WholeFrame = HeightPixels + VFrontPorch + VSyncPulse + VBackPorch;
  logic [19:00] lADDR;

  // SRAM signals
  logic [19:00] sram_local_address;
  logic [15:00] sram_din;
  logic [15:00] sram_dout;
  logic [01:00] sram_byteenable;
  logic         sram_read;
  logic 			 sram_write;
  logic         sram_dout_valid;

  logic pixel_clk;
  logic displayTime;
  logic [$clog2(WholeLine)-1:0] h_pixel_counter;
  logic [$clog2(WholeFrame)-1:0] v_pixel_counter;

  assign sram_write         = WRSTB && (ADDR >= BASEADDRESS) && (ADDR <= BASEADDRESS + (WidthPixels + HeightPixels));
  assign sram_read          = displayTime && (~sram_write);
  assign sram_din           = DATA_I[15:00];
  assign sram_byteenable    = 2'd3; // always enable both bytes
  assign sram_local_address = (sram_write) ? (ADDR[15:00]) : (lADDR);

  assign VGA_CLK     = pixel_clk;
  assign VGA_SYNC_N  = displayTime;
  assign VGA_BLANK_N = displayTime;

  assign RED         = (sram_dout_valid) ? {sram_dout[04:00], 3'd0} : 8'd0;
  assign GREEN       = (sram_dout_valid) ? {sram_dout[09:05], 3'd0} : 8'd0;
  assign BLUE        = (sram_dout_valid) ? {sram_dout[14:10], 3'd0} : 8'd0;

  pll vga_pll_u0 (
    .reset_reset(RESET),
    .clk_clk(ACLK),
    .c0_clk(pixel_clk)
  );

  sram vga_sram  (
    .clk_clk               (ACLK),                  // clk.clk
    .reset_reset           (RESET),                 // reset.reset
    .sram_DQ               (SRAM_DQ),               // sram.DQ
    .sram_ADDR             (SRAM_ADDR),             // .ADDR
    .sram_LB_N             (SRAM_LB_N),             // .LB_N
    .sram_UB_N             (SRAM_UB_N),             // .UB_N
    .sram_CE_N             (SRAM_CE_N),             // .CE_N
    .sram_OE_N             (SRAM_OE_N),             // .OE_N
    .sram_WE_N             (SRAM_WE_N),             // .WE_N
    .sram_io_address       (sram_local_address),    // sram_io.address
    .sram_io_byteenable    (sram_byteenable),       // .byteenable
    .sram_io_read          (sram_read),             // .read
    .sram_io_write         (sram_write),            // .write
    .sram_io_writedata     (sram_din),              // .writedata
    .sram_io_readdata      (sram_dout),             // .readdata
    .sram_io_readdatavalid (sram_dout_valid)        // .readdatavalid
  );

  always_ff @(posedge pixel_clk or posedge RESET) begin : driveSyncs
    if (RESET == 1'b1) begin
      VGA_HS <= 'd0;
      VGA_VS <= 'd0;
    end
    else begin
      VGA_HS      <= ~((h_pixel_counter >= (WidthPixels + HFrontPorch)) &&
                         (h_pixel_counter < (WidthPixels + HFrontPorch + HSyncPulse)));
      VGA_VS      <= ~((v_pixel_counter >= (HeightPixels + VFrontPorch)) &&
                         (v_pixel_counter < (HeightPixels + VFrontPorch + VSyncPulse)));
      displayTime <= (h_pixel_counter < WidthPixels) && (v_pixel_counter < HeightPixels);
    end
  end : driveSyncs


  always_ff @(posedge pixel_clk or posedge RESET) begin : updateCounters
    if (RESET == 1'b1) begin
      h_pixel_counter <= 'd0;
      v_pixel_counter <= 'd0;
    end
    else begin
      if (h_pixel_counter == WholeLine) begin
        h_pixel_counter <= 'd0;
        v_pixel_counter <= v_pixel_counter + 9'd1;
        if (v_pixel_counter == WholeFrame) begin
          v_pixel_counter <= 'd0;
        end
      end
      else begin
        h_pixel_counter <= h_pixel_counter + 10'd1;
      end
    end
  end : updateCounters


  always_ff @(posedge pixel_clk or posedge RESET) begin : updateReadAddress
    if (RESET == 1'b1) begin
     lADDR <= 'd0;
   end
   else begin
     if (displayTime == 1'b1) begin
        lADDR <= lADDR + 16'd1;
      end
   end
  end : updateReadAddress

endmodule : VGA
