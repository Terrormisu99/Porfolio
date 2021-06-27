library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity FIFO_tb is
end entity;

architecture bh of FIFO_tb is

component FIFO is
	port(datain: in std_logic_vector(7 downto 0);
        empty, fill, iclk, oclk: in std_logic;
		  fifo_empty, fifo_full: out std_logic;
        dataout: out std_logic_vector(7 downto 0));
End component;

signal datain : std_logic_vector(7 downto 0);
signal dataout :  std_logic_vector(7 downto 0);
signal fifo_full :  std_logic;
signal fifo_empty :  std_logic;
signal oclk :  std_logic;
signal iclk :  std_logic;
signal empty :  std_logic;
signal fill :  std_logic;

constant period : time := 10 ns;
constant TinputDelay : time := 1 ns;


type ROM is array (0 to 7) of std_logic_vector(7 downto 0)  ;
signal ROM1 : ROM :=(x"01",x"02",x"03",x"04",x"05",x"06",x"07",x"08");

begin

uut: FIFO
Port map(

datain=>datain,
dataout=>dataout,
fifo_full=>fifo_full,
fifo_empty=>fifo_empty,
oclk=>oclk,
iclk=>iclk,
empty=>empty,
fill=>fill

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

begin
wait until iclk = '1' and iclk'event;

	fill<='1';
	wait until iclk = '1' and iclk'event;
	fill<='0';
for i in 0 to 7 loop

	datain<=ROM1(i);
	wait until iclk = '1' and iclk'event;
end loop;

for i in 0 to 7 loop
 	wait until iclk = '1' and iclk'event; --wait here for 8 iclk cycles
end loop;

empty<='1';
	wait until oclk = '1' and oclk'event;
	empty<='0';
	
for i in 0 to 7 loop
 	wait until oclk = '1' and oclk'event;	--wait here for 8 oclk cycles to get outputs
end loop;

for i in 0 to 7 loop
 	wait until iclk = '1' and iclk'event;	--wait here for 8 iclk cycles
end loop;
	
end process;



end architecture;