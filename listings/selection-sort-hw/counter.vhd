LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY counter IS
	PORT (
		input : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		load, incr, clk, rst : IN STD_LOGIC;
		output : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END;

ARCHITECTURE arch OF counter IS
	SIGNAL current_value, next_value : unsigned(7 DOWNTO 0);
BEGIN
	PROCESS (clk, rst)
	BEGIN
		IF rst = '1' THEN
			current_value <= (OTHERS => '0');
		ELSIF rising_edge(clk) THEN
			current_value <= next_value;
		END IF;
	END PROCESS;

	-- current_value logic
	next_value <= current_value + 1 WHEN incr = '1' ELSE
		unsigned(input) WHEN load = '1' ELSE
		current_value;

	output <= STD_LOGIC_VECTOR(current_value);
END;