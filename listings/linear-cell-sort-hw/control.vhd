LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY control IS
	PORT (
		clk, rst, enable, clr, comp : IN STD_LOGIC;
		in_cnt_inc, mux_cnt_inc, in_cnt_clr, mux_cnt_clr, cells_clr : OUT STD_LOGIC
	);
END control;

ARCHITECTURE arch OF control IS
	TYPE t_state IS (idle, reading, outputting);
	SIGNAL cur, nxt : t_state;
BEGIN
	-- state register
	PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			cur <= idle; -- initial state
		ELSIF rising_edge(clk) THEN
			cur <= nxt;
		END IF;
	END PROCESS;

	-- next-state logic
	PROCESS (cur, comp, enable)
	BEGIN
		nxt <= cur; -- stay in current state by default
		in_cnt_clr <= '0';
		mux_cnt_clr <= '0';
		cells_clr <= '0';
		in_cnt_inc <= '0';
		mux_cnt_inc <= '0';

		CASE cur IS
			WHEN idle =>
				IF enable = '1' THEN
					nxt <= reading;
				END IF;
			WHEN reading =>
				IF enable = '0' THEN
					nxt <= outputting;
				ELSE
					in_cnt_inc <= '1';
				END IF;
			WHEN outputting =>
				IF comp = '1' THEN
					in_cnt_clr <= '1';
					mux_cnt_clr <= '1';
					cells_clr <= '1';
					nxt <= idle;
				ELSE
					mux_cnt_inc <= '1';
				END IF;
		END CASE;
	END PROCESS;
END arch;
