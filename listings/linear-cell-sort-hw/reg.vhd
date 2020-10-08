LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY reg IS
	GENERIC (
		DATA_LEN : INTEGER
	);
	PORT (
		clk, rst : IN STD_LOGIC;
		load : IN STD_LOGIC;
		data_in : IN STD_LOGIC_VECTOR((DATA_LEN - 1) DOWNTO 0);
		data_out : OUT STD_LOGIC_VECTOR((DATA_LEN - 1) DOWNTO 0)
	);
END;

ARCHITECTURE arch OF reg IS

BEGIN
	-- clk process
	PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			data_out <= (OTHERS => '0');
		ELSIF rising_edge(clk) AND load = '1' THEN
			data_out <= data_in;
		END IF;
	END PROCESS;
END;