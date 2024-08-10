#!/bin/bash
# 6/23/2024 Glenn Neidermeier (Red~Bote)
#  New generator for Donkey Kong Junior
#  Maps images directly to VHDL on Basys 3 (no SRAM is used).

# Donkey Kong JR ROM builder
#
# SHA1 checksums of the ROMs required:
# b2c9f22facc8885be2d953b056eb8dcddd4f34cb  c-2e.bpr
# dbec3f4b8013628c5b8f83162e5f8b1f82f6ee5f  c-2f.bpr
# f708c3fd374da65cbd9fe2e191152f5d865414a0  c_3h.bin
# 64887564b079d98e98aafa53835e398f34fe4e3f  dkj.3n
# 41a7a4005087951f57f62c9751d62a8c495e6bb3  dkj.3p
# 08baf84ae6f9b40a2c743fe1d8c158c74a40e95a  dkj.5b
# ce1cfde71a9e2a8b5896a6301d386f72869a1d2e  dkj.5c
# 57ac237d273496b44220b4437118115ef11dbd9f  dkj.5e
# 2697a991a4afdf079dd0b7e732f71c7618f43b70  v-2n.bpr
# 07a6242e95b5c3b8dfdcd4b4950f463dba16dd77  v_7c.bin
# 0654b77526c49f0dfa077ac4f1f69cf5cb2e2f64  v_7d.bin
# 696854bf3dc5447d33b4815db357e6ce3834d867  v_7e.bin
# 0b688ae9da296b2447fffa5e135fd6a56ec3e790  v_7f.bin

# From https://www.brasington.org/arcade/tech/dkj/
# DKjr uses a goofy memory map in terms of what Z80 memory locations are mapped into the three 2764
# eproms (5B, 5C and 5E). One would normally think that each chip would contain a contiguous memory
# address space, but for DKjr each of the 8K byte eproms are divided up into four 2K blocks.
#
# 5B: 0x0000 - 0x07ff   5C: 0x2000 - 0x27ff   5E: 0x4000 - 0x47ff
#     0x0800 - 0x0fff       0x4800 - 0x4fff       0x2800 - 0x2fff
#     0x3000 - 0x37ff       0x1000 - 0x17ff       0x5000 - 0x57ff
#     0x3800 - 0x3fff       0x5800 - 0x5fff       0x1800 - 0x1fff

# MAME loads the ROMs piecewise into a contiguous memory address space:
#        ROM_REGION( 0x10000, REGION_CPU1 )      /* 64k for code */
#        ROM_LOAD( "dkj.5b",       0x0000, 0x1000, 0xdea28158 )
#        ROM_CONTINUE(             0x3000, 0x1000 )
#
#        ROM_LOAD( "dkj.5c",       0x2000, 0x0800, 0x6fb5faf6 )
#        ROM_CONTINUE(             0x4800, 0x0800 )
#        ROM_CONTINUE(             0x1000, 0x0800 )
#        ROM_CONTINUE(             0x5800, 0x0800 )
#
#        ROM_LOAD( "dkj.5e",       0x4000, 0x0800, 0xd042b6a8 )
#        ROM_CONTINUE(             0x2800, 0x0800 )
#        ROM_CONTINUE(             0x5000, 0x0800 )
#        ROM_CONTINUE(             0x1800, 0x0800 )

ROMS=../roms/dkongjr
ROMGEN=../romgen_source
BUILD=../build/dkongjr
[ ! -d $BUILD ] && mkdir $BUILD

echo ---------- build PROM data ---------- 

# CPU (at 0000H in SRAM)
dd bs=1 count=2048 skip=0     if=$ROMS/dkj.5b  of=$BUILD/cpu_rom_0000.bin           # 5B_0000
$ROMGEN/romgen $BUILD/cpu_rom_0000.bin CPU_ROM_0000 11 l r e > $BUILD/cpu_rom_0000.vhd
dd bs=1 count=2048 skip=2048  if=$ROMS/dkj.5b  of=$BUILD/cpu_rom_0800.bin           # 5B_0800
$ROMGEN/romgen $BUILD/cpu_rom_0800.bin CPU_ROM_0800 11 l r e > $BUILD/cpu_rom_0800.vhd

dd bs=1 count=2048 skip=4096  if=$ROMS/dkj.5c  of=$BUILD/cpu_rom_1000.bin           # 5C_1000
$ROMGEN/romgen $BUILD/cpu_rom_1000.bin CPU_ROM_1000 11 l r e > $BUILD/cpu_rom_1000.vhd
dd bs=1 count=2048 skip=6144  if=$ROMS/dkj.5e  of=$BUILD/cpu_rom_1800.bin           # 5E_1800
$ROMGEN/romgen $BUILD/cpu_rom_1800.bin CPU_ROM_1800 11 l r e > $BUILD/cpu_rom_1800.vhd

dd bs=1 count=2048 skip=0     if=$ROMS/dkj.5c  of=$BUILD/cpu_rom_2000.bin           # 5C_0000
$ROMGEN/romgen $BUILD/cpu_rom_2000.bin CPU_ROM_2000 11 l r e > $BUILD/cpu_rom_2000.vhd
dd bs=1 count=2048 skip=2048  if=$ROMS/dkj.5e  of=$BUILD/cpu_rom_2800.bin           # 5E_0800
$ROMGEN/romgen $BUILD/cpu_rom_2800.bin CPU_ROM_2800 11 l r e > $BUILD/cpu_rom_2800.vhd

dd bs=1 count=2048 skip=4096  if=$ROMS/dkj.5b  of=$BUILD/cpu_rom_3000.bin           # 5B_1000
$ROMGEN/romgen $BUILD/cpu_rom_3000.bin CPU_ROM_3000 11 l r e > $BUILD/cpu_rom_3000.vhd
dd bs=1 count=2048 skip=6144  if=$ROMS/dkj.5b  of=$BUILD/cpu_rom_3800.bin           # 5B_1800
$ROMGEN/romgen $BUILD/cpu_rom_3800.bin CPU_ROM_3800 11 l r e > $BUILD/cpu_rom_3800.vhd

#4000-5FFF not poulated on DK
dd bs=1 count=2048 skip=0     if=$ROMS/dkj.5e  of=$BUILD/cpu_rom_4000.bin           # 5E_0000
$ROMGEN/romgen $BUILD/cpu_rom_4000.bin CPU_ROM_4000 11 l r e > $BUILD/cpu_rom_4000.vhd
dd bs=1 count=2048 skip=2048  if=$ROMS/dkj.5c  of=$BUILD/cpu_rom_4800.bin           # 5C_0800
$ROMGEN/romgen $BUILD/cpu_rom_4800.bin CPU_ROM_4800 11 l r e > $BUILD/cpu_rom_4800.vhd

dd bs=1 count=2048 skip=4096  if=$ROMS/dkj.5e  of=$BUILD/cpu_rom_5000.bin           # 5E_1000
$ROMGEN/romgen $BUILD/cpu_rom_5000.bin CPU_ROM_5000 11 l r e > $BUILD/cpu_rom_5000.vhd
dd bs=1 count=2048 skip=6144  if=$ROMS/dkj.5c  of=$BUILD/cpu_rom_5800.bin           # 5C_1800
$ROMGEN/romgen $BUILD/cpu_rom_5800.bin CPU_ROM_5800 11 l r e > $BUILD/cpu_rom_5800.vhd


# GFX2 (AxxxH, BxxxH, CxxxH, DxxxH of SRAM)
$ROMGEN/romgen $ROMS/v_7c.bin OBJ_ROM_1 11 l r e > $BUILD/obj_rom_1.vhd
$ROMGEN/romgen $ROMS/v_7d.bin OBJ_ROM_2 11 l r e > $BUILD/obj_rom_2.vhd
$ROMGEN/romgen $ROMS/v_7e.bin OBJ_ROM_3 11 l r e > $BUILD/obj_rom_3.vhd
$ROMGEN/romgen $ROMS/v_7f.bin OBJ_ROM_4 11 l r e > $BUILD/obj_rom_4.vhd


#	ROM_REGION( 0x2000, REGION_GFX1, ROMREGION_DISPOSE )
#	ROM_LOAD( "dkj.3n",       0x0000, 0x1000, CRC(8d51aca9) SHA1(64887564b079d98e98aafa53835e398f34fe4e3f) )
#	ROM_LOAD( "dkj.3p",       0x1000, 0x1000, CRC(4ef64ba5) SHA1(41a7a4005087951f57f62c9751d62a8c495e6bb3) )

# GFX1 (6xxxH of SRAM)
$ROMGEN/romgen $ROMS/dkj.3p  VID_ROM_1 12 l r e > $BUILD/vid_rom_1.vhd
# GFX1 (7xxxH of SRAM)
$ROMGEN/romgen $ROMS/dkj.3n  VID_ROM_2 12 l r e > $BUILD/vid_rom_2.vhd


# sound PROMs (ExxxH of SRAM)
$ROMGEN/romgen $ROMS/c_3h.bin SND_PROM 12 l r e  > $BUILD/snd_prom.vhd

# palette PROMs (F0xxH, F1xxH of SRAM)
$ROMGEN/romgen $ROMS/c-2e.bpr PAL_PROM_2E 8 c   > $BUILD/pal_prom_2E.vhd
$ROMGEN/romgen $ROMS/c-2f.bpr PAL_PROM_2F 8 c   > $BUILD/pal_prom_2F.vhd


# character PROMs (F2xxH of SRAM) Changed to combinatorial, tiles glitch if registered! 
$ROMGEN/romgen $ROMS/v-2n.bpr CHAR_PROM 8 c   > $BUILD/char_prom.vhd

# Break the sample blob into smaller chunks of BRAM. 
WAV_BIN=dkj_wave_8bps.raw
WAV_BIN=dk_wave.bin
dd if=$WAV_BIN of=$BUILD/dk_wav0.bin bs=1 count=8192 skip=0
$ROMGEN/romgen $BUILD/dk_wav0.bin WAV_SND_0 13 l r e > $BUILD/wav_snd_0.vhd
dd if=$WAV_BIN of=$BUILD/dk_wav1.bin bs=1 count=8192 skip=8192
$ROMGEN/romgen $BUILD/dk_wav1.bin WAV_SND_1 13 l r e > $BUILD/wav_snd_1.vhd
dd if=$WAV_BIN of=$BUILD/dk_wav2.bin bs=1 count=8192 skip=16384
$ROMGEN/romgen $BUILD/dk_wav2.bin WAV_SND_2 13 l r e > $BUILD/wav_snd_2.vhd
dd if=$WAV_BIN of=$BUILD/dk_wav3.bin bs=1 count=8192 skip=24576
$ROMGEN/romgen $BUILD/dk_wav3.bin WAV_SND_3 13 l r e > $BUILD/wav_snd_3.vhd
dd if=$WAV_BIN of=$BUILD/dk_wav4.bin bs=1 count=8192 skip=32768
$ROMGEN/romgen $BUILD/dk_wav4.bin WAV_SND_4 13 l r e > $BUILD/wav_snd_4.vhd
dd if=$WAV_BIN of=$BUILD/dk_wav5.bin bs=1 count=8192 skip=40960
$ROMGEN/romgen $BUILD/dk_wav5.bin WAV_SND_5 13 l r e > $BUILD/wav_snd_5.vhd

echo Finished, now build bitstream.


