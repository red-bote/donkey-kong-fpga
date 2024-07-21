//===============================================================================
// FPGA DONKEY KONG XILINX(SPARTAN2E and SPARTAN3) BOLCK RAM I/F
//
// Version : 2.00
//
// Copyright(c) 2004 - 2005 Katsumi Degawa , All rights reserved
//
// Important !
//
// This program is freeware for non-commercial use. 
// An author does no guarantee about this program.
// You can use this under your own risk.
//
// 2004- 5-24 The block RAM of XILINX (SPARTAN2E) was used. K.DEGAWA
// 2005- 2- 9 It had modification for Dkong V4.00.
//================================================================================

//------ RAM 1024 * 8bit -----------------------------------------
module  ram_1024_8_8(
//   A Port
I_CLKA,
I_ADDRA,
I_DA,
I_CEA,
I_WEA,
O_DA,
//   B Port
I_CLKB,
I_ADDRB,
I_DB,
I_CEB,
I_WEB,
O_DB

);

input  I_CLKA,I_CLKB;
input  [9:0]I_ADDRA,I_ADDRB;
input  [7:0]I_DA,I_DB;
input  I_CEA,I_CEB;
input  I_WEA,I_WEB;
output [7:0]O_DA,O_DB;

wire   [7:0]W_DOA,W_DOB;
assign O_DA = I_CEA ? W_DOA : 8'h00;
assign O_DB = I_CEB ? W_DOB : 8'h00;

reg    [7:0]R_RAM[1023:0];
reg    [9:0]R_ADDRA,R_ADDRB;

always@(posedge I_CLKA)
begin
  if(I_CEA)begin
    if(I_WEA) R_RAM[I_ADDRA] <= I_DA;
    R_ADDRA <= I_ADDRA;
  end 
end

always@(posedge I_CLKB)
begin
  if(I_CEB) 
    R_ADDRB <= I_ADDRB; 
end

assign W_DOA = R_RAM[R_ADDRA] ;
assign W_DOB = R_RAM[R_ADDRB] ;


endmodule

//------ RAM 1024 * 8bit -----------------------------------------
module  ram_1024_8(

I_CLK,
I_ADDR,
I_D,
I_CE,
I_WE,
O_D

);

input  I_CLK;
input  [9:0]I_ADDR;
input  [7:0]I_D;
input  I_CE;
input  I_WE;
output [7:0]O_D;

reg    [7:0]R_RAM[1023:0];
reg    [9:0]R_ADDR;

wire   [7:0]W_DO;
assign O_D = I_CE ? W_DO : 8'h00;

always@(posedge I_CLK)
begin
  if(I_CE)begin
    if(I_WE) R_RAM[I_ADDR] <= I_D;
    R_ADDR <= I_ADDR;
  end 
end
assign W_DO = R_RAM[R_ADDR] ;


endmodule

//   dkong_vram.v used
module  ram_2N(

I_CLK,
I_ADDR,
I_D,
I_CE,
I_WE,
O_D

);

input  I_CLK;
input  [7:0]I_ADDR;
input  [3:0]I_D;
input  I_CE;
input  I_WE;
output [3:0]O_D;

reg    [3:0]R_RAM[255:0];
reg    [7:0]R_ADDR;

always@(posedge I_CLK)
begin
  if(I_CE)begin
    if(I_WE) R_RAM[I_ADDR] <= I_D;
    R_ADDR <= I_ADDR;
  end 
end
assign O_D = R_RAM[R_ADDR] ;


endmodule

//   dkong_obj.v used
module  ram_2EH7M(

I_CLKA,
I_ADDRA,
I_DA,
I_CEA,
I_WEA,
O_DA,
//   B Port
I_CLKB,
I_ADDRB,
I_DB,
I_CEB,
I_WEB,
O_DB

);

input  I_CLKA,I_CLKB;
input  [7:0]I_ADDRA;
input  [5:0]I_ADDRB;
input  [5:0]I_DA;
input  [8:0]I_DB;
input  I_CEA,I_CEB;
input  I_WEA,I_WEB;
output [5:0]O_DA;
output [8:0]O_DB;

wire   [7:0]W_DOA;
assign O_DA = W_DOA[5:0];

wire   [15:0]W_DOB;
assign O_DB = W_DOB[8:0]; 

RAMB4_S8_S16 OBJ(
//	U_2EH
.CLKA(I_CLKA),
.ADDRA({1'b0,I_ADDRA}),
.DIA({2'b00,I_DA}),
.DOA(W_DOA),
.ENA(I_CEA),
.WEA(I_WEA),
.RSTA(1'b0),
//	U_7M
.CLKB(I_CLKB),
.ADDRB({2'b11,I_ADDRB}),
.DIB({7'b0000000,I_DB}),
.DOB(W_DOB),
.ENB(I_CEB),
.WEB(I_WEB),
.RSTB(1'b0)

);


endmodule

//   dkong_col_pal.v used
module  ram_2EF(
//   A Port
I_CLKA,
I_ADDRA,
I_DA,
I_CEA,
I_WEA,
O_DA,
//   B Port
I_CLKB,
I_ADDRB,
I_DB,
I_CEB,
I_WEB,
O_DB

);

input  I_CLKA,I_CLKB;
input  [7:0]I_ADDRA,I_ADDRB;
input  [7:0]I_DA,I_DB;
input  I_CEA,I_CEB;
input  I_WEA,I_WEB;
output [7:0]O_DA,O_DB;

RAMB4_S8_S8 COL(

.CLKA(I_CLKA),
.ADDRA({1'b0,I_ADDRA}),
.DIA(I_DA),
.DOA(O_DA),
.ENA(I_CEA),
.WEA(I_WEA),
.RSTA(1'b0),

.CLKB(I_CLKB),
.ADDRB({1'b1,I_ADDRB}),
.DIB(I_DB),
.DOB(O_DB),
.ENB(I_CEB),
.WEB(I_WEB),
.RSTB(1'b0)

);


endmodule

//  vga i/f
module  double_scan(
//   A Port
I_CLKA,
I_ADDRA,
I_DA,
I_CEA,
I_WEA,
O_DA,
//   B Port
I_CLKB,
I_ADDRB,
I_DB,
I_CEB,
I_WEB,
O_DB

);

input  I_CLKA,I_CLKB;
input  [8:0]I_ADDRA,I_ADDRB;
input  [7:0]I_DA,I_DB;
input  I_CEA,I_CEB;
input  I_WEA,I_WEB;
output [7:0]O_DA,O_DB;

reg    [7:0]R_RAM[511:0];
reg    [8:0]R_ADDR;

always@(posedge I_CLKA)  R_RAM[I_ADDRA] <= I_DA;
always@(posedge I_CLKB)  R_ADDR <= I_ADDRB;

assign O_DB = R_RAM[R_ADDR];


endmodule

//  i8035_ip
module  ram_64_8(

I_CLK,
I_ADDR,
I_D,
I_CE,
I_WE,
O_D

);

input  I_CLK;
input  [5:0]I_ADDR;
input  [7:0]I_D;
input  I_CE;
input  I_WE;
output [7:0]O_D;

reg    [7:0]R_RAM[63:0];
reg    [7:0]OUT_BUF;

always@(posedge I_CLK)
begin
  if(I_CE)begin
    if(I_WE)R_RAM[I_ADDR] <= I_D;
    OUT_BUF <= R_RAM[I_ADDR];
  end
end
assign O_D = OUT_BUF;


endmodule

//  sound
module  ram_2048_8(

I_CLK,
I_ADDR,
I_D,
I_CE,
I_WE,
O_D

);

input  I_CLK;
input  [10:0]I_ADDR;
input  [7:0]I_D;
input  I_CE;
input  I_WE;
output [7:0]O_D;

reg    [7:0]R_RAM[2047:0];
reg    [10:0]R_ADDR;

always@(posedge I_CLK)
begin
  if(I_CE)begin
    if(I_WE) R_RAM[I_ADDR] <= I_D;
    R_ADDR <= I_ADDR;
  end 
end

assign O_D = R_RAM[R_ADDR] ;


endmodule
