module CPU_tb;

  `timescale 1ps/1ps;
  logic CLK, RESET;

  CPU dut (.ACLK(CLK), .ARESETN(RESET));

  initial begin
    $dumpfile("cpu_tb.vcd");
    $dumpvars(0, CPU_tb);
    RESET = 1'b1;
    CLK = 1'b0;
    @(negedge CLK)
    RESET = 1'b0;
    repeat(10) @(negedge CLK);
    RESET = 1'b1;
    repeat(100) @(negedge CLK);
    $stop;
  end
  always_comb begin
    #5 CLK = ~CLK;
  end

endmodule: CPU_tb
