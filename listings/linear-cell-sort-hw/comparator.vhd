LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY comparator IS
	GENERIC (
		DATA_LEN : INTEGER
	);

	PORT (
		A, B : IN STD_LOGIC_VECTOR((DATA_LEN - 1) DOWNTO 0);
		comp : OUT STD_LOGIC
	);
END comparator;

ARCHITECTURE arch OF comparator IS

BEGIN
	comp <= '1' WHEN A < B ELSE
		'0';

END arch;
