// sram.v

// Generated using ACDS version 18.1 625

`timescale 1 ps / 1 ps
module sram (
		input  wire        clk_clk,               //     clk.clk
		input  wire        reset_reset,           //   reset.reset
		inout  wire [15:0] sram_DQ,               //    sram.DQ
		output wire [19:0] sram_ADDR,             //        .ADDR
		output wire        sram_LB_N,             //        .LB_N
		output wire        sram_UB_N,             //        .UB_N
		output wire        sram_CE_N,             //        .CE_N
		output wire        sram_OE_N,             //        .OE_N
		output wire        sram_WE_N,             //        .WE_N
		input  wire [19:0] sram_io_address,       // sram_io.address
		input  wire [1:0]  sram_io_byteenable,    //        .byteenable
		input  wire        sram_io_read,          //        .read
		input  wire        sram_io_write,         //        .write
		input  wire [15:0] sram_io_writedata,     //        .writedata
		output wire [15:0] sram_io_readdata,      //        .readdata
		output wire        sram_io_readdatavalid  //        .readdatavalid
	);

	sram_sram_0 sram_0 (
		.clk           (clk_clk),               //                clk.clk
		.reset         (reset_reset),           //              reset.reset
		.SRAM_DQ       (sram_DQ),               // external_interface.export
		.SRAM_ADDR     (sram_ADDR),             //                   .export
		.SRAM_LB_N     (sram_LB_N),             //                   .export
		.SRAM_UB_N     (sram_UB_N),             //                   .export
		.SRAM_CE_N     (sram_CE_N),             //                   .export
		.SRAM_OE_N     (sram_OE_N),             //                   .export
		.SRAM_WE_N     (sram_WE_N),             //                   .export
		.address       (sram_io_address),       //  avalon_sram_slave.address
		.byteenable    (sram_io_byteenable),    //                   .byteenable
		.read          (sram_io_read),          //                   .read
		.write         (sram_io_write),         //                   .write
		.writedata     (sram_io_writedata),     //                   .writedata
		.readdata      (sram_io_readdata),      //                   .readdata
		.readdatavalid (sram_io_readdatavalid)  //                   .readdatavalid
	);

endmodule
