LIBRARY IEEE;
LIBRARY WORK;
USE WORK.CONSTANTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY sort_layer_tb IS
END sort_layer_tb;

ARCHITECTURE arch OF sort_layer_tb IS

	SIGNAL clk : STD_LOGIC;
	CONSTANT clk_period : TIME := 10ns;
	SIGNAL data_in : layer_signals_t(0 TO 3);

BEGIN
	uut : ENTITY work.sort_layer
		GENERIC MAP(
			SIZE => 4
		)
		PORT MAP(
			data_in => data_in

		);

	PROCESS
	BEGIN

		data_in(0) <= x"AB";
		data_in(1) <= x"66";
		data_in(2) <= x"FF";
		data_in(3) <= x"AF";
		WAIT FOR clk_period;

		data_in(0) <= x"66";
		data_in(1) <= x"AB";
		data_in(2) <= x"AF";
		data_in(3) <= x"FF";
		WAIT FOR clk_period;

	END PROCESS;

	PROCESS
	BEGIN
		clk <= '0';
		WAIT FOR clk_period / 2;

		clk <= '1';
		WAIT FOR clk_period / 2;
	END PROCESS;
END arch;
