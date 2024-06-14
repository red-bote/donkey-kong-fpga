----------------------------------------------------------------------------------
-- Company: Red~Bote 
-- Engineer: Red-Bote
-- 
-- Create Date: 05/25/2024 08:33:44 AM
-- Design Name: 
-- Module Name: rtl_top
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--   top-level for external IO on Basys 3
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

entity rtl_top is
    Port ( clk : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           JA : in STD_LOGIC_VECTOR(4 downto 0);

           O_PMODAMP2_AIN : out STD_LOGIC;
           O_PMODAMP2_GAIN : out STD_LOGIC;
           O_PMODAMP2_SHUTD : out STD_LOGIC;

           btnU : in STD_LOGIC;
           btnD : in STD_LOGIC;
           btnL : in STD_LOGIC;
           btnR : in STD_LOGIC;
           btnC : in STD_LOGIC;

           vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
           vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
           vgaBlue : out STD_LOGIC_VECTOR (3 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           Hsync : out STD_LOGIC;
           Vsync : out STD_LOGIC);
end rtl_top;

architecture Behavioral of rtl_top is
    signal inp_switches : std_logic_vector(4 downto 0);
begin

    -- active-low shutdown pin
    O_PMODAMP2_SHUTD <= sw(14);
    -- gain pin is driven high there is a 6 dB gain, low is a 12 dB gain 
    O_PMODAMP2_GAIN <= sw(15);

--    inp_switches(0) <= btnL;
--    inp_switches(1) <= btnU;
--    inp_switches(2) <= btnD;
--    inp_switches(3) <= btnR;
--    inp_switches(4) <= btnC;

--    inp_switches(0) <= not JA(1); -- L
--    inp_switches(1) <= not JA(3); -- U
--    inp_switches(2) <= not JA(2); -- D
--    inp_switches(3) <= not JA(0); -- R
--    inp_switches(4) <= not JA(4);

    inp_switches(0) <= btnL or not JA(1); -- L
    inp_switches(1) <= btnU or not JA(3); -- U
    inp_switches(2) <= btnD or not JA(2); -- D
    inp_switches(3) <= btnR or not JA(0); -- R
    inp_switches(4) <= btnC or not JA(4);


    u_dkong_top : entity work.dkong_basys3
	port map(
		-- ext VGA monitor
		O_VIDEO_R	=> vgaRed,
		O_VIDEO_G	=> vgaGreen,
		O_VIDEO_B	=> vgaBlue,
		O_HSYNC		=> Hsync,
		O_VSYNC		=> Vsync,

		-- Sound out
        O_AUDIO_L => O_PMODAMP2_AIN,
        O_AUDIO_R => open,

		-- active high buttons
		I_SW => inp_switches(3 downto 0),

		-- on the Basys 3 this is center push-button
		I_RESET => inp_switches(4),

		-- 100MHz clock
		CLK_IN => clk
	);

end Behavioral;
