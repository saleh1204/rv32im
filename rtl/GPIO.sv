module GPIO #(
  parameter int BASEADDRESS = 32'h8000_0000,
  parameter int NOREGISTERS = 32'h0000_0002
) (
  input  logic         ACLK,
  input  logic         RESET,
  input  logic [31:00] DATA_I,
  output logic [31:00] DATA_O,
  input  logic [31:00] ADDR,
  input  logic         WRSTB,
  input  logic         RDSTB,
  //////////// LED //////////
  output logic [08:00] LEDG,
  output logic [17:00] LEDR,
  //////////// SW //////////
  input  logic [17:00] SW
);

  logic [31:00] gpio_registers[00:NOREGISTERS-1];

  assign LEDG = gpio_registers[0][08:00];
  assign LEDR = gpio_registers[0][26:09];

  always_ff @(posedge ACLK or posedge RESET) begin
    if (RESET == 1'b1) begin
      for (int i=0; i<NOREGISTERS; ++i) begin
        gpio_registers[i] <= 32'd0;
      end
    end
    else if (WRSTB == 1'b1 && ADDR >= BASEADDRESS && ADDR < (BASEADDRESS + NOREGISTERS)) begin
      gpio_registers[ADDR[02:00]] <= DATA_I;
    end
    else if (RDSTB == 1'b1 && ADDR >= BASEADDRESS && ADDR < (BASEADDRESS + NOREGISTERS)) begin
      DATA_O <= gpio_registers[ADDR[02:00]];
    end
    else begin
      DATA_O <= 32'dz;
    end
  end

endmodule: GPIO
