// Name: mult.v
// Module: MULT32 , MULT32_U
//
// Output: HI: 32 higher bits
//         LO: 32 lower bits
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//
// Notes: 32-bit multiplication
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module MULT32(HI, LO, A, B);

//input list
input [31:0] A, B;
//output list
output [31:0] HI, LO;

wire [31:0] multWires [3:0];
wire [63:0] USWire, TCOUT, muxResult;
wire XORGate;

//creation of mult32 via diagram
xor XORStart(XORGate, A[31], B[31]);

TWOSCOMP32 TC1(multWires[0], A);
MUX32_2x1 mux2x1_1(multWires[1], A, multWires[0], A[31]);

TWOSCOMP32 TC2(multWires[2], B);
MUX32_2x1 mux2x1_2(multWires[3], B, multWires[2], B[31]);

MULT32_U USMult(USWire[63:32],USWire[31:0], multWires[1], multWires[3]);
TWOSCOMP64 TC3(TCOUT, USWire);
MUX64_2x1 mux64_1(muxResult, USWire, TCOUT, XORGate);

BUF32X32 resultP1(LO,muxResult[31:0]);
BUF32X32 resultP2(HI, muxResult[63:32]);

endmodule

module MULT32_U(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A;
input [31:0] B;

wire [31:0] carryOut;
wire ands [31:0]; 
wire [31:0] remainder [31:0]; 

AND32_2x1 and1(remainder[0], A, {32{B[0]}});
buf buf1(carryOut[0], 1'b0);
buf buf2(LO[0], remainder[0][0]);

//does the unsigned multiplication process, as shown in diagram
genvar index;
generate
for(index = 1; index < 32; index = index + 1)
begin: USMult_Loop
	wire[31:0] OPWire;
	AND32_2x1 and32Iter(OPWire, A, {32{B[index]}});
	RC_ADD_SUB_32 RC32Iter(remainder[index], carryOut[index], OPWire, {carryOut[index-1], {remainder[index-1][31:1]}}, 1'b0);
	buf bufEnd(LO[index], remainder[index][0]); 
end
endgenerate

BUF32X32 connector(HI,{carryOut[31],{remainder[31][31:1]}});// does buf operation 32 times

endmodule
