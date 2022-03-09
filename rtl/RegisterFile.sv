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
      regs[00] <= 32'h00000000;
      regs[01] <= 32'h00000000; // return address (ra)
      regs[02] <= 32'h7ffffff0; // stack pointer  (sp)
      regs[03] <= 32'h10000000; // global pointer (gp)
      regs[04] <= 32'h00000000; // thread pointer (tp)
      regs[05] <= 32'h00000000; // temp           (t0)
      regs[06] <= 32'h00000000; // temp           (t1)
      regs[07] <= 32'h00000000; // temp           (t2)
      regs[08] <= 32'h00000000;
      regs[09] <= 32'h00000000;
      regs[10] <= 32'h00000000;
      regs[11] <= 32'h00000000;
      regs[12] <= 32'h00000000;
      regs[13] <= 32'h00000000;
      regs[14] <= 32'h00000000;
      regs[15] <= 32'h00000000;
      regs[16] <= 32'h00000000;
      regs[17] <= 32'h00000000;
      regs[18] <= 32'h00000000;
      regs[19] <= 32'h00000000;
      regs[20] <= 32'h00000000;
      regs[21] <= 32'h00000000;
      regs[22] <= 32'h00000000;
      regs[23] <= 32'h00000000;
      regs[24] <= 32'h00000000;
      regs[25] <= 32'h00000000;
      regs[26] <= 32'h00000000;
      regs[27] <= 32'h00000000;
      regs[28] <= 32'h00000000;
      regs[29] <= 32'h00000000;
      regs[30] <= 32'h00000000;
      regs[31] <= 32'h00000000;
    end else if (RegWrite && rd != 'd0) begin
      regs[rd] <= BusW;
    end
  end

  always_comb begin
    BusA = regs[rs1];
    BusB = regs[rs2];
  end
endmodule: RegisterFile
