library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
entity DataBufferingSystem is

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

end entity;


architecture bh of DataBufferingSystem is

component FIFO is
	port(
		datain: in std_logic_vector(7 downto 0);
      empty, fill, iclk, oclk: in std_logic;
		fifo_empty, fifo_full: out std_logic;
      dataout: out std_logic_vector(7 downto 0)
		);
End component;


signal datain1,datain2,datain3 : std_logic_vector(7 downto 0);
signal dataout1,dataout2,dataout3 :  std_logic_vector(7 downto 0);
signal fifo_full1,fifo_full2,fifo_full3 :  std_logic;
signal fifo_empty1,fifo_empty2,fifo_empty3 :  std_logic;
signal oclk1,oclk2,oclk3 :  std_logic;
signal iclk1,iclk2,iclk3 :  std_logic;
signal empty1,empty2,empty3 :  std_logic;
signal fill1,fill2,fill3 :  std_logic;


signal fill_fifo_counter : integer :=0;
signal empty_fifo_counter : integer :=0;


type state_type is (idle, filling_FIFO,emptying_FIFO, S0, S1,S2,S3);
--signal iclk_state: state_type:=idle;
--signal oclk_state: state_type:=idle;


signal iclk_state: state_type:=S0;
signal oclk_state: state_type:=S0;

signal WorkingFIFO_ID: std_logic_vector(2 downto 0) := "001";
signal OutputWorkingFIFO_ID: std_logic_vector(2 downto 0) := "001";



begin

FIFO1: FIFO
	port map(
		datain=> datain1,
		empty=> empty1,
		fill=> fill1,
		iclk=> iclk,
		oclk=> oclk,
		fifo_empty=> fifo_empty1,
		fifo_full=> fifo_full1,
		dataout=> dataout1
		);
		
FIFO2: FIFO
	port map(
		datain=> datain2,
		empty=> empty2,
		fill=> fill2,
		iclk=> iclk,
		oclk=> oclk,
		fifo_empty=> fifo_empty2,
		fifo_full=> fifo_full2,
		dataout=> dataout2
		);
		
FIFO3: FIFO
	port map(
		datain=> datain3,
		empty=> empty3,
		fill=> fill3,
		iclk=> iclk,
		oclk=> oclk,
		fifo_empty=> fifo_empty3,
		fifo_full=> fifo_full3,
		dataout=> dataout3
		);
		

		
		
		
		
process( iclk, reset)
begin

if (reset='1') then
	iclk_state<=S0;
	ready_to_empty<='0';
	fill_done<='0';
elsif (iclk'event and (iclk = '1')) then

case iclk_state is
	when S0=>
					WorkingFIFO_ID<="001";
					fill_done<='0';
					ready_to_empty<='0';
					iclk_state<=S2;
	when S2=>
					fill_done<='0';
					ready_to_empty<='0';
					
					if (WorkingFIFO_ID=1 and  fill_fifo='1') then

							
							fill1<=fill_fifo;
							datain1<=DIN;												--needed here or else we miss one cycle of DIN coming in
							iclk_state<=S3;

					end if;
					
						
					if (WorkingFIFO_ID=2 and fill_fifo='1')  then
						
							fill2<=fill_fifo;
							datain2<=DIN;
							
							iclk_state<=S3;
					end if;
						
					if (WorkingFIFO_ID=4 and fill_fifo='1')  then
						
							fill3<=fill_fifo;
							datain3<=DIN;
							
							iclk_state<=S3;
					end if;
					

						
	when S3=>
					fill1<='0';
				fill2<='0';
				fill3<='0';

				
				if (WorkingFIFO_ID=1) then
					datain1<=DIN;
				end if;
				if (WorkingFIFO_ID=2) then
					datain2<=DIN;
				end if;
				if (WorkingFIFO_ID=4) then
					datain3<=DIN;
				end if;

				
					if (fifo_full1='1' or fifo_full2='1' or fifo_full3='1' ) then
						fill_done<='1';
						
						WorkingFIFO_ID<= WorkingFIFO_ID(1 downto 0) & WorkingFIFO_ID(2); -- move to hte next FIFO in line
						
						ready_to_empty<='1';
						iclk_state<=S2;
							

						
					end if;
					
	when others => null;		

end case;
end if;

	
end process;




process(oclk, reset)

variable output_bytes_counted : integer :=0;
begin

if (reset='1') then
	oclk_state<=S0;
	OutputWorkingFIFO_ID<="001";
	ready_to_fill<='1';
	empty_done<='0';
	start_empty<='0';

elsif (oclk'event and (oclk = '1')) then

case oclk_state is
	when S0=>
					OutputWorkingFIFO_ID<="001";
					empty_done<='0';
					start_empty<='0';
					ready_to_fill<='0';
					
					oclk_state<=S1;
	when S1=>
					empty_done<='0';
					ready_to_fill<='0';
					DOUT<="ZZZZZZZZ";
		
					if (OutputWorkingFIFO_ID=1 and empty_fifo='1') then
						
							empty1<=empty_fifo;
							start_empty<='1';
							DOUT<=dataout1;
							oclk_state<=S3;
					
						
					elsif (OutputWorkingFIFO_ID=2 and empty_fifo='1')  then
							empty2<=empty_fifo;
							start_empty<='1';
							DOUT<=dataout2;
							oclk_state<=S3;

						
					elsif (OutputWorkingFIFO_ID=4 and empty_fifo='1')  then

							empty3<=empty_fifo;
							start_empty<='1';
							DOUT<=dataout3;
							oclk_state<=S3;
					end if;
			
					
						
	when S3=>
					empty1<='0';
					empty2<='0';
					empty3<='0';
					start_empty<='0';
					
				
				if (OutputWorkingFIFO_ID=1) then
					DOUT<=dataout1;
				end if;
				if (OutputWorkingFIFO_ID=2) then
					DOUT<=dataout2;
				end if;
				if (OutputWorkingFIFO_ID=4) then
					DOUT<=dataout3;
				end if;
				
				
					if (fifo_empty1='1' or fifo_empty2='1' or fifo_empty3='1' ) then
						empty_done<='1';
						ready_to_fill<='1';
						OutputWorkingFIFO_ID<= OutputWorkingFIFO_ID(1 downto 0) & OutputWorkingFIFO_ID(2);
						oclk_state<=S1;
					end if;
					
	when others => null;		

end case;
end if;

end process;


--process (fifo_full1,fifo_full2,fifo_full3, intial_ready_to_empty, iclk)
--begin
--
--			if (iclk'event and iclk='1') then
--				if (fifo_full1='1' or fifo_full2='1' or fifo_full3='1' or intial_ready_to_empty<=1 ) then
--					ready_to_empty<='1'; --incase we empty a fifo while loading another...probably not needed since we cannot fill two fifos at the same time
--				else
--					ready_to_empty<='0';
--				end if;
--			end if;
--				
--end process;


--process (fifo_empty1,fifo_empty2,fifo_empty3, oclk)
--begin
--
--			
--			if (oclk'event and oclk='1') then
--				if (fifo_empty1='1' or fifo_empty2='1' or fifo_empty3='1') then
--					ready_to_fill<='1'; --incase we empty a fifo while loading another...probably not needed since we cannot fill two fifos at the same time
--				else
--					ready_to_fill<='0';
--				end if;
--			end if;
--				
--end process;

end architecture;




