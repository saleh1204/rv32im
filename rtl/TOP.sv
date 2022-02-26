module TOP (
  input  logic         ACLK,          // global clock
  input  logic         ARESETN,       // asynchronous reset (active low)
  //////////// VGA //////////
  output logic [07:00] VGA_B,
  output logic         VGA_BLANK_N,
  output logic         VGA_CLK,
  output logic [07:00] VGA_G,
  output logic         VGA_HS,
  output logic [07:00] VGA_R,
  output logic         VGA_SYNC_N,
  output logic         VGA_VS,
   //////////// LED //////////
  output logic [08:00] LEDG,
  output logic [17:00] LEDR,
  //////////// SW //////////
  input  logic [17:00] SW,
  //////////// SRAM //////////
  output logic [19:00] SRAM_ADDR,
  output logic         SRAM_CE_N,
  inout  logic [15:00] SRAM_DQ,
  output logic         SRAM_LB_N,
  output logic         SRAM_OE_N,
  output logic         SRAM_UB_N,
  output logic         SRAM_WE_N
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

//  VGA vga (
//   .ACLK(ACLK),
//   .RESET(~ARESETN),
//   .DATA_I(DATA_OUT_CPU),
//   .ADDR(ADDR),
//   .WRSTB(WRSTB),
//   .hsync(VGA_HS),
//   .vsync(VGA_VS),
//   .vga_clk(VGA_CLK),
//   .VGA_BLANK_N(VGA_BLANK_N),
//   .VGA_SYNC_N(VGA_SYNC_N),
//   .RED(VGA_R),
//   .GREEN(VGA_G),
//   .BLUE(VGA_B))
//   ;

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
    .SW(SW)
  );
endmodule: TOP
