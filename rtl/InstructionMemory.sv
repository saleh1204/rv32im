module InstructionMemory #(
    parameter int    IMSIZE=1024,
    parameter        INIT_F="im.hex"
) (
    input  logic clk,
    input  logic [31:0] address,
    output logic [31:0] instruction
);
  // (* ram_init_file = "im.mif" *)
  logic [31:0] mem[0:IMSIZE-1];

  initial begin
    if (INIT_F != 0) begin
      $display("Creating instruction memory from init file '%s'.", INIT_F);
      $readmemh(INIT_F, mem);
    end
    else begin
      $display("Memory is not initialized");
    end
  end

  always_comb begin
    instruction = mem[address >> 2];
  end

endmodule
