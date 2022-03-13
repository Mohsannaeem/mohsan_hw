library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_initials_top is
    port (
      clk       : in std_logic;
      reset     : in std_logic;
      sec0      : in std_logic_vector(3 downto 0);
      sec1      : in std_logic_vector(3 downto 0);
      min0      : in std_logic_vector(3 downto 0);
      min1      : in std_logic_vector(3 downto 0);
      hou0      : in std_logic_vector(3 downto 0);
      hou1      : in std_logic_vector(3 downto 0);
      hsync     : out std_logic;
      vsync     : out std_logic;
      red       : out std_logic_vector(2 downto 0);
      green     : out std_logic_vector(2 downto 0);
      blue      : out std_logic_vector(2 downto 0)
   );
end vga_initials_top;

architecture Behavioral of vga_initials_top is

Component clockDiv
    generic(HALF_CYCLE : integer);
    Port ( 
            inClk   : in std_logic;
            rst     : in std_logic;
            outClk  : out std_logic
        );
End Component;

Component vga640x480
    Port ( 
            clk     : in std_logic;
            clr     : in std_logic;
            hsync   : out std_logic;
            vsync   : out std_logic;
            hc      : out std_logic_vector(9 downto 0);
            vc      : out std_logic_vector(9 downto 0);
            vidon   : out std_logic
        );
End Component;

Component vga_initials
    Port ( 
            clk       : in std_logic;
            vidon     : in std_logic;
            hc        : in std_logic_vector(9 downto 0);
            vc        : in std_logic_vector(9 downto 0);
            second0   : in std_logic_vector(31 downto 0);
            second1   : in std_logic_vector(31 downto 0);
            minute0   : in std_logic_vector(31 downto 0);
            minute1   : in std_logic_vector(31 downto 0);
            hour0     : in std_logic_vector(31 downto 0);
            hour1     : in std_logic_vector(31 downto 0);
            sepra     : in std_logic_vector(31 downto 0);
            rom_addr4 : out std_logic_vector(3 downto 0);
            red       : out std_logic_vector(2 downto 0);
            green     : out std_logic_vector(2 downto 0);
            blue      : out std_logic_vector(2 downto 0)
        );
End Component;

Component promDecimals
    Port ( 
            addr      : in std_logic_vector(3 downto 0);
            keyCode   : in std_logic_vector(7 downto 0);
            M         : out std_logic_vector(31 downto 0)
        );
End Component;

signal clk25    	:	std_logic;
signal vidon		:	std_logic;
signal hc			:	std_logic_vector(9 downto 0);
signal vc			:	std_logic_vector(9 downto 0);
signal M			:	std_logic_vector(31 downto 0);
signal rom_addr4	:	std_logic_vector(3 downto 0);
signal second0  	:	std_logic_vector(31 downto 0);
signal second1  	:	std_logic_vector(31 downto 0);
signal minute0		:	std_logic_vector(31 downto 0);
signal minute1		:	std_logic_vector(31 downto 0);
signal hour0		:	std_logic_vector(31 downto 0);
signal hour1		:	std_logic_vector(31 downto 0);
signal sepra		:	std_logic_vector(31 downto 0);
signal sec80        :   std_logic_vector(7 downto 0);
signal sec81        :   std_logic_vector(7 downto 0);
signal min80        :   std_logic_vector(7 downto 0);
signal min81        :   std_logic_vector(7 downto 0);
signal hou80        :   std_logic_vector(7 downto 0);
signal hou81        :   std_logic_vector(7 downto 0);

begin

    sec80 <= "0000"&sec0;
    sec81 <= "0000"&sec1;
    min80 <= "0000"&min0;
    min81 <= "0000"&min1;
    hou80 <= "0000"&hou0;
    hou81 <= "0000"&hou1;

	cd2 : clockDiv
 	    generic map(2)
		port map(
		inClk => clk,
		rst => reset,
		outClk => clk25
		);

    vg64 : vga640x480
    port map(
            clk => clk25,
            clr => reset,
            hsync => hsync,
            vsync => vsync,
            hc => hc,
            vc => vc,
            vidon => vidon
        );
        
    vi : vga_initials
    port map(
            clk => clk25,
            vidon => vidon,
            hc => hc,
            vc => vc,
            second0 => second0,
            second1 => second1,
            minute0 => minute0,
            minute1 => minute1,
            hour0 => hour0,
            hour1 => hour1,
            sepra => sepra,
            rom_addr4 => rom_addr4,
            red => red,
            green => green,
            blue => blue
        );
       
    pd0 : promDecimals
    port map(
            addr => rom_addr4,
            keyCode => sec80,
            M => second0
        ); 
       
    pd1 : promDecimals
    port map(
            addr => rom_addr4,
            keyCode => sec81,
            M => second1
        ); 
       
    pd2 : promDecimals
    port map(
            addr => rom_addr4,
            keyCode => min80,
            M => minute0
        ); 
       
    pd3 : promDecimals
    port map(
            addr => rom_addr4,
            keyCode => min81,
            M => minute1
        ); 
       
    pd4 : promDecimals
    port map(
            addr => rom_addr4,
            keyCode => hou80,
            M => hour0
        ); 
       
    pd5 : promDecimals
    port map(
            addr => rom_addr4,
            keyCode => hou81,
            M => hour1
        ); 
       
    pd6 : promDecimals
    port map(
            addr => rom_addr4,
            keyCode => "00001010",
            M => sepra
        );
        
end Behavioral;
