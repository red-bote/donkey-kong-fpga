# Donkey Kong FPGA arcade game

Implementation of Donkey Kong on the Papilio Plus board with Arcade MegaWing  
Original Verilog source code by Katsumi Degawa  
Translated to VHDL and adapted to the Papilio Board by Alex  
Exported from https://code.google.com/archive/p/donkeykong-papilioplus-fpga  

Quick start instructions:  

Place ROMs in the roms directory, see scripts/make_rom.bat for a list of files required and SHA1 checksums  
Run scripts/make_rom.bat to generate a binary file of the concatenated ROMs  
Run build/dkong_papilio.xise to start the ISE Webpack and generate the FPGA .bit file  
Run scripts/build_fpga_image.bat to merge the generate FPGA .bit file and the ROMs file  
Finally flash the scripts/fpga.bit file to the Papilio Plus board using a commmand line similar to:  
	papilio-prog.exe -b bscan_spi_lx9.bit -f scripts\fpga.bit  


5/20/2024 Glenn Neidermeier (Red~Bote):
Supports Papilio Duo with Classic Computing Shield. Open ISE project file
`dkong_pduocs.xise`, which has a new top VHDL file for the Duo and also a new
constraints file to reconfigure the external IOs. In particular, the Duo has
a slighly different SRAM. Otherwise, follow all the same instructions above.

```
Buttons:

RESET+UP    = INSERT COIN
RESET+LEFT  = 1 PLAYER GAME
RESET+RIGHT = 2 PLAYER GAME

RESET       = JUMP
UP          = UP
DOWN        = DOWN
LEFT        = LEFT
RIGHT       = RIGHT
```
