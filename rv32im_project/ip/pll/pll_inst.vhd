	component pll is
		port (
			c0_clk                    : out std_logic;                                        -- clk
			clk_clk                   : in  std_logic                     := 'X';             -- clk
			reset_reset               : in  std_logic                     := 'X';             -- reset
			pll_pll_slave_read        : in  std_logic                     := 'X';             -- read
			pll_pll_slave_write       : in  std_logic                     := 'X';             -- write
			pll_pll_slave_address     : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- address
			pll_pll_slave_readdata    : out std_logic_vector(31 downto 0);                    -- readdata
			pll_pll_slave_writedata   : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			pll_areset_conduit_export : in  std_logic                     := 'X'              -- export
		);
	end component pll;

	u0 : component pll
		port map (
			c0_clk                    => CONNECTED_TO_c0_clk,                    --                 c0.clk
			clk_clk                   => CONNECTED_TO_clk_clk,                   --                clk.clk
			reset_reset               => CONNECTED_TO_reset_reset,               --              reset.reset
			pll_pll_slave_read        => CONNECTED_TO_pll_pll_slave_read,        --      pll_pll_slave.read
			pll_pll_slave_write       => CONNECTED_TO_pll_pll_slave_write,       --                   .write
			pll_pll_slave_address     => CONNECTED_TO_pll_pll_slave_address,     --                   .address
			pll_pll_slave_readdata    => CONNECTED_TO_pll_pll_slave_readdata,    --                   .readdata
			pll_pll_slave_writedata   => CONNECTED_TO_pll_pll_slave_writedata,   --                   .writedata
			pll_areset_conduit_export => CONNECTED_TO_pll_areset_conduit_export  -- pll_areset_conduit.export
		);

