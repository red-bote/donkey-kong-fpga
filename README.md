# Donkey Kong FPGA arcade game

Implementation of Donkey Kong on the Papilio Plus board with Arcade MegaWing  
Original Verilog source code by Katsumi Degawa  
Translated to VHDL and adapted to the Papilio Board by Alex  
Exported from https://code.google.com/archive/p/donkeykong-papilioplus-fpga  

6/12/2024 Glenn Neidermeier (Red~Bote):

Basys 3 Artix-7 board supported on branch "Basys_3". Only Basys 3 supported on that 
branch, it modifies dkong_main.vhd to eliminate the bootstrap to SRAM step since the 
Basys 3 has adequate BRAM for program ROMs PROMs, and audio sample images.

Quick start instructions:  

Place ROMs in the roms directory, see `scripts/make_rom.sh` for a list of files required and SHA1 checksums  

Run `scripts/make_rom.sh` to generate the VHDL code for the ROMs, PROMs and sound samples.  

Open the Vivado project `proj/xilinx/basys3/dkong.xpr` and generate the FPGA .bit file 

Connect to the Basys 3 board in Vivado hardware manager and flash the bitstream in the usual way. 

Video output is 640x480 VGA.
Audio output is on a [PMOD Amp 2](https://digilent.com/reference/pmod/pmodamp2/start)

```
Controls:

btnC        = JUMP
btnU        = UP
btnD        = DOWN
btnL        = LEFT
btnR        = RIGHT

JUMP+UP    = INSERT COIN
JUMP+LEFT  = 1 PLAYER GAME
JUMP+RIGHT = 2 PLAYER GAME

```
