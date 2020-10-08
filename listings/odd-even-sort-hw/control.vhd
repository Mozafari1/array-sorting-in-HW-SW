LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY control IS
	PORT (
		clk, rst, enable, clear, sorted : IN STD_LOGIC;
		reg_mux, load, sort_done : OUT STD_LOGIC
	);
END control;

ARCHITECTURE arch OF control IS

	TYPE t_state IS (idle, iterate);
	SIGNAL current_state, next_state : t_state;

BEGIN

	-- state register
	PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			current_state <= idle;
		ELSIF rising_edge(clk) THEN
			current_state <= next_state;
		END IF;
	END PROCESS;

	-- next-state logic
	PROCESS (current_state, enable, sorted, clear)
	BEGIN
		next_state <= current_state;
		reg_mux <= '0';
		load <= '0';
		sort_done <= '0';

		CASE current_state IS
			WHEN idle =>
				IF enable = '1' THEN
					reg_mux <= '0';
					load <= '1';
					next_state <= iterate;
				END IF;
			WHEN iterate =>
				IF clear = '1' THEN
					next_state <= idle;
				ELSE
					IF (sorted = '1') THEN
						sort_done <= '1';
						next_state <= idle;
					ELSE
						reg_mux <= '1';
						load <= '1';
					END IF;
				END IF;
		END CASE;
	END PROCESS;
END;