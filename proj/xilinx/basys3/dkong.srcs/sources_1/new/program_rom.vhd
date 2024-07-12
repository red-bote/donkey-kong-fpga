----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2024 05:14:37 PM
-- Design Name: 
-- Module Name: program_rom - Behavioral
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

entity program_rom is
    Port ( i_clk : in STD_LOGIC;
           i_en : in STD_LOGIC;
           i_addr : in STD_LOGIC_VECTOR (15 downto 0);
           o_data : out STD_LOGIC_VECTOR (7 downto 0));
end program_rom;

architecture Behavioral of program_rom is
  signal data_00 : std_logic_vector(7 downto 0);
  signal data_08 : std_logic_vector(7 downto 0);
  signal data_10 : std_logic_vector(7 downto 0);
  signal data_18 : std_logic_vector(7 downto 0);
  signal data_20 : std_logic_vector(7 downto 0);
  signal data_28 : std_logic_vector(7 downto 0);
  signal data_30 : std_logic_vector(7 downto 0);
  signal data_38 : std_logic_vector(7 downto 0);
  signal data_40 : std_logic_vector(7 downto 0);
  signal data_48 : std_logic_vector(7 downto 0);
  signal data_50 : std_logic_vector(7 downto 0);
  signal data_58 : std_logic_vector(7 downto 0);
begin

  u_cpu_rom_00 : entity work.CPU_ROM_0000
  port  map(
    CLK         => i_clk,
    ENA         => i_en,
    ADDR        => i_addr(10 downto 0),
    DATA        => data_00
    );

  u_cpu_rom_08 : entity work.CPU_ROM_0800
  port  map(
    CLK         => i_clk,
    ENA         => i_en,
    ADDR        => i_addr(10 downto 0),
    DATA        => data_08
    );

  u_cpu_rom_10 : entity work.CPU_ROM_1000
  port  map(
    CLK         => i_clk,
    ENA         => i_en,
    ADDR        => i_addr(10 downto 0),
    DATA        => data_10
    );

  u_cpu_rom_18 : entity work.CPU_ROM_1800
  port  map(
    CLK         => i_clk,
    ENA         => i_en,
    ADDR        => i_addr(10 downto 0),
    DATA        => data_18
    );

  u_cpu_rom_20 : entity work.CPU_ROM_2000
  port  map(
    CLK         => i_clk,
    ENA         => i_en,
    ADDR        => i_addr(10 downto 0),
    DATA        => data_20
    );

  u_cpu_rom_28 : entity work.CPU_ROM_2800
  port  map(
    CLK         => i_clk,
    ENA         => i_en,
    ADDR        => i_addr(10 downto 0),
    DATA        => data_28
    );

  u_cpu_rom_30 : entity work.CPU_ROM_3000
  port  map(
    CLK         => i_clk,
    ENA         => i_en,
    ADDR        => i_addr(10 downto 0),
    DATA        => data_30
    );

  u_cpu_rom_38 : entity work.CPU_ROM_3800
  port  map(
    CLK         => i_clk,
    ENA         => i_en,
    ADDR        => i_addr(10 downto 0),
    DATA        => data_38
    );

  u_cpu_rom_40 : entity work.CPU_ROM_4000
  port  map(
    CLK         => i_clk,
    ENA         => i_en,
    ADDR        => i_addr(10 downto 0),
    DATA        => data_40
    );

  u_cpu_rom_48 : entity work.CPU_ROM_4800
  port  map(
    CLK         => i_clk,
    ENA         => i_en,
    ADDR        => i_addr(10 downto 0),
    DATA        => data_48
    );

  u_cpu_rom_50 : entity work.CPU_ROM_5000
  port  map(
    CLK         => i_clk,
    ENA         => i_en,
    ADDR        => i_addr(10 downto 0),
    DATA        => data_50
    );

  u_cpu_rom_58 : entity work.CPU_ROM_5800
  port  map(
    CLK         => i_clk,
    ENA         => i_en,
    ADDR        => i_addr(10 downto 0),
    DATA        => data_58
    );


    addr_proc : process(i_addr)
    begin
        case i_addr(14 downto 11) is
            when "0000" => o_data <= data_00;
            when "0001" => o_data <= data_08;
            when "0010" => o_data <= data_10;
            when "0011" => o_data <= data_18;
            when "0100" => o_data <= data_20;
            when "0101" => o_data <= data_28;
            when "0110" => o_data <= data_30;
            when "0111" => o_data <= data_38;
            when "1000" => o_data <= data_40;
            when "1001" => o_data <= data_48;
            when "1010" => o_data <= data_50;
            when "1011" => o_data <= data_58;
            when others => null;
        end case;
    end process addr_proc;

end Behavioral;
