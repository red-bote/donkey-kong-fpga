----------------------------------------------------------------------------------
-- Company: Red~Bote
-- Engineer: red-bote
-- 
-- Create Date: 08/10/2024 11:14:20 AM
-- Design Name: 
-- Module Name: samples_rom
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--   the analog sound samples are broken up into smaller pieces that can be 
--   converted to VHDL which is able to be implemented as BRAMs
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity samples_rom is
    Port ( i_clk : in STD_LOGIC;
           i_addr : in STD_LOGIC_VECTOR (15 downto 0);
           o_data : out STD_LOGIC_VECTOR (7 downto 0));
end samples_rom;

architecture RTL of samples_rom is
    signal data_0 : std_logic_vector(7 downto 0);
    signal data_1 : std_logic_vector(7 downto 0);
    signal data_2 : std_logic_vector(7 downto 0);
    signal data_3 : std_logic_vector(7 downto 0);
    signal data_4 : std_logic_vector(7 downto 0);
    signal data_5 : std_logic_vector(7 downto 0);
begin

  u_snd_0 : entity work.WAV_SND_0
  port map (
    CLK         => i_clk,
    ENA         => '1',
    ADDR        => i_addr(12 downto 0),
    DATA        => data_0
    );

  u_snd_1 : entity work.WAV_SND_1
  port map (
    CLK         => i_clk,
    ENA         => '1',
    ADDR        => i_addr(12 downto 0),
    DATA        => data_1
    );

  u_snd_2 : entity work.WAV_SND_2
  port map (
    CLK         => i_clk,
    ENA         => '1',
    ADDR        => i_addr(12 downto 0),
    DATA        => data_2
    );

  u_snd_3 : entity work.WAV_SND_3
  port map (
    CLK         => i_clk,
    ENA         => '1',
    ADDR        => i_addr(12 downto 0),
    DATA        => data_3
    );

  u_snd_4 : entity work.WAV_SND_4
  port map (
    CLK         => i_clk,
    ENA         => '1',
    ADDR        => i_addr(12 downto 0),
    DATA        => data_4
    );

  u_snd_5 : entity work.WAV_SND_5
  port map (
    CLK         => i_clk,
    ENA         => '1',
    ADDR        => i_addr(12 downto 0),
    DATA        => data_5
    );

  o_data <= data_0 when i_addr(15 downto 13) = "000" else
            data_1 when i_addr(15 downto 13) = "001" else
            data_2 when i_addr(15 downto 13) = "010" else
            data_3 when i_addr(15 downto 13) = "011" else
            data_4 when i_addr(15 downto 13) = "100" else
            data_5 ; -- when i_addr(15 downto 13) = "101"

end RTL;
