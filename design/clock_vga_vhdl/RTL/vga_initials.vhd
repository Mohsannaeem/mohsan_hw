LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity vga_initials is
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
end vga_initials;

architecture trans OF vga_initials is

   constant  hbp     :  integer := 144;
   constant  vbp     :  integer := 31;
   constant  W       :  integer := 256;
   constant  H       :  integer := 256;
   constant  offset  :  integer := 32;
   signal time_en    : std_logic_vector(7 downto 0);
   signal hc_i       : integer;
   signal vc_i       : integer;
   signal rom_pix    : integer;
   signal rom_pix5   : std_logic_vector(4 downto 0) ;
   signal rom_addr   : integer;
   signal R          : std_logic;
   signal G          : std_logic;
   signal B          : std_logic;
   
begin
   
   hc_i <= to_integer(unsigned(hc));
   vc_i <= to_integer(unsigned(vc));
   red <= R&R&R;
   green <= G&G&G;
   blue <= B&B&B;
   rom_pix <= hc_i - hbp;
              rom_addr <= vc_i - vbp;
   rom_addr4 <= std_logic_vector(to_unsigned(rom_addr, 4));
   rom_pix5 <= std_logic_vector(to_unsigned(rom_pix, 5));
   
   process (hc, vc)
   begin
      if ((hc_i >= hbp) and (hc_i < hbp + W) and (vc_i >= vbp) and (vc_i < vbp + H)) then
         time_en <= "00000001";
      elsif ((hc_i >= hbp + offset) and (hc_i < hbp + W + offset) and (vc_i >= vbp) and (vc_i < vbp + H)) then
         time_en <= "00000010";
      elsif ((hc_i >= hbp + (2*offset)) and (hc_i < hbp + W + (2*offset)) and (vc_i >= vbp) and (vc_i < vbp + H)) then
        time_en <= "00000100";
      elsif ((hc_i >= hbp + (3*offset)) and (hc_i < hbp + W + (3*offset)) and (vc_i >= vbp) and (vc_i < vbp + H)) then
     	time_en <= "00001000";   
      elsif ((hc_i >= hbp + (4*offset)) and (hc_i < hbp + W + (4*offset)) and (vc_i >= vbp) and (vc_i < vbp + H)) then
      	time_en <= "00010000";
      elsif ((hc_i >= hbp + (5*offset)) and (hc_i < hbp + W + (5*offset)) and (vc_i >= vbp) and (vc_i < vbp + H)) then
      	time_en <= "00100000";
      elsif ((hc_i >= hbp + (6*offset)) and (hc_i < hbp + W + (6*offset)) and (vc_i >= vbp) and (vc_i < vbp + H)) then
         time_en <= "01000000";
      elsif ((hc_i >= hbp + (7*offset)) and (hc_i < hbp + W + (7*offset)) and (vc_i >= vbp) and (vc_i < vbp + H)) then
      time_en <= "10000000";
      else
         time_en <= (others=>'0');
      end if;
      
   end process;
   
   process (clk)
   begin
        case time_en is
           when "00000001" =>
              R <= Second0(to_integer(unsigned(rom_pix5)));
              G <= Second0(to_integer(unsigned(rom_pix5)));
              B <= Second0(to_integer(unsigned(rom_pix5)));
           when "00000010" =>
              R <= Second1(to_integer(unsigned(rom_pix5)));
              G <= Second1(to_integer(unsigned(rom_pix5)));
              B <= Second1(to_integer(unsigned(rom_pix5)));
           when "00000100" =>
              R <= sepra(to_integer(unsigned(rom_pix5)));
              G <= sepra(to_integer(unsigned(rom_pix5)));
              B <= sepra(to_integer(unsigned(rom_pix5)));
           when "00001000" =>
              R <= minute0(to_integer(unsigned(rom_pix5)));
              G <= minute0(to_integer(unsigned(rom_pix5)));
              B <= minute0(to_integer(unsigned(rom_pix5)));
           when "00010000" =>
              R <= minute1(to_integer(unsigned(rom_pix5)));
              G <= minute1(to_integer(unsigned(rom_pix5)));
              B <= minute1(to_integer(unsigned(rom_pix5)));
           when "00100000" =>
              R <= sepra(to_integer(unsigned(rom_pix5)));
              G <= sepra(to_integer(unsigned(rom_pix5)));
              B <= sepra(to_integer(unsigned(rom_pix5)));
           when "01000000" =>
              R <= hour0(to_integer(unsigned(rom_pix5)));
              G <= hour0(to_integer(unsigned(rom_pix5)));
              B <= hour0(to_integer(unsigned(rom_pix5)));
           when "10000000" =>
              R <= hour1(to_integer(unsigned(rom_pix5)));
              G <= hour1(to_integer(unsigned(rom_pix5)));
              B <= hour1(to_integer(unsigned(rom_pix5)));
	   when others =>
              R <= '0';
              G <= '0';
              B <= '0';
        end case;
   end process;
   
END trans;