module ALU (
  input  logic ACLK,
  input  logic RESET,
  input  logic [31:0] A,
  input  logic [31:0] B,
  input  logic [ 4:0] aluop,
  output logic [31:0] ALUResult
);
  // multiplication
  logic [63:00] multiplication_signed, multiplication_unsigned, multiplication_signed_unsigned;
  mul mul_signed(
  .aclr(RESET),
  .clken(1'b1),
  .clock(ACLK),
  .dataa(A),
  .datab(B),
  .result(multiplication_signed)
  );
  mulu mul_unsigned(
  .clock(ACLK),
  .dataa(A),
  .datab(B),
  .result(multiplication_unsigned));
//  assign multiplication_signed = $signed(A) * $signed(B);
//  assign multiplication_unsigned = A * B;
//  assign multiplication_signed_unsigned = $signed(A) * B;
  assign multiplication_signed_unsigned = multiplication_signed;

  // division
  logic [31:00] division_signed, division_unsigned, remainder_signed, remainder_unsigned;
  div div_signed(
  .aclr(RESET),
  .clken(1'b1),
  .clock(ACLK),
  .denom(B),
  .numer(A),
  .quotient(division_signed),
  .remain(remainder_signed)
  );
   divu div_unsigned(
  .aclr(RESET),
  .clken(1'b1),
  .clock(ACLK),
  .denom(B),
  .numer(A),
  .quotient(division_unsigned),
  .remain(remainder_unsigned)
  );
//  assign division_signed = $signed(A) / $signed(B);
//  assign division_unsigned = A / B;
//  assign remainder_signed = $signed(A) % $signed(B);
//  assign remainder_unsigned = A % B;
  always_comb begin
    case (aluop)
      5'd00:    ALUResult = A  +  B; // ADD
      5'd01:    ALUResult = A  -  B; // SUB
      5'd02:    ALUResult = $signed(A) < $signed(B); // SLT
      5'd03:    ALUResult = A  <  B; // SLTU
      5'd04:    ALUResult = A  &  B; // AND
      5'd05:    ALUResult = A  |  B; // OR
      5'd06:    ALUResult = A  ^  B; // XOR
      5'd07:    ALUResult = A  << B[04:00]; // SLL
      5'd08:    ALUResult = A  >> B[04:00]; // SRL
      5'd09:    ALUResult = $signed(A) >>> B[04:00]; // SRA
      5'd10:    ALUResult = multiplication_signed[31:00]; // MUL
      5'd11:    ALUResult = multiplication_signed[63:32]; // MULH
      5'd12:    ALUResult = multiplication_unsigned[63:32]; // MULHU
      5'd13:    ALUResult = multiplication_signed_unsigned[63:32]; // MULHSU
      5'd14:    begin // DIV
                  if (A != 32'd0 && B == 32'd0) begin // Division By Zero
                    ALUResult = 32'hffffffff; // -1
                  end
                  else if (A == 32'h8000000 && B == 32'hffffffff) begin // Division overflow
                    ALUResult = 32'h8000000; // -2 ^ (L-1)
                  end
                  else begin // Normal Division
                    ALUResult = division_signed[31:00];
                  end
                end
      5'd15:    begin // DIVU
                  if (A != 32'd0 && B == 32'd0) begin // Division By Zero
                    ALUResult = 32'hffffffff; // 2^(L) - 1
                  end
                  else begin // Normal Division
                    ALUResult = division_unsigned[31:00];
                  end
                end
      5'd16:    begin // REM
                  if (A != 32'd0 && B == 32'd0) begin // Division By Zero
                    ALUResult = A;
                  end
                  else if (A == 32'h8000000 && B == 32'hffffffff) begin // Division overflow
                    ALUResult = 32'h0; // 0
                  end
                  else begin
                    ALUResult = remainder_signed[31:00];
                  end
                end
      5'd17:    begin // REMU
                  if (A != 32'd0 && B == 32'd0) begin // Division By Zero
                    ALUResult = A;
                  end
                  else begin
                    ALUResult = remainder_unsigned[31:00];
                  end
                end
      5'd18:    ALUResult = B; // pass B
      default: ALUResult = 32'd0;
    endcase
  end

endmodule
