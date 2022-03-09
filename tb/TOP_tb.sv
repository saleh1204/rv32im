`timescale 1 ps/ 1 ps
module TOP_tb;

    //`timescale 1ps/1ps;
    logic 		CLK, RESET;
	logic [08:00] LEDG;
	logic [17:00] LEDR;

    TOP dut (.ACLK(CLK), .ARESETN(RESET), .LEDG(LEDG), .LEDR(LEDR));

    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, TOP_tb);
        RESET = 1'b1;
        CLK = 1'b0;
        @(negedge CLK)
        RESET = 1'b0;
        repeat(10) @(negedge CLK);
        RESET = 1'b1;
        repeat(100) @(negedge CLK);
        $stop;
    end
    always begin
        #5 CLK = ~CLK;
    end

endmodule: TOP_tb
