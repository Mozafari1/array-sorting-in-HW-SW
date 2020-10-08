LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY comparator IS
	GENERIC (
		DATA_LEN : INTEGER := 8
	);
	PORT (
		A, B : IN STD_LOGIC_VECTOR((DATA_LEN - 1) DOWNTO 0);
		max, min : OUT STD_LOGIC_VECTOR((DATA_LEN - 1) DOWNTO 0);
		swapped : OUT STD_LOGIC
	);
END comparator;

ARCHITECTURE arch OF comparator IS
BEGIN
	max <= A WHEN A > B ELSE B;
	min <= B WHEN A > B ELSE A;

	-- if not swapped then the values are already sorted
	swapped <= '1' WHEN A > B ELSE '0';
END arch;