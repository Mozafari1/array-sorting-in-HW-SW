LIBRARY IEEE;
LIBRARY WORK;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY top_tb IS
END top_tb;

ARCHITECTURE tb OF top_tb IS

	CONSTANT DATA_LEN : INTEGER := 8;

	SIGNAL clk, rst, enable, clr : STD_LOGIC;
	SIGNAL data_in : STD_LOGIC_VECTOR((DATA_LEN - 1) DOWNTO 0);
	CONSTANT clk_period : TIME := 10 ns;

BEGIN
	uut : ENTITY work.top
		GENERIC MAP(DATA_LEN => DATA_LEN, LOG_N => 4)
		PORT MAP(
			clk => clk,
			rst => rst,
			clr => clr,
			enable => enable,
			data_in => data_in
		);

	clk_process : PROCESS
	BEGIN
		clk <= '0';
		WAIT FOR clk_period/2;
		clk <= '1';
		WAIT FOR clk_period/2;
	END PROCESS;

	-- Stimuli process 
	stim_proc : PROCESS
	BEGIN
		rst <= '1';
		WAIT FOR clk_period * 2;
		rst <= '0';
		WAIT FOR clk_period;
		enable <= '1';
		data_in <= x"ff";
		WAIT FOR clk_period;
		data_in <= x"99";
		WAIT FOR clk_period;
		data_in <= x"77";
		WAIT FOR clk_period;
		data_in <= x"cc";
		WAIT FOR clk_period;
		data_in <= x"88";
		WAIT FOR clk_period;
		data_in <= x"aa";
		WAIT FOR clk_period;
		data_in <= x"11";
		WAIT FOR clk_period;
		data_in <= x"ee";
		WAIT FOR clk_period;
		data_in <= x"aa";
		WAIT FOR clk_period;
		data_in <= x"11";
		WAIT FOR clk_period;
		data_in <= x"99";
		WAIT FOR clk_period;
		data_in <= x"77";
		WAIT FOR clk_period;
		data_in <= x"dd";
		WAIT FOR clk_period;
		enable <= '0';
		WAIT FOR clk_period * 20;
	END PROCESS;
END;
