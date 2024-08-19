`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2024 09:20:34 PM
// Design Name: 
// Module Name: sound_mix_dkj
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   Analog sound and mixer routines from github.com/gaz68/Arcade-DonkeyKongJunior_MiSTer.git
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sound_mix_dkj(

    input W_CLK_24576M,
    input W_CLK_12288M,
    input W_RESETn,

    input [9:0] W_H_CNT,
    input [7:0] W_5H_Q,
    input [7:0] W_6H_Q,
    input [7:0] W_D_S_DAT,
    input [7:0] I8035_PBI,

    output [7:0] o_data_d,
    output [7:0] o_data_a
    );

reg	[15:0]WAVROM_ADDR;

wire    [7:0]w_wav_dat;

samples_rom #()
u_wav_rom( W_CLK_24576M, WAVROM_ADDR, w_wav_dat );

assign o_data_a = w_wav_dat;


//========   DIGTAL SOUND    =====================================================
// Background music and some of the sound effects

//wire    [7:0]W_D_S_DAT;
wire    [15:0]W_D_S_DATB;
wire    [15:0]W_D_S_DATC;

// DAC (Digital Sound) -----------------------------------------

dkongjr_dac dac08 
(
	.I_CLK(W_CLK_24576M),
	.I_DECAY_EN(~I8035_PBI[7]),
	.I_RESET_n(W_RESETn),
	.I_SND_DAT({2{~W_D_S_DAT[7],W_D_S_DAT[6:0]}}), // 16-bit signed input.
	.O_SND_DAT(W_D_S_DATB)
);

// Second order low pass filter. f= 1916 Hz, Q = 0.74.
iir_2nd_order filter
(
	.clk(W_CLK_24576M),
	.reset(~W_RESETn),
	.div(12'd512), // 24.576Mhz / 512 = 48KHz
	.A2(-18'sd26649),
	.A3(18'sd11453),
	.B1(18'sd215),
	.B2(18'sd430),
	.B3(18'sd215),
    .in(W_D_S_DATB),
	.out(W_D_S_DATC)
);

assign o_data_d = {~W_D_S_DATC[15], W_D_S_DATC[14:8]};


//========   ANALOGUE SOUND (SAMPLES)   =============================================
// Walking, climbing, jumping, landing and falling sounds.
// 16-bit, 11025Hz signed samples.

wire signed	[15:0]WAVROM_DS[0:3];
wire			[15:0]WAVROM_A[0:3];
wire			[3:0]I_ANLG_VOL = 4'b1; // idfk

reg	[2:0]multsample;

// Walking/climbing sounds (multi-samples).
dkongjr_wav_sound walk_climb_sounds
(
	.I_CLK(W_CLK_24576M),
	.I_RSTn(W_RESETn),
	.I_H_CNT(W_H_CNT[3:0]),
	.I_DIV(12'd2229), // 24.576Mhz / 2229 = 11,025Hz
	.I_VOL(I_ANLG_VOL),
	.I_DMA_TRIG(~W_6H_Q[0]),
	.I_DMA_STOP(1'b0),
	.I_DMA_CHAN(3'd0),
	.I_DMA_ADDR({2'b00, W_6H_Q[7] ? multsample : multsample+3, 11'h000}),
	.I_DMA_LEN(16'h0800),
	.I_DMA_DATA(WAVROM_D), // Sample data from wave ROM.
	.O_DMA_ADDR(WAVROM_A[0]), // Wave ROM address.
	.O_SND(WAVROM_DS[0])
);

// Jumping sound.
dkongjr_wav_sound jump_sound
(
	.I_CLK(W_CLK_24576M),
	.I_RSTn(W_RESETn),
	.I_H_CNT(W_H_CNT[3:0]),
	.I_DIV(12'd2229),
	.I_VOL(I_ANLG_VOL),
	.I_DMA_TRIG(~W_6H_Q[1]),
	.I_DMA_STOP(1'b0),
	.I_DMA_CHAN(3'd1),
	.I_DMA_ADDR(16'h3000),
	.I_DMA_LEN(16'h2000),
	.I_DMA_DATA(WAVROM_D),
	.O_DMA_ADDR(WAVROM_A[1]),
	.O_SND(WAVROM_DS[1])
);

// Landing sound.
dkongjr_wav_sound land_sound
(
	.I_CLK(W_CLK_24576M),
	.I_RSTn(W_RESETn),
	.I_H_CNT(W_H_CNT[3:0]),
	.I_DIV(12'd2229),
	.I_VOL(I_ANLG_VOL),
	.I_DMA_TRIG(~W_6H_Q[2]),
	.I_DMA_STOP(1'b0),
	.I_DMA_CHAN(3'd2),
	.I_DMA_ADDR(16'h5000),
	.I_DMA_LEN(16'h2000),
	.I_DMA_DATA(WAVROM_D),
	.O_DMA_ADDR(WAVROM_A[2]),
	.O_SND(WAVROM_DS[2])
);

// Falling sound.
dkongjr_wav_sound fall_sound
(
	.I_CLK(W_CLK_24576M),
	.I_RSTn(W_RESETn),
	.I_H_CNT(W_H_CNT[3:0]),
	.I_DIV(12'd2229),
	.I_VOL(I_ANLG_VOL),
	.I_DMA_TRIG(W_5H_Q[1]),
	.I_DMA_STOP(~W_5H_Q[1]),
	.I_DMA_CHAN(3'd3),
	.I_DMA_ADDR(16'h7000),
	.I_DMA_LEN(16'h5000),
	.I_DMA_DATA(WAVROM_D),
	.O_DMA_ADDR(WAVROM_A[3]),
	.O_SND(WAVROM_DS[3])
);


reg	[2:0]multsample_cnt;

reg	walk_trig_d;

always @(posedge W_CLK_12288M or negedge W_RESETn)
begin
	if(! W_RESETn)begin

		multsample_cnt	<= 0;
		multsample		<= 0;
		WAVROM_ADDR 	<= 0;

	end else begin
	
		// Walking/climbing multi-sample selection.
		walk_trig_d <= ~W_6H_Q[0];

		if(~walk_trig_d & ~W_6H_Q[0]) begin
			multsample_cnt <= multsample_cnt == 6 ? 1'b0 : multsample_cnt + 1'b1; 

			case(multsample_cnt)
				0: multsample <= 3'b001;
				1: multsample <= 3'b010;
				2: multsample <= 3'b001;
				3: multsample <= 3'b010;
				4: multsample <= 3'b000;
				5: multsample <= 3'b001;
				6: multsample <= 3'b000;
				default:multsample <= 3'b00;
			endcase
		end

		// Wave ROM address bus sharing for analogue sounds.
		case(W_H_CNT[3:0])
			0: WAVROM_ADDR <= WAVROM_A[0];
			2: WAVROM_ADDR <= WAVROM_A[1];
			4: WAVROM_ADDR <= WAVROM_A[2];
			6: WAVROM_ADDR <= WAVROM_A[3];
			default:;
		endcase
		
	 end	
end

endmodule
