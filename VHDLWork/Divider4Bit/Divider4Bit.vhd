library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity Divider4Bit is
	Port(
	 clk : IN STD_LOGIC;
	 go  : IN STD_LOGIC;
	 A   : IN STD_LOGIC_vector(3 downto 0);
	 B   : IN STD_LOGIC_vector(3 downto 0);
	reset : IN STD_LOGIC;
	 Q  : out STD_LOGIC_vector(3 downto 0);
	 R  : out STD_LOGIC_vector(3 downto 0);
	done : OUT STD_LOGIC); 
end Divider4Bit;

architecture behave of Divider4Bit is
	Type state_type is (s0,s1,s2,s3);--creating own variable type
	signal state : state_type :=s0;
	signal RB,RQ:  std_logic_vector(3 downto 0);
	signal C:  std_logic_vector(3 downto 0) := "0011";
	signal RR:  std_logic_vector(3 downto 0) := "0000";
	signal RA:  std_logic_vector(3 downto 0) := A;
	
	signal RR_RA_HOLDER:  std_logic_vector(8 downto 0);--for the concatination in S1
	begin
	
		Process (clk, reset, state)
		begin
			if reset= '1' then
				state<=s0;
			elsif (clk'event and clk='1') then
				case state is --conditions for controling which state to go to
					
					when s0 =>
						RR<= "0000";
						C<= "0011";
						if go= '1' then
						state<= s1;
						else
						RA<=A;
						RB<=B;
						state<=s0;
						
						end if;
						
					when s1=>
						RR <= RR_RA_HOLDER(7 downto 4);--concated assignment doesnt work? RQ&RA<=....
						RA <= RR_RA_HOLDER(3 downto 0);
						state<=s2;
						
					when s2=>
						C<=c-"0001";
						if (RR >= RB) then
							RQ<= (RQ(2 downto 0) & '1' );
							RR<= RR-RB;
						else
							RQ<=(RQ(2 downto 0) & '0');
					end if;
						
						if c=0 then
							state<=s3;
						else
							state<= s1;
						end if;
						
					when s3=> 
						done<='1';
						Q<=RQ;
						R<=RR;
						state<=s0;
						
						
				end case;
				
				
			end if;
		 end process;
		 
		process(clk, RR, RA)
		begin
			RR_RA_HOLDER<=(RR & RA &'0');
		end process;
		 
		 
end architecture;

						
						
						
