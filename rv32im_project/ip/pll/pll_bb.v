
module pll (
	c0_clk,
	clk_clk,
	reset_reset,
	pll_pll_slave_read,
	pll_pll_slave_write,
	pll_pll_slave_address,
	pll_pll_slave_readdata,
	pll_pll_slave_writedata,
	pll_areset_conduit_export);	

	output		c0_clk;
	input		clk_clk;
	input		reset_reset;
	input		pll_pll_slave_read;
	input		pll_pll_slave_write;
	input	[1:0]	pll_pll_slave_address;
	output	[31:0]	pll_pll_slave_readdata;
	input	[31:0]	pll_pll_slave_writedata;
	input		pll_areset_conduit_export;
endmodule
