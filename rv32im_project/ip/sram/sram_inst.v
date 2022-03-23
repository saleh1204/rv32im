	sram u0 (
		.clk_clk               (<connected-to-clk_clk>),               //     clk.clk
		.reset_reset           (<connected-to-reset_reset>),           //   reset.reset
		.sram_DQ               (<connected-to-sram_DQ>),               //    sram.DQ
		.sram_ADDR             (<connected-to-sram_ADDR>),             //        .ADDR
		.sram_LB_N             (<connected-to-sram_LB_N>),             //        .LB_N
		.sram_UB_N             (<connected-to-sram_UB_N>),             //        .UB_N
		.sram_CE_N             (<connected-to-sram_CE_N>),             //        .CE_N
		.sram_OE_N             (<connected-to-sram_OE_N>),             //        .OE_N
		.sram_WE_N             (<connected-to-sram_WE_N>),             //        .WE_N
		.sram_io_address       (<connected-to-sram_io_address>),       // sram_io.address
		.sram_io_byteenable    (<connected-to-sram_io_byteenable>),    //        .byteenable
		.sram_io_read          (<connected-to-sram_io_read>),          //        .read
		.sram_io_write         (<connected-to-sram_io_write>),         //        .write
		.sram_io_writedata     (<connected-to-sram_io_writedata>),     //        .writedata
		.sram_io_readdata      (<connected-to-sram_io_readdata>),      //        .readdata
		.sram_io_readdatavalid (<connected-to-sram_io_readdatavalid>)  //        .readdatavalid
	);

