module DataMemory #(
    parameter int DMSIZE=1024,
    parameter int BASEADDRESS = 32'h0000_0000
) (
    // AXI4-Lite Slave Interface
    input  logic ACLK,
    input  logic RDSTB,
    input  logic WRSTB,
    input  logic [31:0] ADDR,
    input  logic [31:0] DATA_I,
    output logic [31:0] DATA_O
);
  logic [31:0] mem[0:DMSIZE-1];
  always_ff @(posedge ACLK) begin
    if (RDSTB == 1'b1 && ADDR >= BASEADDRESS && ADDR < (BASEADDRESS + DMSIZE)) begin
      DATA_O <= mem[ADDR];
    end
    else begin
      DATA_O <= 32'dz;
    end
    if (WRSTB == 1'b1 && ADDR >= BASEADDRESS && ADDR < (BASEADDRESS + DMSIZE)) begin
      mem[ADDR] <= DATA_I;
    end
  end
endmodule
