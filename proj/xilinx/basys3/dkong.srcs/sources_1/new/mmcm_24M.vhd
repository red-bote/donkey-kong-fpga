----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/20/2024 08:52:40 PM
-- Design Name: 
-- Module Name: mmcm_24M - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
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

entity mmcm_24M is
    Port ( CLK_IN : in STD_LOGIC;
           I_RESET : in STD_LOGIC;
           O_CLK_24M : out STD_LOGIC);
end mmcm_24M;

architecture Behavioral of mmcm_24M is

-- The following code must appear in the VHDL architecture header:
------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
component clk_wiz_0
port
 (
  -- Clock out ports
  clk_out1          : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  locked            : out    std_logic;
  -- Clock in ports
  clk_in1           : in     std_logic
 );
end component;

-- COMP_TAG_END ------ End COMPONENT Declaration ------------

begin

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
u_clk_wiz : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out1 => O_CLK_24M,
  -- Status and control signals                
   reset => I_RESET,
   locked => open, -- locked,
   -- Clock in ports
   clk_in1 => CLK_IN
 );
-- INST_TAG_END ------ End INSTANTIATION Template ------------

end Behavioral;
