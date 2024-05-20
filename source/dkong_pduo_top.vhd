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
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use ieee.numeric_std.all;

library unisim;
	use unisim.vcomponents.all;

entity dkong_pduo is
	port(
		-- FLASH
		FLASH_CS		: out		std_logic;								-- Active low FLASH chip select
		FLASH_SI		: out		std_logic;								-- Serial output to FLASH chip SI pin
		FLASH_CK		: out		std_logic;								-- FLASH clock
		FLASH_SO		: in		std_logic := '0';						-- Serial input from FLASH chip SO pin

		-- SRAM
--		SRAM_A		: out		std_logic_vector(17 downto 0);	-- SRAM address bus
--		SRAM_D		: inout	std_logic_vector(15 downto 0);	-- SRAM data bus
		SRAM_A		: out		std_logic_vector(18 downto 0);	-- SRAM address bus
		SRAM_D		: inout	std_logic_vector(7 downto 0);	-- SRAM data bus
		SRAM_nCS		: out		std_logic;								-- SRAM chip select active low
		SRAM_nWE		: out		std_logic;								-- SRAM write enable active low
		SRAM_nOE		: out		std_logic;								-- SRAM output enable active low
--		SRAM_nBE		: out		std_logic;								-- SRAM byte enables active low

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

		-- 32MHz clock
		CLK_IN		: in		std_logic := '0'						-- System clock 32Mhz

	);
end dkong_pduo;

architecture RTL of dkong_pduo is
	--
	-- bootstrap signals
	--

	-- bootstrap control of SRAM, these signals connect to SRAM when boostrap_done = '0'
	signal bs_A					: std_logic_vector(17 downto 0) := (others => '0');
--	signal bs_A					: std_logic_vector(18 downto 0) := (others => '0');
	signal bs_Din				: std_logic_vector( 7 downto 0) := (others => '0');
	signal bs_Dout				: std_logic_vector( 7 downto 0) := (others => '0');
	signal bs_nCS				: std_logic := '1';
	signal bs_nWE				: std_logic := '1';
	signal bs_nOE				: std_logic := '1';

	signal bootstrap_done	: std_logic := '0';	-- low when FLASH is being copied to SRAM, can be used by user as active low reset
	signal reset				: std_logic := '0';
	signal clk_24M				: std_logic := '0';	-- main system clock

	--
	-- user signals
	--
	signal VideoR				: std_logic_vector(2 downto 0) := (others => '0');
	signal VideoG				: std_logic_vector(2 downto 0) := (others => '0');
	signal VideoB				: std_logic_vector(1 downto 0) := (others => '0');
	signal HSync				: std_logic := '0';
	signal VSync				: std_logic := '0';

	-- user control of SRAM, these signals connect to SRAM when boostrap_busy = '0'
	signal user_A				: std_logic_vector(17 downto 0) := (others => '0');
--	signal user_A				: std_logic_vector(18 downto 0) := (others => '0');
	signal user_Din			: std_logic_vector( 7 downto 0) := (others => '0');
	signal user_Dout			: std_logic_vector( 7 downto 0) := (others => '0');
	signal user_nCS			: std_logic := '1';
	signal user_nWE			: std_logic := '1';
	signal user_nOE			: std_logic := '1';

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
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- SRAM Bootstrap begins here
------------------------------------------------------------------------------
----------------------------------------------------------------------------

	-- SRAM muxer, allows access to physical SRAM by either bootstrap or user
-- SRAM_D	<= x"00" & bs_Dout	when bootstrap_done = '0' and bs_nWE = '0'	else (others => 'Z'); -- no need for user write
	SRAM_D	<=         bs_Dout	when bootstrap_done = '0' and bs_nWE = '0'	else (others => 'Z'); -- no need for user write
--	SRAM_A	<= bs_A					when bootstrap_done = '0'							else user_A;
	SRAM_A	<= '0' & bs_A					when bootstrap_done = '0'							else '0' & user_A;
	SRAM_nCS	<= bs_nCS				when bootstrap_done = '0'							else user_nCS;
	SRAM_nWE	<= bs_nWE				when bootstrap_done = '0'							else user_nWE;
	SRAM_nOE	<= bs_nOE				when bootstrap_done = '0'							else user_nOE;

--	SRAM_nBE	<= '0';						-- nUB and nLB tied together, SRAM always in 16 bit mode, grrr!
	user_Din	<= SRAM_D( 7 downto 0);	-- anyone can read SRAM_D without contention but his provides some logical separation

	-- clock DCM
	u_clocks : entity work.clocks
	port map (
		CLK_IN			=> CLK_IN,
		I_RESET			=> reset,
		O_CLK_24M		=> clk_24M
	);

	u_bs : entity work.bootstrap
	port map (
		I_CLK				=> clk_24M,
		I_RESET			=> reset,
		-- FLASH interface
		I_FLASH_SO		=> FLASH_SO,	-- to FLASH chip SPI output
		O_FLASH_CK		=> FLASH_CK,	-- to FLASH chip SPI clock
		O_FLASH_CS		=> FLASH_CS,	-- to FLASH chip select
		O_FLASH_SI		=> FLASH_SI,	-- to FLASH chip SPI input
		-- SRAM interface
		O_A				=> bs_A,
		O_DOUT			=> bs_Dout,
		O_nCS				=> bs_nCS,
		O_nWE				=> bs_nWE,
		O_nOE				=> bs_nOE,
		O_BS_DONE		=> bootstrap_done -- reset output to rest of machine
	);

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- USER portion begins here
------------------------------------------------------------------------------
------------------------------------------------------------------------------
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
		I_RESETn			=> bootstrap_done,

		-- ROM IF
		O_ROM_AB			=> user_A,
		I_ROM_DB			=> user_Din,
		O_ROM_CSn		=> user_nCS,
		O_ROM_OEn		=> user_nOE,
		O_ROM_WEn		=> user_nWE,

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
