LIBRARY IEEE;
LIBRARY WORK;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.CONSTANTS.ALL;

ENTITY top_odd_even_sort IS
	GENERIC (
		SIZE : INTEGER := 8;
		-- NB! Must be at least 3 or more
		SORT_NETWORK_SIZE : INTEGER := 3
	);
	PORT (
		clk, clear, enable, rst : IN STD_LOGIC;
		data_in : IN layer_signals_t(0 TO (SIZE - 1));
		data_out : OUT layer_signals_t(0 TO (SIZE - 1));
		sort_done : OUT STD_LOGIC
	);
END top_odd_even_sort;

ARCHITECTURE arch OF top_odd_even_sort IS

	TYPE sort_network_signals_t IS ARRAY (0 TO (SORT_NETWORK_SIZE - 2)) OF layer_signals_t (0 TO SIZE - 1);
	SIGNAL sort_network_intermediate : sort_network_signals_t;

	SIGNAL sort_network_output, iterative_sort_network : layer_signals_t (0 TO SIZE - 1);
	SIGNAL mux_out, reg_in, reg_out : layer_signals_t (0 TO SIZE - 1);
	SIGNAL sorted, reg_mux, load : STD_LOGIC;
BEGIN
	control : ENTITY work.control
		PORT MAP(
			clk => clk,
			rst => rst,
			enable => enable,
			clear => clear,
			sorted => sorted,
			reg_mux => reg_mux,
			load => load,
			sort_done => sort_done
		);

	sort_network : FOR i IN 0 TO (SORT_NETWORK_SIZE - 1) GENERATE
		first_layer : IF (i = 0) GENERATE
			layer : ENTITY work.sort_layer
				GENERIC MAP(
					SIZE => SIZE
				)
				PORT MAP(
					data_in => data_in,
					data_out => sort_network_intermediate(i)

				);
		END GENERATE;

		sort_layer : IF (i > 0 AND i < (SORT_NETWORK_SIZE - 2)) GENERATE
			layer : ENTITY work.sort_layer
				GENERIC MAP(
					SIZE => SIZE
				)
				PORT MAP(
					data_in => sort_network_intermediate(i - 1),
					data_out => sort_network_intermediate(i)

				);

		END GENERATE;
		last_layer : IF (i = (SORT_NETWORK_SIZE - 2)) GENERATE
			layer : ENTITY work.sort_layer
				GENERIC MAP(
					SIZE => SIZE
				)
				PORT MAP(
					data_in => sort_network_intermediate(i - 1),
					data_out => sort_network_output

				);
		END GENERATE;
	END GENERATE;

	iterative_sort_layer : ENTITY work.sort_layer
		GENERIC MAP(
			SIZE => SIZE
		)
		PORT MAP(
			data_in => reg_out,
			data_out => iterative_sort_network,
			sorted => sorted
		);

	mux_out <= iterative_sort_network WHEN reg_mux = '1' ELSE sort_network_output;
	reg_in <= mux_out;
	data_out <= iterative_sort_network;

	PROCESS (clk, load)
	BEGIN
		IF (rising_edge (clk) AND load = '1') THEN
			reg_out <= reg_in;
		END IF;
	END PROCESS;
END arch;