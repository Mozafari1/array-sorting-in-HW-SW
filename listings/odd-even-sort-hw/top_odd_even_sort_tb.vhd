LIBRARY IEEE;
LIBRARY WORK;
USE WORK.CONSTANTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY top_odd_even_sort_tb IS
END top_odd_even_sort_tb;

ARCHITECTURE arch OF top_odd_even_sort_tb IS

	SIGNAL clk, rst, clear, enable, sort_done : STD_LOGIC;
	CONSTANT clk_period : TIME := 10ns;
	SIGNAL data_in : layer_signals_t(0 TO 9);

BEGIN

	uut : ENTITY work.top_odd_even_sort
		GENERIC MAP(
			SIZE => 10,
			SORT_NETWORK_SIZE => 3
		)
		PORT MAP(
			data_in => data_in,
			clk => clk,
			rst => rst,
			enable => enable,
			clear => clear,
			sort_done => sort_done
		);

	PROCESS
	BEGIN
		rst <= '1';
		WAIT FOR clk_period/2;
		rst <= '0';

		WAIT FOR clk_period/2;
		enable <= '1';

		data_in(0) <= x"AB";
		data_in(1) <= x"66";
		data_in(2) <= x"FF";
		data_in(3) <= x"AF";
		data_in(4) <= x"AB";
		data_in(5) <= x"66";
		data_in(6) <= x"F5";
		data_in(7) <= x"6F";
		data_in(8) <= x"AD";
		data_in(9) <= x"68";

		WAIT FOR clk_period * 5;

	END PROCESS;

	PROCESS
	BEGIN
		clk <= '0';
		WAIT FOR clk_period / 2;
		clk <= '1';
		WAIT FOR clk_period / 2;
	END PROCESS;
END arch;
