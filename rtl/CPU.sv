module CPU (
    // AMBA 4 AXI 4 (manager)
    input  logic         ACLK,          // global clock
    input  logic         RESET,         // asynchronous reset (active high)
    // Master Interface Write Address
//    output logic         M_AXI_AWID,    // master write address ID
//    output logic [31:00] M_AXI_AWADDR,  // master write address
//    output logic [07:00] M_AXI_AWLEN,   // burst length
//    output logic [02:00] M_AXI_AWSIZE,  // burst size
//    output logic [02:00] M_AXI_AWBURST, // burst type
//    output logic         M_AXI_AWLOCK,  // lock type
//    output logic [03:00] M_AXI_AWCACHE, // memory type
//    output logic [02:00] M_AXI_AWPROT,  // protection type
//    output logic [03:00] M_AXI_AWQOS,   // Quality of Service (QoS)
//    // output logic [03:00] M_AXI_AWQOS,   // Region Identifier (size not sure yet)
//    output logic         M_AXI_AWUSER,  // User Signal
//    output logic         M_AXI_AWVALID, // write address is valid (from master)
//    input  logic         M_AXI_AWREADY, // write address is ready (from slave)
//    // Master Interface Write Data
//    output logic [31:00] M_AXI_WDATA,   // Write Data
//    output logic [03:00] M_AXI_WRSTB,   // Write Strobe
//    output logic         M_AXI_WLAST,   // write Last
//    output logic         M_AXI_WVALID,  // Data Valid (from master)
//    input  logic         M_AXI_WREADY,   // Data Ready (from slave)


   output logic [31:00] ADDR,
   input  logic [31:00] DATA_I,
   output logic [31:00] DATA_O,
   output logic         WRSTB,
   output logic         RDSTB
);
    // instruction and program counter
    logic [31:00] instruction1, instruction2;
    logic [31:00] program_counter1, program_counter2, program_counter3, program_counter4;

    // instruction parts
    logic [06:00] opcode;
    logic [04:00] rs1;
    logic [04:00] rs2;
    logic [04:00] rd2, rd3, rd4, rd5;
    logic [02:00] func3;
    logic [06:00] func7;
    logic [11:00] immI12;
    logic [11:00] immS12;
    logic [12:00] immB13;
    logic [19:00] immU20;
    logic [19:00] immJ20;

    // instruction immediates
    logic [31:00] immI32, immS32, immB32, immU32, immJ32;

    // Register File signals
    logic [31:00] busA2;
    logic [31:00] busB2, busB3, busB4;
    logic [31:00] busW5;
    logic         regWrite2, regWrite3, regWrite4, regWrite5;

    // Control Unit Signals
    logic [04:00] aluOP2;
    logic [01:00] portBSrc;
    logic [01:00] memNoBytes2, memNoBytes3, memNoBytes4;
    logic         memRead2, memRead3, memRead4;
    logic         memWrite2, memWrite3, memWrite4;
    logic         auipc2, jal2, jalr2, branch2;
    logic         stallALU2, stallALU3;
    logic [03:00] stallCycles2, stallCycles3;

    // Forwarding Unit Signals
    logic [01:00] forwardA, forwardB;
    logic         stall;

    // ALU signals
    logic [31:00] portA2, portA3;
    logic [31:00] portB2, portB3;
    logic [31:00] aluResult3, aluResult4;
    logic [04:00] aluOP3;

    // Data Memory Signals
    logic [31:00] memResult4;

    // Bus W Selection Lines
    logic [01:00] busWSel2, busWSel3, busWSel4;

    // Stage 1: Instruction Fetch
    // Instruction Fetch
    InstructionMemory #(.IMSIZE(1024)) im
    (   .clk(ACLK), .address(program_counter1), .instruction(instruction1));

    always_ff @(posedge ACLK or posedge RESET) begin
        if (RESET == 1'b1) begin
            instruction2 <= 32'd0;
        end
        else if (jal2 == 1'b1 || jalr2 == 1'b1 || branch2 == 1'b1) begin
            instruction2 <= 32'd0;
        end
        else if (stallALU3 == 1'b1) begin
          instruction2 <= instruction2;
        end
        else begin
          instruction2 <= instruction1;
        end
    end
    // Stage 2: Instruction Decode, Register File and Conteol Unit
    // Instruction Decoding
    assign opcode = instruction2[06:00];
    assign rd2    = instruction2[11:07];
    assign rs1    = instruction2[19:15];
    assign rs2    = instruction2[24:20];
    assign func3  = instruction2[14:12];
    assign func7  = instruction2[31:25];
    assign immI12 = instruction2[31:20];
    assign immS12 = {instruction2[31:25], instruction2[11:07]};
    assign immB13 = {instruction2[31], instruction2[7],
                    instruction2[30:25], instruction2[11:08], 1'b0};
    assign immU20 = instruction2[31:12];
    assign immJ20 = {instruction2[31], instruction2[19:12],
                    instruction2[20], instruction2[30:21], 1'b0}; // Check this one

    // Immediates construction
    assign immI32 = {{20{immI12[11]}},immI12};
    assign immS32 = {{20{immS12[11]}},immS12};
    assign immB32 = {{19{immB13[11]}},immB13};
    assign immU32 = {immU20, 12'd0};
    assign immJ32 = {{12{immJ20[11]}},immJ20};

    // Register File
    RegisterFile rf
    (   .clk(ACLK), .reset(RESET), .rs1(rs1), .rs2(rs2), .rd(rd5),
        .RegWrite(regWrite5), .BusW(busW5), .BusA(busA2), .BusB(busB2));

    // always block to propogate the signals from the second stage to the other stages.
    always_ff @(posedge ACLK or posedge RESET) begin
        if (RESET == 1'b1) begin
            regWrite3        <= 1'b0;
            regWrite4        <= 1'b0;
            regWrite5        <= 1'b0;
            rd3              <= 5'd0;
            rd4              <= 5'd0;
            rd5              <= 5'd0;
            aluOP3           <= 5'd0;
            memRead3         <= 1'b0;
            memWrite3        <= 1'b0;
            memRead4         <= 1'b0;
            memWrite4        <= 1'b0;
            busB3            <= 32'd0;
            busB4            <= 32'd0;
            portA3           <= 32'd0;
            portB3           <= 32'd0;
            memNoBytes3      <= 2'd0;
            memNoBytes4      <= 2'd0;
            busWSel3         <= 2'd0;
            busWSel4         <= 2'd0;
            aluResult4       <= 32'd0;
            program_counter2 <= 32'd0;
            program_counter3 <= 32'd0;
            program_counter4 <= 32'd0;
            busW5            <= 32'd0;
        end
        else begin
            if (stall == 1'b1) begin
                regWrite3   <= 1'b0;
                memRead3    <= 1'b0;
                memWrite3   <= 1'b0;
            end
            else if (stallALU3 == 1'b1) begin
                regWrite4        <= 1'b0;
                rd3              <= rd3;
                rd4              <= 5'd0;
                aluOP3           <= aluOP3;
                program_counter2 <= program_counter2;
                program_counter3 <= program_counter3;
                program_counter4 <= program_counter4;
            end
            else begin
                regWrite4        <= regWrite3;
                rd3              <= rd2;
                rd4              <= rd3;
                aluOP3           <= aluOP2;
                program_counter2 <= program_counter1;
                program_counter3 <= program_counter2;
                program_counter4 <= program_counter3;
                regWrite3   <= regWrite2;
                memRead3    <= memRead2;
                memWrite3   <= memWrite2;
            end
            case (forwardB)
              2'd0: 
                busB3 <= busB2;
              2'd1: 
                busB3 <= aluResult3;
              2'd2: 
                busB3 <= memResult4;
              2'd3:
                busB3 <= busW5;
              default: 
                busB3 <= 32'd0;
            endcase
            regWrite5        <= regWrite4;
            rd5              <= rd4;
            memRead4         <= memRead3;
            memWrite4        <= memWrite3;
            busB4            <= busB3;
            portA3           <= portA2;
            portB3           <= portB2;
            memNoBytes3      <= memNoBytes2;
            memNoBytes4      <= memNoBytes3;
            busWSel3         <= busWSel2;
            busWSel4         <= busWSel3;
            aluResult4       <= aluResult3;
            busW5            <= memResult4;
        end
    end
    // Control Unit
    ControlUnit cu
    (   .opcode(opcode), .func3(func3), .func7(func7),
        .RegWrite(regWrite2), .portBSrc(portBSrc), .aluop(aluOP2),
        .memRead(memRead2), .memWrite(memWrite2), .memNoBytes(memNoBytes2),
        .auipc(auipc2), .jal(jal2), .jalr(jalr2), .branch(branch2),
        .busWSel(busWSel2), .portA(portA2), .portB(portB2),
        .stallALU(stallALU2), .stallCycles(stallCycles2));

    // Forwarding Unit
    ForwardingUnit fw
    (   .rs1(rs1), .rs2(rs2), .rd3(rd3), .rd4(rd4), .rd5(rd5),
        .regWrite3(regWrite3), .regWrite4(regWrite4), .regWrite5(regWrite5),
        .memRead3(memRead3), .forwardA(forwardA), .forwardB(forwardB), .stall(stall));

    always_comb  begin
      if (auipc2 == 1'b1) begin
        portA2 = program_counter2;
      end
      else begin
        case (forwardA)
          2'd0: // Register File
            portA2 = busA2;
          2'd1: // Stage 3: ALU Result
            portA2 = aluResult3;
          2'd2: // Stage 4: Memory
            portA2 = memResult4;
          2'd3: // Stage 5: Write Back Stage
            portA2 = busW5;
          default:
            portA2 = 32'd0;
        endcase
      end
      case (portBSrc)
        2'd0: // Register
          begin
            case (forwardB)
              2'd0: // Register File
                portB2 = busB2;
              2'd1: // Stage 3: ALU Result
                portB2 = aluResult3;
              2'd2: // Stage 4: Memory
                portB2 = memResult4;
              2'd3: // Stage 5: Write Back Stage
                portB2 = busW5;
              default:
                portB2 = 32'd0;
            endcase
          end
        2'd1: // I-Immediate
          portB2 = immI32;
        2'd2: // S-Immediate
          portB2 = immS32;
        2'd3: // U-Immediate
          portB2 = immU32;
        default:
          portB2 = 32'd0;
      endcase
    end
    // Stage 3: Execution
    always_ff @(posedge ACLK or posedge RESET) begin
      if (RESET == 1'b1) begin
        stallCycles3 <= 4'd0;
        stallALU3    <= 1'b0;
      end
      else begin
        if (stallALU2 == 1'b1 && stallALU3 == 1'b0) begin
          stallALU3    <= 1'b1;
          stallCycles3 <= stallCycles2;
        end
        else if (stallCycles3 == 4'd1) begin
          stallCycles3 <= stallCycles3 - 4'd1;
          stallALU3    <= 1'b0;
        end
        else if (stallCycles3 != 4'd0) begin
          stallCycles3 <= stallCycles3 - 4'd1;
          stallALU3    <= 1'b1;
        end
      end
    end
    ALU alu (.ACLK(ACLK), .RESET(RESET), .A(portA3), .B(portB3), .aluop(aluOP3), .ALUResult(aluResult3));
    // Stage 4: Memory Read and Write
    assign ADDR = aluResult4;
    assign WRSTB = memWrite4;
    assign RDSTB = memRead4;
    assign DATA_O = busB4;

    // Place Holder until AXI interface is implemented
    // Stage 5: Write Back
    always_comb begin
      case (busWSel4)
        2'd0:
            memResult4 = aluResult4;
        2'd1: begin
        case(memNoBytes4)
          2'd0:
          memResult4 = {24'd0,DATA_I[07:00]};
          2'd1:
          memResult4 = {16'd0,DATA_I[15:00]};
          2'd2:
          memResult4 = DATA_I;
          default:
          memResult4 = 32'd0;
        endcase
        end
        2'd2:
            memResult4 = program_counter4 + 32'd4;
        default:
            memResult4 = 32'd0;
      endcase
    end
    // Stage 5: Write Back

    // Update program counter
    always_ff @(posedge ACLK or posedge RESET) begin
      if (RESET == 1'b1) begin
        program_counter1 <= 32'd0;
      end
      else begin
        if (stall == 1'b1 || stallALU3 == 1'b1) begin
          program_counter1 <= program_counter1;
        end
        else begin
          if (jal2 == 1'b1) begin
            program_counter1 <= program_counter2 + immJ32;
          end
          else if (jalr2 == 1'b1) begin
            // the lsb should be 0
            program_counter1 <= portA2 + immI32;
          end
          else if (branch2 == 1'b1) begin
            program_counter1 <= program_counter2 + immB32;
          end
          else begin
            program_counter1 <= program_counter1 + 32'd4;
          end
        end
      end
    end

endmodule: CPU
