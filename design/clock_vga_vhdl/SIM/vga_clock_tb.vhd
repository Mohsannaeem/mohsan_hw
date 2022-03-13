-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 12.3.2022 20:25:25 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_vgaClockMain is
end tb_vgaClockMain;

architecture tb of tb_vgaClockMain is

    component vgaClockMain
        port (clk100 : in std_logic;
              rst    : in std_logic;
              btnU   : in std_logic;
              btnD   : in std_logic;
              btnL   : in std_logic;
              btnR   : in std_logic;
              btnC   : in std_logic;
              hsync  : out std_logic;
              vsync  : out std_logic;
              red    : out std_logic_vector (2 downto 0);
              green  : out std_logic_vector (2 downto 0);
              blue   : out std_logic_vector (2 downto 0));
    end component;

    signal clk100 : std_logic;
    signal rst    : std_logic;
    signal btnU   : std_logic;
    signal btnD   : std_logic;
    signal btnL   : std_logic;
    signal btnR   : std_logic;
    signal btnC   : std_logic;
    signal hsync  : std_logic;
    signal vsync  : std_logic;
    signal red    : std_logic_vector (2 downto 0);
    signal green  : std_logic_vector (2 downto 0);
    signal blue   : std_logic_vector (2 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : vgaClockMain
    port map (clk100 => clk100,
              rst    => rst,
              btnU   => btnU,
              btnD   => btnD,
              btnL   => btnL,
              btnR   => btnR,
              btnC   => btnC,
              hsync  => hsync,
              vsync  => vsync,
              red    => red,
              green  => green,
              blue   => blue);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk100 is really your main clock signal
    clk100 <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        btnU <= '0';
        btnD <= '0';
        btnL <= '0';
        btnR <= '0';
        btnC <= '1';

        -- Reset generation
        -- EDIT: Check that rst is really your reset signal
        rst <= '1';
        wait for 1 ns;
        rst <= '0';
        wait for 1000000 ns;

        -- EDIT Add stimuli here
        wait for 10000000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;