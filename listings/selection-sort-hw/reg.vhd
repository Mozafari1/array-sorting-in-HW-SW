LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY reg IS
	PORT (
		clk, rst, load : IN STD_LOGIC;
		input : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		output : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END;

ARCHITECTURE arch OF reg IS

BEGIN
	PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			output <= (OTHERS => '0');
		ELSIF rising_edge(clk) AND load = '1' THEN
			output <= input;
		END IF;
	END PROCESS;
END;