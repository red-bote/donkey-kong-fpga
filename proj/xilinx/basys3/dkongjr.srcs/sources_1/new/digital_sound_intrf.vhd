----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/28/2024 01:46:06 PM
-- Design Name: 
-- Module Name: digital_sound_intrf - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--  Interface file for DK or DKJR specific Verilog sources.
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--   dkongjr_sound.v from https://github.com/MiSTer-devel/Arcade-DonkeyKongJunior_MiSTer
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

entity digital_sound_intrf is
    Port (
        I_CLK1      : in  std_logic;
        I_RST       : in  std_logic;
        I8035_DBI   : in  std_logic_vector(7 downto 0);
        I8035_DBO   : out std_logic_vector(7 downto 0);
        I8035_PAI   : in  std_logic_vector(7 downto 0);
        I8035_PBI   : in  std_logic_vector(7 downto 0);
        I8035_PBO   : out std_logic_vector(7 downto 0);
        I8035_ALE   : in  std_logic;
        I8035_RDn   : in  std_logic;
        I8035_PSENn : in  std_logic;
        I8035_RSTn  : out std_logic;
        I8035_INTn  : out std_logic;
        I8035_T0    : out std_logic;
        I8035_T1    : out std_logic;
        I_SOUND_DAT : in  std_logic_vector(4 downto 0);
        I_SOUND_CNT : in  std_logic_vector(5 downto 0);
        O_SOUND_DAT : out std_logic_vector(7 downto 0)
        );
end digital_sound_intrf;

architecture Behavioral of digital_sound_intrf is

    component dkongjr_sound
    port(
        I_CLK1      : in  std_logic;
        I_RST       : in  std_logic;
        I8035_DBI   : in  std_logic_vector(7 downto 0);
        I8035_DBO   : out std_logic_vector(7 downto 0);
        I8035_PAI   : in  std_logic_vector(7 downto 0);
        I8035_PBI   : in  std_logic_vector(7 downto 0);
        I8035_PBO   : out std_logic_vector(7 downto 0);
        I8035_ALE   : in  std_logic;
        I8035_RDn   : in  std_logic;
        I8035_PSENn : in  std_logic;
        I8035_RSTn  : out std_logic;
        I8035_INTn  : out std_logic;
        I8035_T0    : out std_logic;
        I8035_T1    : out std_logic;
        I_SOUND_DAT : in  std_logic_vector(4 downto 0);
        I_SOUND_CNT : in  std_logic_vector(5 downto 0);
        O_SOUND_DAT : out std_logic_vector(7 downto 0)
    );
    end component;

begin

    digital_sound : dkongjr_sound 
    port map (
        I_CLK1          => I_CLK1,
        I_RST           => I_RST,
        I8035_DBI       => I8035_DBI,
        I8035_DBO       => I8035_DBO,
        I8035_PAI       => I8035_PAI,
        I8035_PBI       => I8035_PBI,
        I8035_PBO       => I8035_PBO,
        I8035_ALE       => I8035_ALE,
        I8035_RDn       => I8035_RDn,
        I8035_PSENn     => I8035_PSENn,
        I8035_RSTn      => I8035_RSTn,
        I8035_INTn      => I8035_INTn,
        I8035_T0        => I8035_T0,
        I8035_T1        => I8035_T1,
        I_SOUND_DAT     => I_SOUND_DAT,
        I_SOUND_CNT     => I_SOUND_CNT,
        O_SOUND_DAT     => O_SOUND_DAT
    );

end Behavioral;
