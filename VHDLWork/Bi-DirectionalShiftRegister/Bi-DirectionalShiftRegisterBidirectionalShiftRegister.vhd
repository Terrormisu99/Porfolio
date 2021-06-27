
library ieee;
use ieee.std_logic_1164.all  ;

entity BidirectionalShiftRegister is
	port(  clk,reset ,sir, sil : in std_logic;
			mode : in std_logic_vector(1 downto 0);
			datain : in std_logic_vector(7 downto 0);
			dataout : out std_logic_vector(7 downto 0);
		   sor ,sol : out std_logic);
end BidirectionalShiftRegister;

architecture behave of BidirectionalShiftRegister is


signal shift: std_logic_vector(7 downto 0);

begin

prc1: process (reset, clk)
	begin

		if (reset='1') then
			shift<= "00000000";--REST TO 00000000
		
		elsif (clk'event and (clk='1') and (mode="00")) then
			shift<= shift(7 downto 1) & sil;--SHIFT CURRENT TO THE LEFT AND SLIDE IN A NEW BIT
		
		elsif (clk'event and (clk='1') and (mode="01")) then
			shift<= sir & shift(6 downto 0);--SHIFT CURRENT TO THE RIGHT AND SLIDE IN A NEW BIT
		
		elsif (clk'event and (clk='1') and (mode="10")) then
			shift<= datain;--SET OUTPUT TO BE OUR DESIRED INPUT (TOGGLE BASED)
		
		elsif (clk'event and (clk='1') and (mode="11")) then
			shift<= shift;--NO CHANGE
		end if;
	
	end process;
	
	dataout<= shift;
	
	sor<= shift(7);
	sol<=shift(0);
	
	--prc2: process (shift)
	--begin
	--if (mode= "00") then
	--	sol<= shift(7);
	--elsif (mode="01") then
	--	sor<= shift(0);
	--end if;
	--end process;
	

end architecture behave;
