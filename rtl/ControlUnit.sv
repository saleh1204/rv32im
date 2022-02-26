module ControlUnit (
    input  logic [06:00] opcode,
    input  logic [02:00] func3,
    input  logic [06:00] func7,
    input  logic [31:00] portA,
    input  logic [31:00] portB,
    output logic         RegWrite,
    output logic [01:00] portBSrc,
    output logic [04:00] aluop,
    output logic         stallALU,
    output logic [03:00] stallCycles,
    output logic         memRead,
    output logic         memWrite,
    output logic [01:00] memNoBytes,
    output logic [01:00] busWSel,
    output logic         auipc,
    output logic         jal,
    output logic         jalr,
    output logic         branch
);

  always_comb begin
    RegWrite    = 1'b0;
    portBSrc    = 2'd0;
    aluop       = 5'd0;
    memRead     = 1'b0;
    memWrite    = 1'b0;
    memNoBytes  = 2'd0;
    auipc       = 1'b0;
    jal         = 1'b0;
    jalr        = 1'b0;
    branch      = 1'b0;
    busWSel     = 2'd0;
    stallALU    = 1'b0;
    stallCycles = 4'd0;
    case (opcode)
      7'b0110111: // LUI
        begin
          aluop    = 5'd18; // pass B
          RegWrite = 1'd1;  // Write to register rd
          portBSrc = 2'd3;  // pass U-Immediate
        end
      7'b0010111: // AUIPC
        begin
          aluop    = 5'd0; // ADD
          RegWrite = 1'd1; // Write to register rd
          portBSrc = 2'd3; // pass U-Immediate
          auipc    = 1'b1; // AUIPC instruction, pass program_counter in port A
        end
      7'b1101111: // JAL
        begin
          RegWrite = 1'b1;  // Write to register rd
          jal      = 1'b1;  // JAL instruction
          busWSel  = 2'd2;  // Store PC + 4
        end
      7'b1100111: // JALR
        begin
          if (func3 == 3'd0) begin
            RegWrite = 1'd1;  // Write to register rd
            jalr     = 1'b1;  // JALR instruction
            portBSrc = 2'd1;  // pass I-Immediate
            busWSel  = 2'd2;  // Store PC + 4
          end
        end
      7'b1100011: // Branch instructions
        begin
          case (func3)
            3'b000: // BEQ
              begin
                branch = portA == portB; // EQ
              end
            3'b001: // BNE
              begin
                branch = portA != portB; // NE
              end
            3'b100: // BLT
              begin
                branch = $signed(portA) < $signed(portB); // LT
              end
            3'b101: // BGE
              begin
                branch = $signed(portA) >= $signed(portB); // GE
              end
            3'b110: // BLTU
              begin
                branch = portA < portB; // LTU
              end
            3'b111: // BGEU
              begin
                branch = portA >= portB; // GEU
              end
            default:
              begin
                branch = 1'b0;
              end
          endcase
        end
      7'b0000011: // Memory Load instructions
        begin
          case (func3)
            3'b000: // LB
              begin
                RegWrite   = 1'b1;  // Write to register rd
                memRead    = 1'b1;  // Read from Data Memory
                memNoBytes = 2'd0;  // Load Single Byte
                aluop      = 5'd0;  // ADD
                busWSel    = 2'd1;  // store memory result
              end
            3'b001: // LH
              begin
                RegWrite   = 1'b1;  // Write to register rd
                memRead    = 1'b1;  // Read from Data Memory
                memNoBytes = 2'd1;  // Load Two Bytes
                aluop      = 5'd0;  // ADD
                busWSel    = 2'd1;  // store memory result
              end
            3'b010: // LW
              begin
                RegWrite   = 1'b1;  // Write to register rd
                memRead    = 1'b1;  // Read from Data Memory
                memNoBytes = 2'd2;  // Load Four Bytes
                aluop      = 5'd0;  // ADD
                busWSel    = 2'd1;  // store memory result
              end
            3'b100: // LBU
              begin
                RegWrite   = 1'b1;  // Write to register rd
                memRead    = 1'b1;  // Read from Data Memory
                memNoBytes = 2'd0;  // Load Single Byte
                aluop      = 5'd0;  // ADD
                busWSel    = 2'd1;  // store memory result
              end
            3'b101: // LHU
              begin
                RegWrite   = 1'b1;  // Write to register rd
                memRead    = 1'b1;  // Read from Data Memory
                memNoBytes = 2'd1;  // Load Two Bytes
                aluop      = 5'd0;  // ADD
                busWSel    = 2'd1;  // store memory result
              end
            default:
              begin
                RegWrite   = 1'b0;
                memRead    = 1'b0;
              end
          endcase
        end
      7'b0100011: // Memory Store instructions
        begin
          case (func3)
            3'b000: // SB
              begin
                memWrite   = 1'b1;  // Write to Data Memory
                memNoBytes = 2'd0;  // Store Single Byte
                aluop      = 5'd0;  // ADD
              end
            3'b001: // SH
              begin
                memWrite   = 1'b1;  // Write to Data Memory
                memNoBytes = 2'd1;  // Store Two Bytes
                aluop      = 5'd0;  // ADD
              end
            3'b010: // SW
              begin
                memWrite   = 1'b1;  // Write to Data Memory
                memNoBytes = 2'd2;  // Store Four Bytes
                aluop      = 5'd0;  // ADD
              end
            default:
              begin
                memWrite   = 1'b0;
              end
          endcase
        end
      7'b0010011: // I-Type Instructions
        begin
          case (func3)
            3'b000: // ADDI
            begin
              aluop      = 5'd0;  // ADD
              portBSrc   = 2'd1;  // pass I-Immediate
              RegWrite   = 1'b1;  // Write to register rd
            end
            3'b010: // SLTI
            begin
              aluop      = 5'd2;  // SLT
              portBSrc   = 2'd1;  // pass I-Immediate
              RegWrite   = 1'b1;  // Write to register rd
            end
            3'b011: // SLTIU
            begin
              aluop      = 5'd3;  // SLTU
              portBSrc   = 2'd1;  // pass I-Immediate
              RegWrite   = 1'b1;  // Write to register rd
            end
            3'b100: // XORI
            begin
              aluop      = 5'd6;  // XOR
              portBSrc   = 2'd1;  // pass I-Immediate
              RegWrite   = 1'b1;  // Write to register rd
            end
            3'b110: // ORI
            begin
              aluop      = 5'd5;  // OR
              portBSrc   = 2'd1;  // pass I-Immediate
              RegWrite   = 1'b1;  // Write to register rd
            end
            3'b111: // ANDI
            begin
              aluop      = 5'd4;  // AND
              portBSrc   = 2'd1;  // pass I-Immediate
              RegWrite   = 1'b1;  // Write to register rd
            end
            3'b001: // SLLI
            begin
              aluop      = 5'd7;  // SLL
              portBSrc   = 2'd1;  // pass I-Immediate
              RegWrite   = 1'b1;  // Write to register rd
            end
            3'b101: // SRLI/SRAI
            begin
              if (func7 == 7'd0) begin
                // SRLI
                aluop      = 5'd8;  // SRL
                portBSrc   = 2'd1;  // pass I-Immediate
                RegWrite   = 1'b1;  // Write to register rd
              end
              else begin
                // SRAI
                aluop      = 5'd9;  // SRA
                portBSrc   = 2'd1;  // pass I-Immediate
                RegWrite   = 1'b1;  // Write to register rd
              end
            end
          endcase
        end
      7'b0110011: // R-Type Instructions
        begin
          if (func7 == 7'b0000001) begin // M-Extension
            case (func3)
              3'b000: // MUL
                begin
                  aluop       = 5'd10; // MUL
                  RegWrite    = 1'b1;  // Write to register rd
                  stallALU    = 1'b1;  // Stall system for mul
                  stallCycles = 4'd3;  // stall for 3 cycles
                end
              3'b001: // MULH
                begin
                  aluop       = 5'd11; // MULH
                  RegWrite    = 1'b1;  // Write to register rd
                  stallALU    = 1'b1;  // Stall system for mul
                  stallCycles = 4'd3;  // stall for 3 cycles
                end
              3'b010: // MULHSU
                begin
                  aluop       = 5'd13; // MULHSU
                  RegWrite    = 1'b1;  // Write to register rd
                  stallALU    = 1'b1;  // Stall system for mul
                  stallCycles = 4'd3;  // stall for 3 cycles
                end
              3'b011: // MULHU
                begin
                  aluop       = 5'd12; // MULHU
                  RegWrite    = 1'b1;  // Write to register rd
                  stallALU    = 1'b1;  // Stall system for mul
                  stallCycles = 4'd3;  // stall for 3 cycles
                end
              3'b100: // DIV
                begin
                  aluop       = 5'd14; // DIV
                  RegWrite    = 1'b1;  // Write to register rd
                  stallALU    = 1'b1;  // Stall system for div
                  stallCycles = 4'd11;  // stall for 11 cycles
                end
              3'b101: // DIVU
                begin
                  aluop       = 5'd15; // DIVU
                  RegWrite    = 1'b1;  // Write to register rd
                  stallALU    = 1'b1;  // Stall system for div
                  stallCycles = 4'd11;  // stall for 11 cycles
                end
              3'b110: // REM
                begin
                  aluop       = 5'd16; // REM
                  RegWrite    = 1'b1;  // Write to register rd
                  stallALU    = 1'b1;  // Stall system for div
                  stallCycles = 4'd11;  // stall for 11 cycles
                end
              3'b111: // REMU
                begin
                  aluop       = 5'd17; // REMU
                  RegWrite    = 1'b1;  // Write to register rd
                  stallALU    = 1'b1;  // Stall system for div
                  stallCycles = 4'd11;  // stall for 11 cycles
                end
            endcase
          end
          else begin
            case (func3)
              3'b000: // ADD/SUB
                begin
                  if (func7 == 7'd0) begin
                      // ADD
                    aluop      = 5'd0;  // ADD
                    RegWrite   = 1'b1;  // Write to register rd
                    stallALU    = 1'b0;
                    stallCycles = 4'd0;
                  end
                  else begin
                      // SUB
                    aluop      = 5'd1;  // SUB
                    RegWrite   = 1'b1;  // Write to register rd
                    stallALU    = 1'b0;
                    stallCycles = 4'd0;
                  end
                end
              3'b010: // SLT
                begin
                  aluop      = 5'd2;  // SLT
                  RegWrite   = 1'b1;  // Write to register rd
                  stallALU    = 1'b0;
                  stallCycles = 4'd0;
                end
              3'b011: // SLTU
                begin
                  aluop      = 5'd3;  // SLTU
                  RegWrite   = 1'b1;  // Write to register rd
                  stallALU    = 1'b0;
                  stallCycles = 4'd0;
                end
              3'b100: // XORI
                begin
                  aluop      = 5'd6;  // XOR
                  RegWrite   = 1'b1;  // Write to register rd
                  stallALU    = 1'b0;
                  stallCycles = 4'd0;
                end
              3'b110: // OR
                begin
                  aluop      = 5'd5;  // OR
                  RegWrite   = 1'b1;  // Write to register rd
                  stallALU    = 1'b0;
                  stallCycles = 4'd0;
                end
              3'b111: // AND
                begin
                  aluop      = 5'd4;  // AND
                  RegWrite   = 1'b1;  // Write to register rd
                  stallALU    = 1'b0;
                  stallCycles = 4'd0;
                end
              3'b001: // SLL
                begin
                  aluop      = 5'd7;  // SLL
                  RegWrite   = 1'b1;  // Write to register rd
                  stallALU    = 1'b0;
                  stallCycles = 4'd0;
                end
              3'b101: // SRL/SRA
                begin
                  if (func7 == 7'd0) begin
                      // SRL
                    aluop      = 5'd8;  // SRL
                    RegWrite   = 1'b1;  // Write to register rd
                    stallALU    = 1'b0;
                    stallCycles = 4'd0;
                  end
                  else begin
                      // SRA
                    aluop      = 5'd9;  // SRA
                    RegWrite   = 1'b1;  // Write to register rd
                    stallALU    = 1'b0;
                    stallCycles = 4'd0;
                  end
                end
            endcase
          end
        end
      default:
        begin
          RegWrite    = 1'b0;
          portBSrc    = 2'd0;
          aluop       = 5'd0;
          memRead     = 1'b0;
          memWrite    = 1'b0;
          memNoBytes  = 2'd0;
          auipc       = 1'b0;
          jal         = 1'b0;
          jalr        = 1'b0;
          branch      = 1'b0;
          busWSel     = 2'd0;
          stallALU    = 1'b0;
          stallCycles = 4'd0;
        end
    endcase
  end
endmodule
