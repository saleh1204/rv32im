module ForwardingUnit (
    input  logic [04:00] rs1,
    input  logic [04:00] rs2,
    input  logic [04:00] rd3,
    input  logic [04:00] rd4,
    input  logic [04:00] rd5,
    input  logic         regWrite3,
    input  logic         regWrite4,
    input  logic         regWrite5,
    input  logic         memRead3,
    output logic [01:00] forwardA,
    output logic [01:00] forwardB,
    output logic         stall
);
    always_comb begin
       if (rs1 != 5'd0 && rs1 == rd3 && regWrite3 == 1'b1) begin
           forwardA = 2'd1;
       end
       else if (rs1 != 5'd0 && rs1 == rd4 && regWrite4 == 1'b1) begin
           forwardA = 2'd2;
       end
       else if (rs1 != 5'd0 && rs1 == rd5 && regWrite5 == 1'b1) begin
           forwardA = 2'd3;
       end
       else begin
           forwardA = 2'd0;
       end
        if (rs2 != 5'd0 && rs2 == rd3 && regWrite3 == 1'b1) begin
           forwardB = 2'd1;
       end
       else if (rs2 != 5'd0 && rs2 == rd4 && regWrite4 == 1'b1) begin
           forwardB = 2'd2;
       end
       else if (rs2 != 5'd0 && rs2 == rd5 && regWrite5 == 1'b1) begin
           forwardB = 2'd3;
       end
       else begin
           forwardB = 2'd0;
       end
       if (memRead3 == 1'b1 && (forwardA == 2'd1 || forwardB == 2'd1)) begin
           stall = 1'b1;
       end
       else begin
           stall = 1'b0;
       end
    end
endmodule
