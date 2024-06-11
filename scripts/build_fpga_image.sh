#!/bin/bash

#python bitmerge.py ../build/dkong_papilio.bit dkong_rom.bin fpga.bit
python bitmerge.py ../build/dkong_pduo.bit dkong_rom.bin fpga.bit

echo done
echo "run \"papilio-prog  -b /media/sf_umlaut/wuzupcrud/hdl/Papilio-Loader/papilio-prog/bscan_spi_lx9.bit -f fpga.bit\""
