	component pll is
		port (
			clk_clk     : in  std_logic := 'X'; -- clk
			reset_reset : in  std_logic := 'X'; -- reset
			c0_clk      : out std_logic         -- clk
		);
	end component pll;

	u0 : component pll
		port map (
			clk_clk     => CONNECTED_TO_clk_clk,     --   clk.clk
			reset_reset => CONNECTED_TO_reset_reset, -- reset.reset
			c0_clk      => CONNECTED_TO_c0_clk       --    c0.clk
		);

