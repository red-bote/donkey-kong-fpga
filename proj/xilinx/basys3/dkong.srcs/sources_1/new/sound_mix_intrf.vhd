----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/17/2024 03:02:29 PM
-- Design Name: 
-- Module Name: sound_mix_intrf - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--   DK analog sounds simulated from samples
-- Dependencies: 
--  DK specific sound-mixer module for loading DK analog samples 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


--use ieee.std_logic_unsigned.all;


entity sound_mix_intrf is
    port (
        I_RESETn     : in STD_LOGIC;
        I_CLK_24576M : in STD_LOGIC;
        I_CLK_12288M : in STD_LOGIC;

        I8035_PBI : in STD_LOGIC_VECTOR (7 downto 0); -- dkjr only
        W_H_CNT   : in STD_LOGIC_VECTOR (9 downto 0); -- dkjr only
        W_5H_Q    : in STD_LOGIC_VECTOR (7 downto 0); -- dkjr only

        W_6H_Q : in STD_LOGIC_VECTOR (7 downto 0);
        W_D_S_DAT : in STD_LOGIC_VECTOR (7 downto 0);

        O_SOUND_MIX : out STD_LOGIC_VECTOR (7 downto 0)
    );
end sound_mix_intrf;

architecture Behavioral of sound_mix_intrf is

    component sound_mixer
    port (
        W_CLK_24576M : in std_logic;
        W_CLK_12288M : in std_logic;
        W_RESETn: in std_logic;
        W_H_CNT : in std_logic_vector(9 downto 0);
        W_5H_Q : in std_logic_vector(7 downto 0);
        W_6H_Q : in std_logic_vector(7 downto 0);
        W_D_S_DAT : in std_logic_vector(7 downto 0);
        I8035_PBI : in std_logic_vector(7 downto 0);

        O_SOUND_DAT : out std_logic_vector(7 downto 0)
    );
    end component;

begin

    u_sound_mix_dk : sound_mixer
        port map(
            W_CLK_24576M => I_CLK_24576M,
            W_CLK_12288M => I_CLK_12288M,
            W_RESETn => I_RESETn,

            W_H_CNT => W_H_CNT,
            W_5H_Q => W_5H_Q,
            W_6H_Q => W_6H_Q,
            W_D_S_DAT => W_D_S_DAT,
            I8035_PBI => I8035_PBI,

            O_SOUND_DAT => O_SOUND_MIX
        );

end Behavioral;
