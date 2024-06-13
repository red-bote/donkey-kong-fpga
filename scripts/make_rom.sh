#!/bin/bash
# 6/12/2024 Glenn Neidermeier (Red~Bote)
#  New generator for mapping images directly to VHDL on Basys 3 (no SRAM is used).


#@echo off
#rem
#rem Donkey Kong ROM builder
#rem
#rem SHA1 checksums of the ROMs required:
#rem f9c872da2fe8e800574ae3bf483fb3ccacc92eb3  c-2j.bpr
#rem b50ec9e1837c00c20fb2a4369ec7dd0358321127  c-2k.bpr
#rem 3fe3599f6fa7c496f782053ddf7bacb453d197c4  c_5at_g.bin
#rem c7966261f3a1d3296927e0b6ee1c58039fc53c1f  c_5bt_g.bin
#rem acb11a8fbdbb3ab46068385fe465f681e3c824bd  c_5ct_g.bin
#rem d76ebecfea1af098d843ee7e578e480cd658ac1a  c_5et_g.bin
#rem 793dba9bf5a5fe76328acdfb90815c243d2a65f1  l_4m_b.bin
#rem 92e5d379f4838ac1fa44d448ce7d142dae42102f  l_4n_b.bin
#rem ecf95db5a20098804fc8bd59232c66e2e0ed3db4  l_4r_b.bin
#rem 3bc482a38bf579033f50082748ee95205b0f673d  l_4s_b.bin
#rem 144d24464c1f9f01894eb12f846952290e6e32ef  s_3i_b.bin
#rem 6c82b57637c0212a580591397e6a5a1718f19fd2  s_3j_b.bin
#rem c2bdccbf2654b64ea55cd589fd21323a9178a660  v-5e.bpr
#rem 976eb1e18c74018193a35aa86cff482ebfc5cc4e  v_3pt.bin
#rem a57ff5a231c45252a63b354137c920a1379b70a3  v_5h_b.bin
#
#SET ROMS=..\roms
#echo ---------- build PROM data ---------- 
#copy /b %ROMS%\c_5et_g.bin + %ROMS%\c_5ct_g.bin + %ROMS%\c_5bt_g.bin + %ROMS%\c_5at_g.bin + %ROMS%\c_5at_g.bin + %ROMS%\c_5at_g.bin + %ROMS%\v_3pt.bin + %ROMS%\v_3pt.bin + %ROMS%\v_5h_b.bin + %ROMS%\v_5h_b.bin + %ROMS%\c_5at_g.bin + %ROMS%\c_5at_g.bin + %ROMS%\l_4m_b.bin + %ROMS%\l_4m_b.bin + %ROMS%\l_4n_b.bin + %ROMS%\l_4n_b.bin + %ROMS%\l_4r_b.bin + %ROMS%\l_4r_b.bin + %ROMS%\l_4s_b.bin + %ROMS%\l_4s_b.bin + %ROMS%\s_3i_b.bin + %ROMS%\s_3j_b.bin + %ROMS%\c-2k.bpr + %ROMS%\c-2j.bpr + %ROMS%\v-5e.bpr + 0xd00.bin + dk_wave.bin dkong_rom.bin
#
#rem ROM.vhd only used for simulation
#genrom.py dkong_rom.bin ..\build\ROM.vhd


ROMS=../roms
ROMGEN=../romgen_source
BUILD=../build

echo ---------- build PROM data ---------- 

# CPU (at 0000H in SRAM)
cat $ROMS/c_5et_g.bin $ROMS/c_5ct_g.bin $ROMS/c_5bt_g.bin $ROMS/c_5at_g.bin  > $BUILD/cpu_rom.bin
$ROMGEN/romgen $BUILD/cpu_rom.bin CPU_ROM 14 l r e > $BUILD/cpu_rom.vhd

# GFX2 (AxxxH, BxxxH, CxxxH, DxxxH of SRAM)
$ROMGEN/romgen $ROMS/l_4m_b.bin OBJ_ROM_1 11 l r e > $BUILD/obj_rom_1.vhd
$ROMGEN/romgen $ROMS/l_4n_b.bin OBJ_ROM_2 11 l r e > $BUILD/obj_rom_2.vhd
$ROMGEN/romgen $ROMS/l_4r_b.bin OBJ_ROM_3 11 l r e > $BUILD/obj_rom_3.vhd
$ROMGEN/romgen $ROMS/l_4s_b.bin OBJ_ROM_4 11 l r e > $BUILD/obj_rom_4.vhd

# GFX1 (6xxxH of SRAM)
$ROMGEN/romgen $ROMS/v_3pt.bin  VID_ROM_1 11 l r e > $BUILD/vid_rom_1.vhd
# GFX1 (7xxxH of SRAM)
$ROMGEN/romgen $ROMS/v_5h_b.bin VID_ROM_2 11 l r e > $BUILD/vid_rom_2.vhd

# sound PROMs (ExxxH of SRAM)
cat $ROMS/s_3i_b.bin $ROMS/s_3j_b.bin  > $BUILD/snd_prom.bin
$ROMGEN/romgen $BUILD/snd_prom.bin SND_PROM 12 l r e  > $BUILD/snd_prom.vhd

# palette PROMs (F0xxH, F1xxH of SRAM)
cat $ROMS/c-2k.bpr $ROMS/c-2j.bpr  > $BUILD/pal_prom.bin
$ROMGEN/romgen $BUILD/pal_prom.bin PAL_PROM 9 l r e   > $BUILD/pal_prom.vhd

# character PROMs (F2xxH of SRAM) Changed to combinatorial, tiles glitch if registered! 
$ROMGEN/romgen $ROMS/v-5e.bpr CHAR_PROM 8 c   > $BUILD/char_prom.vhd

# Extract [0x0000, 0x5000) from the sample blob. 
# foot sound  [0x0000, 0x1000) 
# jump sound  [0x1000, 0x3000)
# stomp sound [0x3000, 0x5000)
# data past 0x5000 does not appear to have been used.
dd if=dk_wave.bin of=$BUILD/dk_wav0.bin bs=1 count=4096 skip=0
$ROMGEN/romgen $BUILD/dk_wav0.bin WAV_SND_0 12 l r e > $BUILD/wav_snd_0.vhd
dd if=dk_wave.bin of=$BUILD/dk_wav1.bin bs=1 count=4096 skip=4096
$ROMGEN/romgen $BUILD/dk_wav1.bin WAV_SND_1 12 l r e > $BUILD/wav_snd_1.vhd
dd if=dk_wave.bin of=$BUILD/dk_wav2.bin bs=1 count=4096 skip=8192
$ROMGEN/romgen $BUILD/dk_wav2.bin WAV_SND_2 12 l r e > $BUILD/wav_snd_2.vhd
dd if=dk_wave.bin of=$BUILD/dk_wav3.bin bs=1 count=4096 skip=12288
$ROMGEN/romgen $BUILD/dk_wav3.bin WAV_SND_3 12 l r e > $BUILD/wav_snd_3.vhd
dd if=dk_wave.bin of=$BUILD/dk_wav4.bin bs=1 count=4096 skip=16384
$ROMGEN/romgen $BUILD/dk_wav4.bin WAV_SND_4 12 l r e > $BUILD/wav_snd_4.vhd

echo Finished, now build bitstream.


