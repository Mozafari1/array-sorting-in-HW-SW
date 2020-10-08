LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY counter IS
	GENERIC (
		LOG_N : INTEGER
	);
	PORT (
		clk, rst, clr, inc : IN STD_LOGIC;
		output : OUT STD_LOGIC_VECTOR((LOG_N - 1) DOWNTO 0)
	);
END counter;

ARCHITECTURE arch OF counter IS
	SIGNAL cur, nxt : unsigned((LOG_N - 1) DOWNTO 0);

BEGIN
	-- clk process
	PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			cur <= (OTHERS => '0');
		ELSIF rising_edge(clk) THEN
			cur <= nxt;
		END IF;
	END PROCESS;

	nxt <= (OTHERS => '0') WHEN clr = '1' ELSE
		cur + 1 WHEN inc = '1' ELSE
		cur;

	output <= STD_LOGIC_VECTOR(cur);

END arch;
