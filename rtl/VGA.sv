//  Project: RISC-V CPU (RV32IM)
//  Module : VGA
//  Author : Saleh AlSaleh
module VGA #(
  parameter int WidthPixels  = 640,
  parameter int HFrontPorch  = 16,
  parameter int HSyncPulse   = 96,
  parameter int HBackPorch   = 48,
  parameter int HeightPixels = 480,
  parameter int VFrontPorch  = 10,
  parameter int VSyncPulse   = 2,
  parameter int VBackPorch   = 33,
  parameter int BASEADDRESS  = 32'h4000_0000
  // 	Pixel Frequency should be 25.175 MHz
)(
  input  logic         ACLK,
  input  logic         RESET,
  input  logic [31:00] DATA_I,
  input  logic [31:00] ADDR,
  input  logic         WRSTB,
  output logic         VGA_HS,
  output logic         VGA_VS,
  output logic         VGA_CLK,
  output logic         VGA_BLANK_N,
  output logic         VGA_SYNC_N,
  output logic [07:00] RED,
  output logic [07:00] GREEN,
  output logic [07:00] BLUE,
  //////////// SRAM //////////
  output logic [19:00] SRAM_ADDR,
  output logic         SRAM_CE_N,
  inout  logic [15:00] SRAM_DQ,
  output logic         SRAM_LB_N,
  output logic         SRAM_OE_N,
  output logic         SRAM_UB_N,
  output logic         SRAM_WE_N
);
  //  timeunit 1ns / 1ps;
  localparam int WholeLine = WidthPixels + HFrontPorch + HSyncPulse + HBackPorch;
  localparam int WholeFrame = HeightPixels + VFrontPorch + VSyncPulse + VBackPorch;

  logic [31:00] vmem[0:(WidthPixels*HeightPixels)-1];// replace by the SRAM
  logic [31:00] lADDR;
  logic [31:00] rgb_data;
  logic         read;

  logic pixel_clk, displayTime;
  logic [$clog2(WholeLine)-1:0] h_pixel_counter;
  logic [$clog2(WholeFrame)-1:0] v_pixel_counter;

  assign VGA_CLK = pixel_clk;
  assign VGA_SYNC_N = 1'b0;
  assign VGA_BLANK_N = 1'b0;

  assign VGA_HS = ~((h_pixel_counter >= (WidthPixels + HFrontPorch)) &&
                   (h_pixel_counter < (WidthPixels + HFrontPorch + HSyncPulse)));
  assign VGA_VS = ~((v_pixel_counter >= (HeightPixels + VFrontPorch)) &&
                   (v_pixel_counter < (HeightPixels + VFrontPorch + VSyncPulse)));
  assign displayTime = (h_pixel_counter < WidthPixels) && (v_pixel_counter < HeightPixels);
  assign read   = displayTime;
  assign RED    = (displayTime) ? rgb_data[07:00] : 8'd0;
  assign GREEN  = (displayTime) ? rgb_data[15:08] : 8'd0;
  assign BLUE   = (displayTime) ? rgb_data[23:16] : 8'd0;

  pll vga_pll_u0 (.areset(RESET), .inclk0(ACLK), .c0(pixel_clk));

  always_ff @(posedge ACLK or posedge RESET) begin
    if (RESET == 1'b1) begin
     rgb_data <= 'd0;
   end
   else begin
      if (read) begin
        rgb_data <= vmem[lADDR];
      end
      else
        if (WRSTB == 1'b1 && ADDR >= BASEADDRESS && ADDR < (BASEADDRESS + (WidthPixels*HeightPixels))) begin
            vmem[ADDR] <= DATA_I;
        end
      end
   end

  always_ff @(posedge ACLK or posedge RESET) begin : updateCounters
    if (RESET == 1'b1) begin
      h_pixel_counter <= 'd0;
      v_pixel_counter <= 'd0;
      lADDR           <= 'd0;
    end
    else begin
      if (displayTime == 1'b1) begin
        lADDR <= lADDR + 32'd1;
      end
      if (h_pixel_counter == WholeLine) begin
        h_pixel_counter <= 'd0;
        v_pixel_counter <= v_pixel_counter + 'd1;
        if (v_pixel_counter == WholeFrame) begin
          v_pixel_counter <= 'd0;
        end
      end
      else begin
        h_pixel_counter <= h_pixel_counter + 'd1;
      end
    end
  end : updateCounters

endmodule : VGA
