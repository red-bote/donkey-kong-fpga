----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/17/2024 03:03:26 PM
-- Design Name: 
-- Module Name: sound_mix_intrf - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--   DK Jr. analog sounds simulated from samples
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

--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity sound_mix_intrf is
    port (
        I_RESETn     : in STD_LOGIC;
        I_CLK_24576M : in STD_LOGIC;
        I_CLK_12288M : in STD_LOGIC;

        I8035_PBI : in STD_LOGIC_VECTOR (7 downto 0); -- dkjr only
        W_H_CNT   : in STD_LOGIC_VECTOR (9 downto 0); -- dkjr only
        W_5H_Q    : in STD_LOGIC_VECTOR (7 downto 0); -- dkjr only

        W_6H_Q    : in STD_LOGIC_VECTOR (7 downto 0);
        W_D_S_DAT : in STD_LOGIC_VECTOR (7 downto 0);

        O_SOUND_MIX : out STD_LOGIC_VECTOR (8 downto 0) -- clipped mixed sound to dac_di
    );
end sound_mix_intrf;

architecture Behavioral of sound_mix_intrf is

    signal WAV_ROM_A  : STD_LOGIC_VECTOR(17 downto 0);
    signal WAV_ROM_DO : STD_LOGIC_VECTOR(7 downto 0);
    signal dac_di     : STD_LOGIC_VECTOR(8 downto 0);
    signal sound_mix  : STD_LOGIC_VECTOR(8 downto 0);

    signal O_SOUND_DAT : std_logic_vector(15 downto 0);

    -- experimental
    signal DIG_SND_DO : std_logic_vector(7 downto 0); 

    component sound_mix_dkj
    port (
        W_CLK_24576M : in std_logic;
        W_CLK_12288M : in std_logic;
        W_RESETn: in std_logic;
        W_H_CNT : in std_logic_vector(9 downto 0);
        W_5H_Q : in std_logic_vector(7 downto 0);
        W_6H_Q : in std_logic_vector(7 downto 0);
        W_D_S_DAT : in std_logic_vector(7 downto 0);
        I8035_PBI : in std_logic_vector(7 downto 0);

        o_data_d : out std_logic_vector(7 downto 0);
        o_data_a : out std_logic_vector(7 downto 0)
    );
    end component;

begin

    u_sound_mix : sound_mix_dkj
        port map(
            W_CLK_24576M => I_CLK_24576M,
            W_CLK_12288M => I_CLK_12288M,
            W_RESETn => I_RESETn,

            W_H_CNT => W_H_CNT,
            W_5H_Q => W_5H_Q,
            W_6H_Q => W_6H_Q,
            W_D_S_DAT => W_D_S_DAT,
            I8035_PBI => I8035_PBI,

            o_data_d => DIG_SND_DO,
            o_data_a => WAV_ROM_DO
        );
    sound_mix <= '0' & WAV_ROM_DO + DIG_SND_DO;


--    analog_sound : entity work.dkong_wav_sound
--        port map(
--            O_ROM_AB => WAV_ROM_A,
--            I_ROM_DB => (others => '0'),

--            I_CLK  => I_CLK_24576M,
--            I_RSTn => I_RESETn,
--            I_SW   => W_6H_Q(2 downto 0)
--        );

--    u_wav_rom : entity work.samples_rom
--        port map(
--            i_clk  => I_CLK_24576M,
--            i_addr => WAV_ROM_A(15 downto 0),
--            o_data => WAV_ROM_DO
--        );

--    sound_mix <= '0' & WAV_ROM_DO + W_D_S_DAT;

    -- SOUND MIXER (WAV + DIG )
    sound_mixer : process (I_CLK_12288M)
    begin
        if rising_edge(I_CLK_12288M) then
            if (sound_mix >= "101111111") then -- POS Limiter
                dac_di           <= "011111111";
            elsif (sound_mix <= "010000000") then -- NEG Limiter
                dac_di           <= (others => '0');
            else
                dac_di <= sound_mix - "010000000";
            end if;
        end if;
    end process;

    O_SOUND_MIX <= dac_di;

end Behavioral;
