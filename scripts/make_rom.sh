#!/bin/bash
# 6/12/2024 Glenn Neidermeier (Red~Bote)
#  New generator for mapping images directly to VHDL on Basys 3 (no SRAM is used).

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

ROMS=../roms/dkong
ROMGEN=../romgen_source
BUILD=../build/dkong
[ ! -d $BUILD ] && mkdir $BUILD

echo ---------- build PROM data ---------- 

# CPU (at 0000H in SRAM)

dd bs=1 count=2048 skip=0    if=$ROMS/c_5et_g.bin  of=$BUILD/cpu_rom_0000.bin
$ROMGEN/romgen $BUILD/cpu_rom_0000.bin CPU_ROM_0000 11 l r e > $BUILD/cpu_rom_0000.vhd
dd bs=1 count=2048 skip=2048 if=$ROMS/c_5et_g.bin  of=$BUILD/cpu_rom_0800.bin
$ROMGEN/romgen $BUILD/cpu_rom_0800.bin CPU_ROM_0800 11 l r e > $BUILD/cpu_rom_0800.vhd

dd bs=1 count=2048 skip=0    if=$ROMS/c_5ct_g.bin  of=$BUILD/cpu_rom_1000.bin
$ROMGEN/romgen $BUILD/cpu_rom_1000.bin CPU_ROM_1000 11 l r e > $BUILD/cpu_rom_1000.vhd
dd bs=1 count=2048 skip=2048 if=$ROMS/c_5ct_g.bin  of=$BUILD/cpu_rom_1800.bin
$ROMGEN/romgen $BUILD/cpu_rom_1800.bin CPU_ROM_1800 11 l r e > $BUILD/cpu_rom_1800.vhd

dd bs=1 count=2048 skip=0    if=$ROMS/c_5bt_g.bin of=$BUILD/cpu_rom_2000.bin
$ROMGEN/romgen $BUILD/cpu_rom_2000.bin CPU_ROM_2000 11 l r e > $BUILD/cpu_rom_2000.vhd
dd bs=1 count=2048 skip=2048 if=$ROMS/c_5bt_g.bin of=$BUILD/cpu_rom_2800.bin
$ROMGEN/romgen $BUILD/cpu_rom_2800.bin CPU_ROM_2800 11 l r e > $BUILD/cpu_rom_2800.vhd

dd bs=1 count=2048 skip=0    if=$ROMS/c_5at_g.bin of=$BUILD/cpu_rom_3000.bin
$ROMGEN/romgen $BUILD/cpu_rom_3000.bin CPU_ROM_3000 11 l r e > $BUILD/cpu_rom_3000.vhd
dd bs=1 count=2048 skip=2048 if=$ROMS/c_5at_g.bin of=$BUILD/cpu_rom_3800.bin
$ROMGEN/romgen $BUILD/cpu_rom_3800.bin CPU_ROM_3800 11 l r e > $BUILD/cpu_rom_3800.vhd

#4000-5FFF not poulated on DK, generate dummy ROM files so DK and DKjr have same CPU address space.
dd bs=1 count=2048 skip=0    if=/dev/zero         of=$BUILD/cpu_rom_4000.bin
$ROMGEN/romgen $BUILD/cpu_rom_4000.bin CPU_ROM_4000 11 l r e > $BUILD/cpu_rom_4000.vhd
dd bs=1 count=2048 skip=2048 if=/dev/zero         of=$BUILD/cpu_rom_4800.bin
$ROMGEN/romgen $BUILD/cpu_rom_4800.bin CPU_ROM_4800 11 l r e > $BUILD/cpu_rom_4800.vhd

dd bs=1 count=2048 skip=0    if=/dev/zero         of=$BUILD/cpu_rom_5000.bin
$ROMGEN/romgen $BUILD/cpu_rom_5000.bin CPU_ROM_5000 11 l r e > $BUILD/cpu_rom_5000.vhd
dd bs=1 count=2048 skip=2048 if=/dev/zero         of=$BUILD/cpu_rom_5800.bin
$ROMGEN/romgen $BUILD/cpu_rom_5800.bin CPU_ROM_5800 11 l r e > $BUILD/cpu_rom_5800.vhd


# GFX2 (AxxxH, BxxxH, CxxxH, DxxxH of SRAM)
$ROMGEN/romgen $ROMS/l_4m_b.bin OBJ_ROM_1 11 l r e > $BUILD/obj_rom_1.vhd
$ROMGEN/romgen $ROMS/l_4n_b.bin OBJ_ROM_2 11 l r e > $BUILD/obj_rom_2.vhd
$ROMGEN/romgen $ROMS/l_4r_b.bin OBJ_ROM_3 11 l r e > $BUILD/obj_rom_3.vhd
$ROMGEN/romgen $ROMS/l_4s_b.bin OBJ_ROM_4 11 l r e > $BUILD/obj_rom_4.vhd

# Gfx ROMs sized 2048 for DK, 4096 for DKjr
# GFX1 (6xxxH of SRAM)
$ROMGEN/romgen $ROMS/v_3pt.bin  VID_ROM_1 12 l r e > $BUILD/vid_rom_1.vhd
# GFX1 (7xxxH of SRAM)
$ROMGEN/romgen $ROMS/v_5h_b.bin VID_ROM_2 12 l r e > $BUILD/vid_rom_2.vhd

# sound PROMs (ExxxH of SRAM)
$ROMGEN/romgen $ROMS/s_3i_b.bin  SND_PROG_ROM 11 l r e  > $BUILD/snd_data_rom.vhd
$ROMGEN/romgen $ROMS/s_3j_b.bin  SND_DATA_ROM 11 l r e  > $BUILD/snd_prog_rom.vhd

# palette PROMs (F0xxH, F1xxH of SRAM)
$ROMGEN/romgen $ROMS/c-2k.bpr PAL_PROM_2E 8 c   > $BUILD/pal_prom_2E.vhd
$ROMGEN/romgen $ROMS/c-2j.bpr PAL_PROM_2F 8 c   > $BUILD/pal_prom_2F.vhd

# character PROMs (F2xxH of SRAM) Changed to combinatorial, tiles glitch if registered! 
$ROMGEN/romgen $ROMS/v-5e.bpr CHAR_PROM 8 c   > $BUILD/char_prom.vhd

# Break the sample blob into smaller chunks of BRAM
WAV_FILE=dk_wave_new.raw
dd if=$WAV_FILE of=$BUILD/dk_wav0.bin bs=1 count=8192 skip=0
$ROMGEN/romgen $BUILD/dk_wav0.bin WAV_SND_0 13 l r e > $BUILD/wav_snd_0.vhd
dd if=$WAV_FILE of=$BUILD/dk_wav1.bin bs=1 count=8192 skip=8192
$ROMGEN/romgen $BUILD/dk_wav1.bin WAV_SND_1 13 l r e > $BUILD/wav_snd_1.vhd
dd if=$WAV_FILE of=$BUILD/dk_wav2.bin bs=1 count=8192 skip=16384
$ROMGEN/romgen $BUILD/dk_wav2.bin WAV_SND_2 13 l r e > $BUILD/wav_snd_2.vhd

echo Finished, now build bitstream.


