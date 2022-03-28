	pll u0 (
		.c0_clk                    (<connected-to-c0_clk>),                    //                 c0.clk
		.clk_clk                   (<connected-to-clk_clk>),                   //                clk.clk
		.reset_reset               (<connected-to-reset_reset>),               //              reset.reset
		.pll_pll_slave_read        (<connected-to-pll_pll_slave_read>),        //      pll_pll_slave.read
		.pll_pll_slave_write       (<connected-to-pll_pll_slave_write>),       //                   .write
		.pll_pll_slave_address     (<connected-to-pll_pll_slave_address>),     //                   .address
		.pll_pll_slave_readdata    (<connected-to-pll_pll_slave_readdata>),    //                   .readdata
		.pll_pll_slave_writedata   (<connected-to-pll_pll_slave_writedata>),   //                   .writedata
		.pll_areset_conduit_export (<connected-to-pll_areset_conduit_export>)  // pll_areset_conduit.export
	);

