// Name: logic.v
// Module: 
// Input: 
// Output: 
//
// Notes: Common definitions
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
// 64-bit two's complement
module TWOSCOMP64(Y,A);
//output list
output [63:0] Y;
//input list
input [63:0] A;
wire[63:0] notWire;
wire empty;
reg add = 0;
reg [63:0] Adding = 1;

genvar i;
generate
	for(i = 0; i < 64; i = i + 1)
	begin
		not not1(notWire[i], A[i]);
	end
endgenerate
RC_ADD_SUB_64 add_twos_1_64(Y, empty, notWire, Adding, add);
endmodule

// 32-bit two's complement
module TWOSCOMP32(Y,A);
//output list
output [31:0] Y;
//input list
input [31:0] A;
wire [31:0] notWire ;
wire empty;
reg addZero = 0;
reg [31:0] addOne = 1;

genvar i;
generate
	for(i = 0; i < 32; i = i + 1)
	begin
	not notIter(notWire[i], A[i]);
	end
endgenerate
RC_ADD_SUB_32 addEnd(Y, empty, notWire, addOne, addZero);
endmodule

// 32-bit registere +ve edge, Reset on RESET=0
module REG32(Q, D, LOAD, CLK, RESET);
output [31:0] Q;
input CLK, LOAD;
input [31:0] D;
input RESET;

genvar i;
generate
for(i =0; i<32; i=i+1)
	begin : reg32_loop
	wire Qbar; 
	REG1 reg1_iter(.Q(Q[i]), .Qbar(Qbar), .D(D[i]), .L(LOAD), .C(CLK), .nP(1'b1), .nR(RESET));
	//$write("REG1: %3d\n", init_reg1);
	end
endgenerate 
endmodule

// 1 bit register +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module REG1(Q, Qbar, D, L, C, nP, nR);
input D, C, L;
input nP, nR;
output Q,Qbar;
wire muxO;
MUX1_2x1 mux(muxO, Q, D, L);
D_FF dff(.Q(Q), .Qbar(Qbar), .D(muxO), .C(C), .nP(nP), .nR(nR));
endmodule

// 1 bit flipflop +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_FF(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q,Qbar;
wire Y, Ybar, notC;

not not1(notC, C);
D_LATCH d_init(.Q(Y), .Qbar(Ybar), .D(D), .C(notC), .nP(nP), .nR(nR));
SR_LATCH sr_init(.Q(Q), .Qbar(Qbar), .S(Y), .R(Ybar), .C(C), .nP(nP), .nR(nR));
endmodule

// 1 bit D latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_LATCH(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q,Qbar;

wire notDWire, and1Wire, and2Wire, and3Wire, and4Wire;

not not1(notDWire, D);
nand nand1(and1Wire, D, C);
nand nand2(and2Wire, notDWire, C);
nand nand3(Q, Qbar, and1Wire, nP); //nR
nand nand4(Qbar, Q, and2Wire, nR); // nP


endmodule

// 1 bit SR latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module SR_LATCH(Q,Qbar, S, R, C, nP, nR);
input S, R, C;
input nP, nR;
output Q,Qbar;
wire and1Wire, and2Wire;

nand nand1(and1Wire, S, C);
nand nand2(and2Wire, R, C);
nand nand3(Q, Qbar, and1Wire, nP);
nand nand4(Qbar, Q, and2Wire, nR);

endmodule


// 5x32 Line decoder
module DECODER_5x32(D,I);
// output
output [31:0] D;
// input
input [4:0] I;
wire [16:0] hold;

DECODER_4x16 decoder4x16(hold[15:0], I[3:0]);

not not1(hold[16], I[4]);

genvar i;
generate
	for(i = 0; i < 16; i=i+1)
	begin : decoder4x16_loop
	and and1(D[i], hold[i], hold[16]);
	and and2(D[i+16], hold[i], I[4]);
	end
endgenerate

endmodule  

// 4x16 Line decoder
module DECODER_4x16(D,I);
// output
output [15:0] D;
// input
input [3:0] I;
wire [8:0] hold;

DECODER_3x8 decoder3x8(hold[7:0], I[2:0]);

not not1(hold[8], I[3]);

genvar i;
generate
	for(i = 0; i < 8; i=i+1)
	begin : decoder3x8_loop
	and and1(D[i], hold[i], hold[8]);
	and and2(D[i+8], hold[i], I[3]);
	end
endgenerate



endmodule

// 3x8 Line decoder
module DECODER_3x8(D,I);
// output
output [7:0] D;
// input
input [2:0] I;
wire [4:0] hold;

DECODER_2x4 decoder2x4(hold[3:0], I[1:0]);

not not1(hold[4], I[2]);

genvar i;
generate
	for(i = 0; i < 4; i=i+1)
	begin : decoder2x4_loop
	and and1(D[i], hold[i], hold[4]);
	and and2(D[i+4], hold[i], I[2]);
	end
endgenerate
endmodule

// 2x4 Line decoder
module DECODER_2x4(D,I);
// output
output [3:0] D;
// input
input [1:0] I;
wire [1:0] hold;

not not1(hold[0], I[0]);
not not2(hold[1], I[1]);
and and1(D[0], hold[0], hold[1]);
and and2(D[1], hold[1], I[0]);
and and3(D[2], hold[0], I[1]);
and and4(D[3], I[0], I[1]);

endmodule 

