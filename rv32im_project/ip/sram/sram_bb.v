
module sram (
	clk_clk,
	reset_reset,
	sram_DQ,
	sram_ADDR,
	sram_LB_N,
	sram_UB_N,
	sram_CE_N,
	sram_OE_N,
	sram_WE_N,
	sram_io_address,
	sram_io_byteenable,
	sram_io_read,
	sram_io_write,
	sram_io_writedata,
	sram_io_readdata,
	sram_io_readdatavalid);	

	input		clk_clk;
	input		reset_reset;
	inout	[15:0]	sram_DQ;
	output	[19:0]	sram_ADDR;
	output		sram_LB_N;
	output		sram_UB_N;
	output		sram_CE_N;
	output		sram_OE_N;
	output		sram_WE_N;
	input	[19:0]	sram_io_address;
	input	[1:0]	sram_io_byteenable;
	input		sram_io_read;
	input		sram_io_write;
	input	[15:0]	sram_io_writedata;
	output	[15:0]	sram_io_readdata;
	output		sram_io_readdatavalid;
endmodule
