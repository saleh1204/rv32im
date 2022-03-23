module GPIO #(
  parameter int BASEADDRESS = 32'h8000_0000,
  parameter int NOREGISTERS = 32'h0000_0004
) (
  input       logic         ACLK,
  input       logic         RESET,
  input       logic [31:00] DATA_I,
  output      logic [31:00] DATA_O,
  input       logic [31:00] ADDR,
  input       logic         WRSTB,
  input       logic         RDSTB,
  //////////// LED //////////
  output      logic [08:00] LEDG,
  output      logic [17:00] LEDR,
  //////////// SW //////////
  input       logic [17:00] SW,
    //////////// SEG7 //////////
  output		  logic [06:00]	HEX0,
  output		  logic [06:00] HEX1,
  output		  logic [06:00] HEX2,
  output		  logic [06:00] HEX3,
  output		  logic [06:00] HEX4,
  output		  logic [06:00] HEX5,
  output		  logic [06:00] HEX6,
  output		  logic [06:00] HEX7
);

  logic [31:00] gpio_registers[00:NOREGISTERS-1];

  assign LEDG = gpio_registers[0][08:00];
  assign LEDR = gpio_registers[0][26:09];

  assign HEX0 = gpio_registers[2][06:00];
  assign HEX1 = gpio_registers[2][14:08];
  assign HEX2 = gpio_registers[2][22:16];
  assign HEX3 = gpio_registers[2][30:24];
  assign HEX4 = gpio_registers[3][06:00];
  assign HEX5 = gpio_registers[3][14:08];
  assign HEX6 = gpio_registers[3][22:16];
  assign HEX7 = gpio_registers[3][30:24];

  always_ff @(posedge ACLK or posedge RESET) begin: updateGPIORegs
    if (RESET == 1'b1) begin
      for (int i=0; i<NOREGISTERS; ++i) begin
        gpio_registers[i] <= 32'd0;
      end
    end
   else begin
     if (WRSTB == 1'b1 && ADDR >= BASEADDRESS && ADDR < (BASEADDRESS + NOREGISTERS)) begin
      gpio_registers[ADDR[03:00]] <= DATA_I;
     end
     else begin
       gpio_registers[1] <= SW;
     end
     if (RDSTB == 1'b1 && ADDR >= BASEADDRESS && ADDR < (BASEADDRESS + NOREGISTERS)) begin
      DATA_O <= gpio_registers[ADDR[03:00]];
     end
     else begin
      DATA_O <= 32'dz;
     end
   end
  end: updateGPIORegs

endmodule: GPIO
