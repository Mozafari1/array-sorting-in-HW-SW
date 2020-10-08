LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY control IS
	GENERIC (
		length : UNSIGNED(7 DOWNTO 0) := x"10"
	);
	PORT (
		clk, rst : IN STD_LOGIC;
		comp_out : IN STD_LOGIC;
		i_cnt_value, c_cnt_value : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		min_v_load, min_i_load, index_v_load, c_cnt_load, c_cnt_incr, i_cnt_incr, write, data_mux : OUT STD_LOGIC;
		addr_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END;

ARCHITECTURE arch OF control IS
	TYPE state IS (S0, S1, S2, S3, S4, S5);
	SIGNAL current_state, next_state : state;

BEGIN
	-- clk process
	PROCESS (rst, clk)
	BEGIN
		IF rst = '1' THEN
			current_state <= S0;
		ELSIF rising_edge(clk) THEN
			current_state <= next_state;
		END IF;
	END PROCESS;

	-- next-state logic
	PROCESS (i_cnt_value, c_cnt_value, comp_out, current_state)
	BEGIN
		next_state <= current_state; -- stay in current state by default
		addr_mux <= "00";
		min_v_load <= '0';
		min_i_load <= '0';
		i_cnt_incr <= '0';
		c_cnt_incr <= '0';
		index_v_load <= '0';
		c_cnt_load <= '0';
		data_mux <= '0';
		write <= '0';

		CASE current_state IS

			WHEN S0 =>
				addr_mux <= "01";
				min_v_load <= '1';
				min_i_load <= '1';
				index_v_load <= '1';
				c_cnt_load <= '1';
				next_state <= S1;

			WHEN S1 =>
				c_cnt_incr <= '1';
				IF (UNSIGNED(i_cnt_value)) >= length THEN next_state <= S5;
				ELSIF (UNSIGNED(c_cnt_value)) >= length THEN next_state <= S2;
				ELSIF comp_out = '1' THEN
					min_v_load <= '1';
					min_i_load <= '1';
				END IF;
			WHEN S2 =>

				addr_mux <= "10";
				write <= '1';
				next_state <= S3;
			WHEN S3 =>
				addr_mux <= "01";
				data_mux <= '1';
				write <= '1';
				next_state <= S4;
			WHEN S4 =>
				i_cnt_incr <= '1';
				next_state <= S0;

			WHEN S5 =>
		END CASE;
	END PROCESS;
END;
