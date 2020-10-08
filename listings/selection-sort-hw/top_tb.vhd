LIBRARY WORK;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY top_tb IS
END top_tb;

ARCHITECTURE tb OF top_tb IS

	SIGNAL clk, rst : STD_LOGIC;
	CONSTANT clk_period : TIME := 500 ns;
	SIGNAL addr_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL data_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL write : STD_LOGIC;
	SIGNAL output : STD_LOGIC_VECTOR(7 DOWNTO 0);

	TYPE t_data IS ARRAY (15 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL data : t_data := (
		x"0A",
		x"0B",
		x"02",
		x"0F",
		x"03",
		x"0A",
		x"07",
		x"09",
		x"01",
		x"04",
		x"07",
		x"15",
		x"42",
		x"54",
		x"45",
		x"77"
	);

BEGIN
	PROCESS (clk)
	BEGIN
		IF rising_edge (clk) AND write = '1' THEN
			data(to_integer(unsigned(addr_in(3 DOWNTO 0)))) <= data_in;
		END IF;
	END PROCESS;

	output <= data(to_integer(unsigned(addr_in(3 DOWNTO 0))));

	uut : ENTITY work.top
		PORT MAP(
			clk => clk,
			rst => rst,
			ram_addr => addr_in,
			ram_data => data_in,
			ram_write => write,
			ram_output => output
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
		WAIT FOR clk_period * 1000;
	END PROCESS;
END tb;
