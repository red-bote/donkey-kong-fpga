----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/28/2024 01:45:30 PM
-- Design Name: 
-- Module Name: adec_intrf - Behavioral
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
--   See github.com/gaz68/Arcade-DonkeyKongJunior_MiSTer/blob/master/src/dkongjr_adec.v
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

entity adec_intrf is
    Port ( 
        I_CLK12M        : in  std_logic;
        I_CLK           : in  std_logic;
        I_RESET_n       : in  std_logic;
        I_AB            : in  std_logic_vector(15 downto 0);
        I_DB            : in  std_logic_vector( 3 downto 0);
        I_MREQ_n        : in  std_logic;
        I_RFSH_n        : in  std_logic;
        I_RD_n          : in  std_logic;
        I_WR_n          : in  std_logic;
        I_VRAMBUSY_n    : in  std_logic;
        I_VBLK_n        : in  std_logic;
        O_WAIT_n        : out std_logic;
        O_NMI_n         : out std_logic;
        O_ROM_CS_n      : out std_logic;                                -- 0000 H - 3FFF H  (5E,5C,5B,5A)
        O_RAM1_CS_n     : out std_logic;                                -- 6000 H - 67FF H  (3B,3C,4B,4C)
        O_RAM2_CS_n     : out std_logic;                                -- 6400 H - 67FF H  (3B,4B)
        O_RAM3_CS_n     : out std_logic;                                -- 6800 H - 6BFF H  (3A,4A)
--        O_DMA_CS_n      : out std_logic;                                -- 7800 H - 783F H  (DMA)
--        O_6A_G_n        : out std_logic;                                -- 7000 H - 77FF H   => Active
        O_OBJ_RQ_n      : out std_logic;                                -- 7000 H - 73FF H
        O_OBJ_RD_n      : out std_logic;                                -- 7000 H - 73FF H  (R mode)
        O_OBJ_WR_n      : out std_logic;                                -- 7000 H - 73FF H  (W mode)
        O_VRAM_RD_n     : out std_logic;                                -- 7400 H - 77FF H  (R mode)
        O_VRAM_WR_n     : out std_logic;                                -- 7400 H - 77FF H  (W mode)
        O_SW1_OE_n      : out std_logic;                                -- 7C00 H           (R mode)
        O_SW2_OE_n      : out std_logic;                                -- 7C80 H           (R mode)
        O_SW3_OE_n      : out std_logic;                                -- 7D00 H           (R mode)
        O_DIP_OE_n      : out std_logic;                                -- 7D80 H           (R mode)
        O_4H_Q          : out std_logic_vector(1 downto 0);   -- GFX (Characters) bank switch, sound
        O_5H_Q          : out std_logic_vector(7 downto 0);   -- FLIP,
        O_6H_Q          : out std_logic_vector(7 downto 0);   -- sound
        O_3D_Q          : out std_logic_vector(4 downto 0)    -- sound
);
end adec_intrf;

architecture Behavioral of adec_intrf is

    component dkongjr_adec
    port (
        I_CLK12M        : in  std_logic;
        I_CLK           : in  std_logic;
        I_RESET_n       : in  std_logic;
        I_AB            : in  std_logic_vector(15 downto 0);
        I_DB            : in  std_logic_vector( 3 downto 0);
        I_MREQ_n        : in  std_logic;
        I_RFSH_n        : in  std_logic;
        I_RD_n          : in  std_logic;
        I_WR_n          : in  std_logic;
        I_VRAMBUSY_n    : in  std_logic;
        I_VBLK_n        : in  std_logic;
        O_WAIT_n        : out std_logic;
        O_NMI_n         : out std_logic;
        O_ROM_CS_n      : out std_logic;                                -- 0000 H - 3FFF H  (5E,5C,5B,5A)
        O_RAM1_CS_n     : out std_logic;                                -- 6000 H - 67FF H  (3B,3C,4B,4C)
        O_RAM2_CS_n     : out std_logic;                                -- 6000 H - 67FF H  (3B,3C,4B,4C)
        O_RAM3_CS_n     : out std_logic;                                -- 6800 H - 6BFF H  (3A,4A)
        O_DMA_CS_n      : out std_logic;                                -- 7800 H - 783F H  (DMA)
        O_6A_G_n        : out std_logic;                                -- 7000 H - 77FF H   => Active
        O_OBJ_RQ_n      : out std_logic;                                -- 7000 H - 73FF H
        O_OBJ_RD_n      : out std_logic;                                -- 7000 H - 73FF H  (R mode)
        O_OBJ_WR_n      : out std_logic;                                -- 7000 H - 73FF H  (W mode)
        O_VRAM_RD_n     : out std_logic;                                -- 7400 H - 77FF H  (R mode)
        O_VRAM_WR_n     : out std_logic;                                -- 7400 H - 77FF H  (W mode)
        O_SW1_OE_n      : out std_logic;                                -- 7C00 H           (R mode)
        O_SW2_OE_n      : out std_logic;                                -- 7C80 H           (R mode)
        O_SW3_OE_n      : out std_logic;                                -- 7D00 H           (R mode)
        O_DIP_OE_n      : out std_logic;                                -- 7D80 H           (R mode)
        O_4H_Q          : out std_logic_vector(1 downto 0);   -- GFX (Characters) bank switch, sound
        O_5H_Q          : out std_logic_vector(7 downto 0);   -- FLIP,
        O_6H_Q          : out std_logic_vector(7 downto 0);   -- sound
        O_3D_Q          : out std_logic_vector(4 downto 0)    -- sound
    );
    end component;

begin

    -- Address Decoder
    adec : dkongjr_adec
    port map (
        I_CLK12M        => I_CLK12M,
        I_CLK           => I_CLK,
        I_RESET_n       => I_RESET_n,
        I_AB            => I_AB,
        I_DB            => I_DB,
        I_MREQ_n        => I_MREQ_n,
        I_RFSH_n        => I_RFSH_n,
        I_RD_n          => I_RD_n,
        I_WR_n          => I_WR_n,
        I_VRAMBUSY_n    => I_VRAMBUSY_n,
        I_VBLK_n        => I_VBLK_n,
        O_WAIT_n        => O_WAIT_n,
        O_NMI_n         => O_NMI_n,
        O_ROM_CS_n      => O_ROM_CS_n,
        O_RAM1_CS_n     => O_RAM1_CS_n, -- 1K addressed
        O_RAM2_CS_n     => O_RAM2_CS_n, -- 1K addressed
        O_RAM3_CS_n     => O_RAM3_CS_n,
        O_DMA_CS_n      => open,
        O_6A_G_n        => open,
        O_OBJ_RQ_n      => O_OBJ_RQ_n,
        O_OBJ_RD_n      => O_OBJ_RD_n,
        O_OBJ_WR_n      => O_OBJ_WR_n,
        O_VRAM_RD_n     => O_VRAM_RD_n,
        O_VRAM_WR_n     => O_VRAM_WR_n,
        O_SW1_OE_n      => O_SW1_OE_n,
        O_SW2_OE_n      => O_SW2_OE_n,
        O_SW3_OE_n      => O_SW3_OE_n,
        O_DIP_OE_n      => O_DIP_OE_n,
        O_4H_Q          => O_4H_Q,
        O_5H_Q          => O_5H_Q,
        O_6H_Q          => O_6H_Q,
        O_3D_Q          => O_3D_Q
    );

end Behavioral;
