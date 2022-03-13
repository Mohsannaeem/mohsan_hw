library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga640x480 is
    Port ( 
            clk     : in std_logic;
            clr     : in std_logic;
            hsync   : out std_logic;
            vsync   : out std_logic;
            hc      : out std_logic_vector(9 downto 0);
            vc      : out std_logic_vector(9 downto 0);
            vidon   : out std_logic
        );
end vga640x480;

architecture Behavioral of vga640x480 is

signal  hc_r      : std_logic_vector(9 downto 0);
signal  vc_r      : std_logic_vector(9 downto 0);
signal  vc_r1      : std_logic_vector(9 downto 0);
signal vsenable   : std_logic;

begin

vc <= vc_r;
hc <= hc_r;

process (clk)
begin
    if (vc_r <= "0000000010") then
        vsync <= '0';
    else
        vsync <= '1';
    end if;
   
    if (hc_r < "0010000000") then
        hsync <= '0';
    else
        hsync <= '1';
    end if;
   
    if ((hc_r < "1100010000") and (hc_r > "0010010000") and (vc_r < "0111111111") and (vc_r > "0000011111")) then
        vidon <= '1';
    else
        vidon <= '0';
    end if;
end process;

process (clk, clr)
begin
    if (clr='1') then
        vc_r <= (others=>'0');
        vc_r1 <= (others=>'0');
    elsif(rising_edge(clk)) then
         vc_r1 <= vc_r1 + "0000000001";
        if (vsenable = '1') then
            if (vc_r = "1000001000") then
                vc_r <= (others=>'0');
            else
                vc_r <= vc_r + "0000000001";
            end if;
        end if;
       end if;
end process;

process (clk, clr)
begin
    if (clr='1') then
        hc_r <= (others=>'0');
    elsif(rising_edge(clk)) then
        if (hc_r = "1100011111") then
            hc_r <= (others=>'0');
            vsenable <= '1';
        else
            hc_r <= hc_r + "0000000001";
            vsenable <= '0';
        end if;
       end if;
end process;


end Behavioral;
