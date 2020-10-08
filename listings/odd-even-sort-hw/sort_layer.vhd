LIBRARY IEEE;
LIBRARY WORK;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE constants IS
	CONSTANT DATA_LEN : INTEGER := 8;
	TYPE layer_signals_t IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR((DATA_LEN - 1) DOWNTO 0);
END PACKAGE;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.CONSTANTS.ALL;

ENTITY sort_layer IS
	GENERIC (
		SIZE : INTEGER := 8
	);
	PORT (
		data_in : IN layer_signals_t(0 TO (SIZE - 1));
		data_out : OUT layer_signals_t(0 TO (SIZE - 1));
		sorted : OUT STD_LOGIC
	);
END sort_layer;

ARCHITECTURE arch OF sort_layer IS
	SIGNAL intermediate : layer_signals_t(0 TO (SIZE - 1));
	SIGNAL swap_signals : STD_LOGIC_VECTOR(0 TO (SIZE - 2));
BEGIN
	comparators : FOR i IN 0 TO (SIZE - 1) GENERATE

		first : IF (i = 0) GENERATE
			data_out(i) <= intermediate(i);
		END GENERATE;

		last : IF (i = (SIZE - 1)) GENERATE
			data_out (i) <= intermediate(i);
		END GENERATE;

		even : IF (i MOD 2 = 0) GENERATE
			comp : ENTITY work.comparator
				GENERIC MAP(
					DATA_LEN => DATA_LEN
				)
				PORT MAP(
					A => data_in (i),
					B => data_in(i + 1),
					min => intermediate(i),
					max => intermediate(i + 1),
					swapped => swap_signals(i)
				);
		END GENERATE;

		odd : IF (i MOD 2 /= 0 AND i < (SIZE - 1)) GENERATE
			comp : ENTITY work.comparator
				GENERIC MAP(
					DATA_LEN => DATA_LEN
				)
				PORT MAP(
					min => data_out(i),
					max => data_out (i + 1),
					A => intermediate(i),
					B => intermediate(i + 1),
					swapped => swap_signals(i)
				);
		END GENERATE;
	END GENERATE;

	-- When all swap-signals are 0, then the layer is sorted.
	sorted <= '1' WHEN unsigned(swap_signals) = 0 ELSE '0';
END arch;