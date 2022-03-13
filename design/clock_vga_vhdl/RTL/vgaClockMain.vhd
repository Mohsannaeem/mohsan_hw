library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity vgaClockMain is 
	port (
	clk100	:	in std_logic;
	rst		:	in std_logic;
	btnU	:	in std_logic;
	btnD	:	in std_logic;
	btnL	:	in std_logic;
	btnR	:	in std_logic;
	btnC	:	in std_logic;
	hsync   :   out std_logic;
	vsync   :   out std_logic;
	red		:	out std_logic_vector(2 downto 0);
	green   :	out std_logic_vector(2 downto 0);
	blue	:	out std_logic_vector(2 downto 0)
	);
end vgaClockMain;

architecture Behavioral of vgaClockMain is

Component clockDiv
    generic(HALF_CYCLE : integer);
    Port ( 
            inClk   : in std_logic;
            rst     : in std_logic;
            outClk  : out std_logic
        );
End Component;

Component bin2bcd
   PORT (
      binary    : in std_logic_vector(7 DOWNTO 0);
      unit      : out std_logic_vector(3 DOWNTO 0);
      tens      : out std_logic_vector(3 DOWNTO 0);
      hundreds  : out std_logic_vector(3 DOWNTO 0)
   );
End Component;

Component vga_initials_top
   port (
      clk       : in std_logic;
      reset     : in std_logic;
      sec0      : in std_logic_vector(3 DOWNTO 0);
      sec1      : in std_logic_vector(3 DOWNTO 0);
      min0      : in std_logic_vector(3 DOWNTO 0);
      min1      : in std_logic_vector(3 DOWNTO 0);
      hou0      : in std_logic_vector(3 DOWNTO 0);
      hou1      : in std_logic_vector(3 DOWNTO 0);
      hsync     : out std_logic;
      vsync     : out std_logic;
      red       : out std_logic_vector(2 DOWNTO 0);
      green     : out std_logic_vector(2 DOWNTO 0);
      blue      : out std_logic_vector(2 DOWNTO 0)
   );
End Component;

signal mode			:	std_logic;
signal setHrs		:	std_logic_vector(1 downto 0);
signal milClk     :  std_logic;
signal d3			:	std_logic_vector(3 downto 0);
signal d2			:	std_logic_vector(3 downto 0);
signal d1			:	std_logic_vector(3 downto 0);
signal d0			:	std_logic_vector(3 downto 0);
signal s1			:	std_logic_vector(3 downto 0);
signal s0			:	std_logic_vector(3 downto 0);
signal secs     	:	std_logic_vector(7 downto 0);
signal mins			:	std_logic_vector(7 downto 0);
signal hrs			:	std_logic_vector(7 downto 0);
signal msCounter  :  std_logic_vector(8 downto 0);

begin
		
	cd1 : clockDiv
 	    generic map(250000)
		port map(
		inClk => clk100,
		rst => rst,
		outClk => milClk
		);
		
	bsec : bin2bcd
		port map(
		binary => secs,
		unit => s0,
		tens => s1,
		hundreds => open
		);
		
	bmin : bin2bcd
		port map(
		binary => mins,
		unit => d0,
		tens => d1,
		hundreds => open
		);
		
	bhr : bin2bcd
		port map(
		binary => hrs,
		unit => d2,
		tens => d3,
		hundreds => open
		);

    vit : vga_initials_top
        port map(
        clk => clk100,
        reset => rst,
        sec0 => s0,
        sec1 => s1,
        min0 => d0,
        min1 => d1,
        hou0 => d2,
        hou1 => d3,
        hsync => hsync,
        vsync => vsync,
        red => red,
        green => green,
        blue => blue
   );
	
	mode <= btnC;
    setHrs <= btnL & btnR;              -- set hours or minutes or seconds in set mode
    
	process(milClk, rst)
	begin
		if (rst='1') then
		    secs <= "00000000";
			mins <= "00000111";				-- 7 minutes
			hrs <= "00001100";			    -- 12 hours
		    msCounter <=  "000000000";      -- milli seconds counter
		elsif(rising_edge(milClk)) then

			if (mode = '1') then			-- Go Mode
			    msCounter <= msCounter + "000000001";
			    if (msCounter = "110010000") then            -- 400x2.5ms = 1 sec
			        msCounter <=  "000000000";
				    secs <= secs + "00000001";	 -- increment seconds counter
				end if;
			else							-- Set Mode
				if (setHrs = "10") then
					if (btnU = '1') then
						hrs <= hrs + "00000001";
					end if;
					if (btnD = '1') then
						hrs <= hrs - "00000001";
					end if;
				else
				    if (setHrs = "01") then
                        if (btnU = '1') then
                            mins <= mins + "00000001";
                        end if;
                        if (btnD = '1') then
                            mins <= mins - "00000001";
                        end if;
                    else
                        if (btnU = '1') then
                            secs <= secs + "00000001";
                        end if;
                        if (btnD = '1') then
                            secs <= secs - "00000001";
                        end if;
                    end if;
				end if;
			end if;
			
			if (secs >= "00111100") then			-- seconds = 60
				secs <= "00000000";
				mins <= mins + "00000001";
			end if;
			if (mins >= "00111100") then			-- minutes = 60
				mins <= "00000000";
				hrs <= hrs + "00000001";
			end if;
			if (hrs >= "00011000") then			-- hours = 24
				hrs <= "00000000";
			end if;
		end if;
	end process;
end Behavioral;