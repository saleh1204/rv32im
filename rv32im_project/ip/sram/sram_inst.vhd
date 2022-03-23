	component sram is
		port (
			clk_clk               : in    std_logic                     := 'X';             -- clk
			reset_reset           : in    std_logic                     := 'X';             -- reset
			sram_DQ               : inout std_logic_vector(15 downto 0) := (others => 'X'); -- DQ
			sram_ADDR             : out   std_logic_vector(19 downto 0);                    -- ADDR
			sram_LB_N             : out   std_logic;                                        -- LB_N
			sram_UB_N             : out   std_logic;                                        -- UB_N
			sram_CE_N             : out   std_logic;                                        -- CE_N
			sram_OE_N             : out   std_logic;                                        -- OE_N
			sram_WE_N             : out   std_logic;                                        -- WE_N
			sram_io_address       : in    std_logic_vector(19 downto 0) := (others => 'X'); -- address
			sram_io_byteenable    : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			sram_io_read          : in    std_logic                     := 'X';             -- read
			sram_io_write         : in    std_logic                     := 'X';             -- write
			sram_io_writedata     : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			sram_io_readdata      : out   std_logic_vector(15 downto 0);                    -- readdata
			sram_io_readdatavalid : out   std_logic                                         -- readdatavalid
		);
	end component sram;

	u0 : component sram
		port map (
			clk_clk               => CONNECTED_TO_clk_clk,               --     clk.clk
			reset_reset           => CONNECTED_TO_reset_reset,           --   reset.reset
			sram_DQ               => CONNECTED_TO_sram_DQ,               --    sram.DQ
			sram_ADDR             => CONNECTED_TO_sram_ADDR,             --        .ADDR
			sram_LB_N             => CONNECTED_TO_sram_LB_N,             --        .LB_N
			sram_UB_N             => CONNECTED_TO_sram_UB_N,             --        .UB_N
			sram_CE_N             => CONNECTED_TO_sram_CE_N,             --        .CE_N
			sram_OE_N             => CONNECTED_TO_sram_OE_N,             --        .OE_N
			sram_WE_N             => CONNECTED_TO_sram_WE_N,             --        .WE_N
			sram_io_address       => CONNECTED_TO_sram_io_address,       -- sram_io.address
			sram_io_byteenable    => CONNECTED_TO_sram_io_byteenable,    --        .byteenable
			sram_io_read          => CONNECTED_TO_sram_io_read,          --        .read
			sram_io_write         => CONNECTED_TO_sram_io_write,         --        .write
			sram_io_writedata     => CONNECTED_TO_sram_io_writedata,     --        .writedata
			sram_io_readdata      => CONNECTED_TO_sram_io_readdata,      --        .readdata
			sram_io_readdatavalid => CONNECTED_TO_sram_io_readdatavalid  --        .readdatavalid
		);

