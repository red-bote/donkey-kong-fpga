# Donkey Kong FPGA arcade game

Implementation of Donkey Kong on the Papilio Plus board with Arcade MegaWing  
Original Verilog source code by Katsumi Degawa  
Translated to VHDL and adapted to the Papilio Board by Alex  
Exported from https://code.google.com/archive/p/donkeykong-papilioplus-fpga  

6/12/2024 Glenn Neidermeier (Red~Bote):

Basys 3 Artix-7 board supported on branch "Basys_3". Only Basys 3 supported on that 
branch, it modifies dkong_main.vhd to eliminate the [bootstrap to SRAM](http://papilio.cc/index.php?n=Playground.Bootstrap) step since the 
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

I built an adapter for a (compatible classic game controller)[https://www.amazon.com/dp/B07J1PT5JQ?psc=1&ref=ppx_yo2ov_dt_b_product_details] on a spare PMOD port. It's basically a plug for the 9-pin d-sub game controller connector with pullup resistors on the 5 input ports. The following list are suggested parts:

* [9 Position D-Sub Plug, Male](https://www.digikey.com/en/products/detail/amphenol-cs-fci/DE09P064TXLF/1001838)
* [Connector Header Through Hole, Right Angle 16 position 0.100" (2.54mm)](https://www.digikey.com/en/products/detail/adam-tech/PH2RA-16-UA/9830680)
* [Chip Quik Breadboard 0.1" hole grid 15 rows, 6 columns](https://www.digikey.com/en/products/detail/chip-quik-inc/SBBTH1506-1/5978222)
* Hookup wire and appropriately sized resistors for weak pullups on the input pins (10k, 33k etc.) 

