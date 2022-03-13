library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clockDiv is
generic(HALF_CYCLE : integer := 4);
port (  
        inClk   : in std_logic;
        rst     : in std_logic;
        outClk  : out std_logic
        );
end clockDiv;

architecture Behavioral of clockDiv is
  
signal count: integer:=1;
signal tmp : std_logic := '0';
  
begin
  
	process(inClk,rst)
	begin
		if(rst='1') then
			count<=1;
			tmp<='0';
		elsif(inClk'event and inClk='1') then
			count <=count+1;
			if (count = HALF_CYCLE) then
				tmp <= NOT tmp;
				count <= 1;
			end if;
		end if;
		outClk <= tmp;
	end process;

end Behavioral;