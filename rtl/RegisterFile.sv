module RegisterFile #(
    parameter int REG_WIDTH = 32,
    parameter int REG_COUNT = 32
) (
    input  logic clk,
    input  logic reset,
    input  logic [$clog2(REG_COUNT)-1:0] rs1,
    input  logic [$clog2(REG_COUNT)-1:0] rs2,
    input  logic [$clog2(REG_COUNT)-1:0] rd,
    input  logic RegWrite,
    input  logic [REG_WIDTH-1:0] BusW,
    output logic [REG_WIDTH-1:0] BusA,
    output logic [REG_WIDTH-1:0] BusB
);
  logic [REG_WIDTH-1:0] regs[0:REG_COUNT-1];
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      regs[00] <= 'd0;
      regs[01] <= 'd0;
      regs[02] <= 'd0;
      regs[03] <= 'd0;
      regs[04] <= 'd0;
      regs[05] <= 'd0;
      regs[06] <= 'd0;
      regs[07] <= 'd0;
      regs[08] <= 'd0;
      regs[09] <= 'd0;
      regs[10] <= 'd0;
      regs[11] <= 'd0;
      regs[12] <= 'd0;
      regs[13] <= 'd0;
      regs[14] <= 'd0;
      regs[15] <= 'd0;
      regs[16] <= 'd0;
      regs[17] <= 'd0;
      regs[18] <= 'd0;
      regs[19] <= 'd0;
      regs[20] <= 'd0;
      regs[21] <= 'd0;
      regs[22] <= 'd0;
      regs[23] <= 'd0;
      regs[24] <= 'd0;
      regs[25] <= 'd0;
      regs[26] <= 'd0;
      regs[27] <= 'd0;
      regs[28] <= 'd0;
      regs[29] <= 'd0;
      regs[30] <= 'd0;
      regs[31] <= 'd0;
    end else if (RegWrite && rd != 'd0) begin
      regs[rd] <= BusW;
    end
  end

  always_comb begin
    BusA = regs[rs1];
    BusB = regs[rs2];
  end
endmodule: RegisterFile
