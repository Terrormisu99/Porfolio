library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity FIFO is
                port(datain: in std_logic_vector(7 downto 0);
                                empty, fill, iclk, oclk: in std_logic;
										  fifo_empty, fifo_full: out std_logic;
                                dataout: out std_logic_vector(7 downto 0)
										  );
end FIFO;

architecture behave of FIFO is

type RAM is array (0 to 7) of std_logic_vector (7 downto 0); --ROM is a FIFO
signal myRAM: RAM;

type state_type is (idle, filling_FIFO,emptying_FIFO);
signal state: state_type:=idle;
signal state2: state_type:=idle;

signal Full_flag: integer:=0;
signal Empty_flag: integer:=0;

begin

process(iclk)
--variable temp: std_logic_vector(15 downto 0) := "0000000000000000";

variable i: integer range 0 to 8:=0;

begin 


	if(iclk'event and (iclk = '1')) then
	
	
		if (fill = '1') then
			state <= filling_FIFO;
			myRAM(i)<=datain;
			Full_flag<=0;
			i:=1;
			
		end if;
		
		case state is
					when filling_FIFO=>
												myRAM(i)<=datain;
												
												if (i= 7) then
													fifo_full<='1';
													Full_flag<=1;
													state<= idle;
												else
													Full_flag<=0;
												end if;
												i:=i+1;
												
					when others=> fifo_full<='0'; --when state is idel...this makes us hold fifo_full high for only 1 cycle of iclk
										i:=0;
		end case;
	
	end if;
	
end process;

process(oclk)
--variable temp: std_logic_vector(15 downto 0) := "0000000000000000";
variable i: integer range 0 to 8:=0;

begin 


	if(oclk'event and (oclk = '1')) then
	
		if (empty = '1') then
			state2 <= emptying_FIFO;
			dataout<=myRAM(i);
			Empty_flag<=0;
			i:=1;
			
		end if;
		
		case state2 is
					when emptying_FIFO=>
												dataout<=myRAM(i);
												
												if (i= 7) then
													Empty_flag<=1;
													fifo_empty<='1';
													state2<= idle;
												else
													Empty_flag<=0;
													end if;
												i:=i+1;	
					when others=> fifo_empty<='0'; --when state is idel...this makes us hold fifo_empty high for only 1 cycle of oclk
										i:=0;	
											dataout<="ZZZZZZZZ";
		end case;
	
	end if;
	
end process;


--process(Full_flag,Empty_flag)
--begin
--
--	if (Full_flag=1 ) then
--		fifo_empty<='0';
--		fifo_full<='1';
--	else
--		fifo_full<='0';
--	end if;
--
--	if (Empty_flag=1 and Full_flag=1) then --when both flas are 1, FIFO was truely full then emptied
--		fifo_empty<='1';
--		fifo_full<='0';
--	else
--		fifo_empty<='0';
--	end if;
--
--end process;


end behave;
