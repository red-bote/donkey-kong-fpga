----------------------------------------------------------------------------------
-- Company: Red~Bote
-- Engineer: Red-Bote
-- 
-- Create Date: 05/20/2024 08:46:02 PM
-- Design Name: 
-- Module Name: dkong_basys3_top
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
--   Originally converted to VHDL from Verilog and targeted to the Papilio board 
--   (Spartan 6 FPGA) by Alex aka d18c7db. The Spartan FPGA did not have enough BRAM  
--   available to hold all the ROM images and sound samples which were instead  
--   loaded from SPI flash to an SRAM during the powerup bootstrapping process.
--   The Basys 3 board does not have an SRAM but the Artix-7 FPGA is able to hold  
--   all the image data in BRAM.
----------------------------------------------------------------------------------
--
--	(c) 2012 d18c7db(a)hotmail
--
--	This program is free software; you can redistribute it and/or modify it under
--	the terms of the GNU General Public License version 3 or, at your option,
--	any later version as published by the Free Software Foundation.
--
--	This program is distributed in the hope that it will be useful,
--	but WITHOUT ANY WARRANTY; without even the implied warranty of
--	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--
-- For full details, see the GNU General Public License at www.gnu.org/licenses
--
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use ieee.numeric_std.all;

library unisim;
	use unisim.vcomponents.all;

entity dkong_basys3 is
	port(
		-- ext VGA monitor
		O_VIDEO_R	: out		std_logic_vector(3 downto 0);
		O_VIDEO_G	: out		std_logic_vector(3 downto 0);
		O_VIDEO_B	: out		std_logic_vector(3 downto 0);
		O_HSYNC		: out		std_logic;
		O_VSYNC		: out		std_logic;

		-- Sound out
		O_AUDIO_L	: out		std_logic;
		O_AUDIO_R	: out		std_logic;

		-- active high buttons
		I_SW			: in		std_logic_vector(3 downto 0) := (others => '0');

		--
		I_RESET		: in		std_logic := '0';						-- Active high external reset

		-- external clock source
		CLK_IN		: in		std_logic := '0'						-- System clock 32Mhz

	);
end dkong_basys3;

architecture RTL of dkong_basys3 is

	signal reset				: std_logic := '0';
	signal clk_24M				: std_logic := '0';	-- main system clock

	-- output signals
	signal VideoR				: std_logic_vector(2 downto 0) := (others => '0');
	signal VideoG				: std_logic_vector(2 downto 0) := (others => '0');
	signal VideoB				: std_logic_vector(1 downto 0) := (others => '0');
	signal HSync				: std_logic := '0';
	signal VSync				: std_logic := '0';

	-- input controls
	signal P1U					: std_logic := '0';
	signal P1D					: std_logic := '0';
	signal P1L					: std_logic := '0';
	signal P1R					: std_logic := '0';
	signal P1J					: std_logic := '0';
	signal P1S					: std_logic := '0';
	signal P2U					: std_logic := '0';
	signal P2D					: std_logic := '0';
	signal P2L					: std_logic := '0';
	signal P2R					: std_logic := '0';
	signal P2J					: std_logic := '0';
	signal P2S					: std_logic := '0';
	signal COIN					: std_logic := '0';

begin

	-- clock MMCM
	u_mmcm_24M : entity work.mmcm_24M
	port map (
		CLK_IN			=> CLK_IN,
		I_RESET			=> reset,
		O_CLK_24M		=> clk_24M
	);

	reset			<= I_SW(0) and I_SW(1) and I_SW(2) and I_SW(3);
	P1U			<= not I_SW(1);
	P1D			<= not I_SW(2);
	P1L			<= not I_SW(0);
	P1R			<= not I_SW(3);
	P1J			<= not I_RESET;
	P1S			<= not (I_SW(0) and I_RESET);

	P2U			<= not I_SW(1);
	P2D			<= not I_SW(2);
	P2L			<= not I_SW(0);
   P2R			<= not I_SW(3);
   P2J			<= not I_RESET;
   P2S			<= not (I_SW(3) and I_RESET);

	COIN			<= not (I_SW(1) and I_RESET);

	O_VIDEO_G	<= VideoG & "0";
	O_VIDEO_R	<= VideoR & "0";
	O_VIDEO_B	<= VideoB & "00";
	O_HSYNC		<= HSync;
	O_VSYNC		<= VSync;

	u_dkong : entity work.dkong_main
	port map (

		-- FPGA_USE
		I_CLK_24576M	=> clk_24M,
		I_RESETn			=> '1', -- bootstrap_done,

		-- INPORT SW IF active low
		I_U1				=> P1U, -- P1 up
		I_D1				=> P1D, -- P1 down
		I_L1				=> P1L, -- P1 left
		I_R1				=> P1R, -- P1 right
		I_J1				=> P1J, -- P1 jump
		I_S1				=> P1S, -- P1 start

		I_U2				=> P2U, -- P2 up
		I_D2				=> P2D, -- P2 down
		I_L2				=> P2L, -- P2 left
		I_R2				=> P2R, -- P2 right
		I_J2				=> P2J, -- P2 jump
		I_S2				=> P2S, -- P2 start

		I_C1				=> COIN, -- Coin

		-- SOUND IF
		O_SOUND_OUT_L	=> O_AUDIO_L,
		O_SOUND_OUT_R	=> O_AUDIO_R,

		-- VGA (VIDEO) IF
		O_VGA_R			=> VideoR,
		O_VGA_G			=> VideoG,
		O_VGA_B			=> VideoB,
		O_VGA_H_SYNCn	=> HSync,
		O_VGA_V_SYNCn	=> VSync
	);
end RTL;
