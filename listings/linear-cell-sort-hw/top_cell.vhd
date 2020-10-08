LIBRARY IEEE;
LIBRARY WORK;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY top_cell IS
	GENERIC (
		DATA_LEN : INTEGER
	);
	PORT (
		prev_cell_data, new_data : IN STD_LOGIC_VECTOR((DATA_LEN - 1) DOWNTO 0);
		prev_cell_full : IN STD_LOGIC;
		prev_cell_pushing : IN STD_LOGIC;
		clk, rst, clr, enable : IN STD_LOGIC;
		pushing, is_full : OUT STD_LOGIC;
		data : OUT STD_LOGIC_VECTOR((DATA_LEN - 1) DOWNTO 0)
	);
END top_cell;

ARCHITECTURE arch OF top_cell IS

	TYPE t_state IS (empty, full);
	SIGNAL cur, nxt : t_state;
	SIGNAL comp, load, data_mux : STD_LOGIC;
	SIGNAL reg_out, mux_out : STD_LOGIC_VECTOR((DATA_LEN - 1) DOWNTO 0);

	SIGNAL mux_inputs : work.multiplexer_type.input_array(0 TO 1, (DATA_LEN - 1) DOWNTO 0);

BEGIN
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			cur <= empty;
		ELSIF rising_edge(clk) THEN
			cur <= nxt;
			IF clr = '1' THEN
				cur <= empty;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (cur, enable, clr, prev_cell_full, prev_cell_pushing, comp)
	BEGIN

		nxt <= cur;
		load <= '0';
		data_mux <= '0';
		pushing <= '0';
		is_full <= '0';

		CASE cur IS
			WHEN empty =>
				IF enable /= '1' THEN
				ELSIF prev_cell_pushing = '1' THEN
					data_mux <= '0';
					load <= '1';
					nxt <= full;
				ELSIF prev_cell_full = '1' THEN
					data_mux <= '1';
					load <= '1';
					nxt <= full;
				END IF;
			WHEN full =>
				is_full <= '1';

				IF enable /= '1' THEN
				ELSIF prev_cell_pushing = '1' THEN
					data_mux <= '0';
					load <= '1';
					pushing <= '1';
				ELSIF comp = '1' THEN
					data_mux <= '1';
					load <= '1';
					pushing <= '1';
				END IF;
		END CASE;
	END PROCESS;

	data <= reg_out;

	comparator : ENTITY work.comparator
		GENERIC MAP(DATA_LEN => DATA_LEN)
		PORT MAP(A => new_data, B => reg_out, comp => comp);

	x : FOR i IN (DATA_LEN - 1) DOWNTO 0 GENERATE
		mux_inputs(0, i) <= prev_cell_data(i);
		mux_inputs(1, i) <= new_data(i);
	END GENERATE;

	mux : ENTITY work.multiplexer
		GENERIC MAP(DATA_LEN => DATA_LEN, MUX_BITS => 1)
		PORT MAP(inputs => mux_inputs, sel(0) => data_mux, output => mux_out);

	reg : ENTITY work.reg
		GENERIC MAP(DATA_LEN => DATA_LEN)
		PORT MAP(clk => clk, rst => rst, load => load, data_in => mux_out, data_out => reg_out);
END arch;
