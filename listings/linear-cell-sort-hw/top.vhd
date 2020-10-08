LIBRARY IEEE;
LIBRARY WORK;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY top IS
	GENERIC (
		DATA_LEN : INTEGER := 8;
		LOG_N : INTEGER := 3
	);
	PORT (
		data_in : IN STD_LOGIC_VECTOR((DATA_LEN - 1) DOWNTO 0);
		data_out : OUT STD_LOGIC_VECTOR((DATA_LEN - 1) DOWNTO 0);
		enable, clk, rst, clr : IN STD_LOGIC
	);
END top;

ARCHITECTURE arch OF top IS

	TYPE t_data_signals IS ARRAY(0 TO (2 ** LOG_N) - 1) OF STD_LOGIC_VECTOR((DATA_LEN - 1) DOWNTO 0);
	SIGNAL data_signals : t_data_signals;

	TYPE t_pushing_signals IS ARRAY(0 TO (2 ** LOG_N) - 2) OF STD_LOGIC;
	SIGNAL pushing_signals : t_pushing_signals;

	TYPE t_full_signal IS ARRAY(0 TO (2 ** LOG_N) - 2) OF STD_LOGIC;
	SIGNAL full_signals : t_full_signal;

	SIGNAL mux_inputs : work.multiplexer_type.input_array(0 TO ((2 ** LOG_N) - 1), (DATA_LEN - 1) DOWNTO 0);
	SIGNAL data_mux : STD_LOGIC_VECTOR((LOG_N - 1) DOWNTO 0);
	SIGNAL in_cnt_inc, mux_cnt_inc, comp, in_cnt_clr, mux_cnt_clr, cells_clr : STD_LOGIC;
	SIGNAL in_cnt_data, mux_cnt_data : STD_LOGIC_VECTOR((LOG_N - 1) DOWNTO 0);
BEGIN

	first_cell : ENTITY work.top_cell
		GENERIC MAP(DATA_LEN => DATA_LEN)
		PORT MAP(
			clk => clk,
			rst => rst,
			clr => cells_clr,
			enable => enable,
			new_data => data_in,
			prev_cell_data => (OTHERS => '0'),
			prev_cell_pushing => '0',
			prev_cell_full => '1',
			is_full => full_signals(0),
			pushing => pushing_signals(0),
			data => data_signals(0)
		);

	cells : FOR i IN 0 TO (2 ** LOG_N) - 3 GENERATE
		cell : ENTITY work.top_cell
			GENERIC MAP(DATA_LEN => DATA_LEN)
			PORT MAP(
				clk => clk,
				rst => rst,
				clr => cells_clr,
				enable => enable,
				new_data => data_in,
				prev_cell_data => data_signals(i),
				prev_cell_pushing => pushing_signals(i),
				prev_cell_full => full_signals(i),
				is_full => full_signals(i + 1),
				pushing => pushing_signals(i + 1),
				data => data_signals(i + 1)
			);
	END GENERATE;

	last_cell : ENTITY work.top_cell
		GENERIC MAP(DATA_LEN => DATA_LEN)
		PORT MAP(
			clk => clk,
			rst => rst,
			clr => cells_clr,
			enable => enable,
			new_data => data_in,
			prev_cell_data => data_signals((2 ** LOG_N) - 2),
			prev_cell_pushing => pushing_signals((2 ** LOG_N) - 2),
			prev_cell_full => full_signals((2 ** LOG_N) - 2),
			is_full => OPEN,
			pushing => OPEN,
			data => data_signals((2 ** LOG_N) - 1)
		);

	x : FOR i IN (DATA_LEN - 1) DOWNTO 0 GENERATE
		y : FOR j IN 0 TO (2 ** LOG_N) - 1 GENERATE
			mux_inputs(j, i) <= data_signals(j)(i);
		END GENERATE;
	END GENERATE;

	mux : ENTITY work.multiplexer
		GENERIC MAP(DATA_LEN => DATA_LEN, MUX_BITS => LOG_N)
		PORT MAP(inputs => mux_inputs, sel => mux_cnt_data, output => data_out);

	in_cnt : ENTITY work.counter
		GENERIC MAP(LOG_N => LOG_N)
		PORT MAP(
			clk => clk,
			rst => rst,
			clr => in_cnt_clr,
			inc => in_cnt_inc,
			output => in_cnt_data
		);

	mux_cnt : ENTITY work.counter
		GENERIC MAP(LOG_N => LOG_N)
		PORT MAP(
			clk => clk,
			rst => rst,
			clr => mux_cnt_clr,
			inc => mux_cnt_inc,
			output => mux_cnt_data
		);

	comp_eq : ENTITY work.comparator_eq
		GENERIC MAP(INPUT_SIZE => LOG_N)
		PORT MAP(A => in_cnt_data, B => mux_cnt_data, comp => comp);

	control : ENTITY work.control
		PORT MAP(
			comp => comp,
			clk => clk,
			rst => rst,
			clr => clr,
			enable => enable,
			in_cnt_inc => in_cnt_inc,
			mux_cnt_inc => mux_cnt_inc,
			in_cnt_clr => in_cnt_clr,
			mux_cnt_clr => mux_cnt_clr,
			cells_clr => cells_clr
		);

END;
