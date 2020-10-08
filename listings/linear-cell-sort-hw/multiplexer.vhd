LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE multiplexer_type IS
	TYPE input_array IS ARRAY(NATURAL RANGE <>, NATURAL RANGE <>) OF STD_LOGIC;
END PACKAGE;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.multiplexer_type.ALL;
USE ieee.numeric_std.ALL;

ENTITY multiplexer IS
	GENERIC (
		DATA_LEN : INTEGER;
		MUX_BITS : INTEGER
	);
	PORT (
		inputs : IN input_array(0 TO (2 ** MUX_BITS) - 1, (DATA_LEN - 1) DOWNTO 0);
		sel : IN STD_LOGIC_VECTOR((MUX_BITS - 1) DOWNTO 0);
		output : OUT STD_LOGIC_VECTOR((DATA_LEN - 1) DOWNTO 0)
	);
END;

ARCHITECTURE arch OF multiplexer IS
BEGIN
	gen : FOR i IN (DATA_LEN - 1) DOWNTO 0 GENERATE
		output(i) <= inputs(to_integer(unsigned(sel)), i);
	END GENERATE;
END;
