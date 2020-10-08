LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY comparator_eq IS
	GENERIC (
		INPUT_SIZE : INTEGER
	);

	PORT (
		A, B : IN STD_LOGIC_VECTOR((INPUT_SIZE - 1) DOWNTO 0);
		comp : OUT STD_LOGIC
	);
END comparator_eq;

ARCHITECTURE arch OF comparator_eq IS

BEGIN
	comp <= '1' WHEN A = B ELSE
		'0';

END arch;
