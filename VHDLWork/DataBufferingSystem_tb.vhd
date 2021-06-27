library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity DataBufferingSystem_tb is
end entity;

architecture bh of DataBufferingSystem_tb is

component DataBufferingSystem is
	port(
	DIN : in std_logic_vector(7 downto 0);
	DOUT : out std_logic_vector(7 downto 0);
	fill_done: out std_logic;
	fill_fifo:in std_logic;
	ready_to_fill: out std_logic;
	reset:in std_logic;
	iclk:in std_logic;
	oclk:in std_logic;
	empty_done: out std_logic;
	start_empty: out std_logic;
	empty_fifo:in std_logic;
	ready_to_empty: out std_logic;
	
	probe: out std_logic
	
	);
End component;

signal	DIN :  std_logic_vector(7 downto 0);
signal	DOUT :  std_logic_vector(7 downto 0);
signal	fill_done:  std_logic;
signal	fill_fifo: std_logic;
signal	ready_to_fill:  std_logic;
signal	reset: std_logic;
signal	iclk: std_logic;
signal	oclk: std_logic;
signal	empty_done:  std_logic;
signal	start_empty:  std_logic;
signal	empty_fifo: std_logic;
signal	ready_to_empty:  std_logic;

signal	probe:  std_logic;


constant period : time := 10 ns;
constant TinputDelay : time := 1 ns;


type ROM is array (0 to 23) of std_logic_vector(7 downto 0)  ;
signal ROM1 : ROM :=(x"01",x"02",x"03",x"04",x"05",x"06",x"07",x"08",
							x"09",x"0A",x"0B",x"0C",x"0D",x"0E",x"0F",x"10",
							x"11",x"12",x"13",x"14",x"15",x"16",x"17",x"18"
							);

begin

uut: DataBufferingSystem
Port map(

	DIN 				=>DIN,
	DOUT 				=>DOUT,
	fill_done				=>fill_done,
	fill_fifo				=>fill_fifo,
	ready_to_fill				=>ready_to_fill,
	reset				=>reset,
	iclk				=>iclk,
	oclk				=>oclk,
	empty_done				=>empty_done,
	start_empty				=>start_empty,
	empty_fifo				=>empty_fifo,
	ready_to_empty				=>ready_to_empty,

	
	probe			=> probe	
);

process
begin
	oclk <= '0';
	wait for period/2;
	oclk <= '1';
	wait for period/2;
end process;

process
begin
	iclk <= '0';
	wait for period/2/4;
	iclk <= '1';
	wait for period/2/4;
end process;

process
variable test_number: integer:=1;
begin


if (test_number=1) then

		empty_fifo<='0';
		fill_fifo<='0';
		DIN<= "ZZZZZZZZ";
		
		reset<='1';
	wait until oclk = '1' and oclk'event;
	wait until oclk = '1' and oclk'event;
	reset<='0';
	
	wait until oclk = '1' and oclk'event;
	wait until oclk = '1' and oclk'event;
	wait until oclk = '1' and oclk'event;
	

	
		empty_fifo<='0';
		fill_fifo<='0';
		DIN<= "ZZZZZZZZ";
		
		for i in 0 to 7 loop
			wait until iclk = '1' and iclk'event; --wait here for 8 iclk cycles
		end loop;
	
	----------------------LOADING FROM ROM POSITION 0 TO 7----------------------------------------------------
	
			fill_fifo<='1';
			wait until iclk = '1' and iclk'event;
			fill_fifo<='0';
		for i in 0 to 7 loop
		
			DIN<=ROM1(i);
			wait until iclk = '1' and iclk'event;
		end loop;
		DIN<= "ZZZZZZZZ";
		
		
		for i in 0 to 1 loop
			wait until iclk = '1' and iclk'event; --wait here for 8 iclk cycles
		end loop;
	----------------------LOADING FROM ROM POSITION 8 TO 15----------------------------------------------------
	
				fill_fifo<='1';
			wait until iclk = '1' and iclk'event;
			fill_fifo<='0';
		for i in 8 to 15 loop
		
			DIN<=ROM1(i);
			wait until iclk = '1' and iclk'event;
		end loop;
		DIN<= "ZZZZZZZZ";
		
		for i in 0 to 1 loop
			wait until iclk = '1' and iclk'event; --wait here for 8 iclk cycles
		end loop;
	----------------------LOADING FROM ROM POSITION 16 TO 23----------------------------------------------------	
		
				fill_fifo<='1';
			wait until iclk = '1' and iclk'event;
			fill_fifo<='0';
		for i in 16 to 23 loop
		
			DIN<=ROM1(i);
			wait until iclk = '1' and iclk'event;
		end loop;
		
		
		DIN<= "ZZZZZZZZ";
		for i in 0 to 1 loop
			wait until iclk = '1' and iclk'event; --wait here for 8 iclk cycles
		end loop;
		
	---------------------------END OF LOADING TEST-----------------------------------------------
	
	
	---------------------------OUTPUT TEST-----------------------------------------------
	
	
		empty_fifo<='1';
			wait until oclk = '1' and oclk'event;
			empty_fifo<='0';
			
		for i in 0 to 12 loop
			wait until oclk = '1' and oclk'event;	--wait here for 8 oclk cycles to get outputs
		end loop;
		
		empty_fifo<='1';
			wait until oclk = '1' and oclk'event;
			empty_fifo<='0';
			
		for i in 0 to 12 loop
			wait until oclk = '1' and oclk'event;	--wait here for 8 oclk cycles to get outputs
		end loop;
		
		empty_fifo<='1';
			wait until oclk = '1' and oclk'event;
			empty_fifo<='0';
			
		for i in 0 to 12 loop
			wait until oclk = '1' and oclk'event;	--wait here for 8 oclk cycles to get outputs
		end loop;	
		
	
	empty_fifo<='0';
		fill_fifo<='0';
		DIN<= "ZZZZZZZZ";
	for i in 0 to 20 loop
		wait until oclk = '1' and oclk'event;
	end loop;

end if;
test_number:=test_number+1;

if (test_number=2) then

	reset<='1';
	wait until oclk = '1' and oclk'event;
	reset<='0';
	----------------------LOADING FROM ROM POSITION 0 TO 7----------------------------------------------------
	
			fill_fifo<='1';
			wait until iclk = '1' and iclk'event;
			fill_fifo<='0';
		for i in 0 to 7 loop
		
			DIN<=ROM1(i);
			wait until iclk = '1' and iclk'event;
		end loop;
		DIN<= "ZZZZZZZZ";
		
		empty_fifo<='1';
			wait until oclk = '1' and oclk'event;
			empty_fifo<='0';
			
		for i in 0 to 12 loop
			wait until oclk = '1' and oclk'event;	--wait here for 8 oclk cycles to get outputs
		end loop;

		
		fill_fifo<='1';
			wait until iclk = '1' and iclk'event;
			fill_fifo<='0';
		for i in 8 to 15 loop
		
			DIN<=ROM1(i);
			wait until iclk = '1' and iclk'event;
		end loop;
		DIN<= "ZZZZZZZZ";
		
		empty_fifo<='1';
			wait until oclk = '1' and oclk'event;
			empty_fifo<='0';
			
		for i in 0 to 20 loop
			wait until oclk = '1' and oclk'event;	--wait here for 8 oclk cycles to get outputs
		end loop;
		
		

end if;
test_number:=test_number+1;

if (test_number=3) then

	reset<='1';
	wait until oclk = '1' and oclk'event;
	reset<='0';
	----------------------LOADING FROM ROM POSITION 0 TO 7----------------------------------------------------
	
			fill_fifo<='1';
			wait until iclk = '1' and iclk'event;
			wait until iclk = '1' and iclk'event;
			fill_fifo<='0';
		for i in 0 to 7 loop
		
			DIN<=ROM1(i);
			wait until iclk = '1' and iclk'event;
		end loop;
		DIN<= "ZZZZZZZZ";
		
				for i in 0 to 1 loop
			wait until iclk = '1' and iclk'event; --wait here for 8 iclk cycles
		end loop;
		
		fill_fifo<='1';
			wait until iclk = '1' and iclk'event;
			fill_fifo<='0';
		for i in 8 to 15 loop
		
			DIN<=ROM1(i);
			wait until iclk = '1' and iclk'event;
		end loop;
		DIN<= "ZZZZZZZZ";
		
		empty_fifo<='1';
			wait until oclk = '1' and oclk'event;
			empty_fifo<='0';
			
		for i in 0 to 12 loop
			wait until oclk = '1' and oclk'event;	--wait here for 8 oclk cycles to get outputs
		end loop;

		fill_fifo<='1';
			wait until iclk = '1' and iclk'event;
			fill_fifo<='0';
		for i in 16 to 23 loop
		
			DIN<=ROM1(i);
			wait until iclk = '1' and iclk'event;
		end loop;
		DIN<= "ZZZZZZZZ";
		
		empty_fifo<='1';
			wait until oclk = '1' and oclk'event;
			empty_fifo<='0';
			
		for i in 0 to 12 loop
			wait until oclk = '1' and oclk'event;	--wait here for 8 oclk cycles to get outputs
		end loop;
		
		empty_fifo<='1';
			wait until oclk = '1' and oclk'event;
			empty_fifo<='0';
			
		for i in 0 to 12 loop
			wait until oclk = '1' and oclk'event;	--wait here for 8 oclk cycles to get outputs
		end loop;

end if;
test_number:=test_number+1;
end process;





end architecture;