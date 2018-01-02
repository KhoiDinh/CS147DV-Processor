// Name: full_adder.v
// Module: FULL_ADDER
//
// Output: S : Sum
//         CO : Carry Out
//
// Input: A : Bit 1
//        B : Bit 2
//        CI : Carry In
//
// Notes: 1-bit full adder implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module FULL_ADDER(S,CO,A,B, CI);
output S,CO;	// sum and carry out bit
input A,B, CI;	//inputs and carry in bit
wire halfAdder1, halfAdder2, halfAdderBoth; //connection for next operation

HALF_ADDER H1(.Y(halfAdderBoth), .C(halfAdder1), .A(A), .B(B));	//1st half adder
HALF_ADDER H2(.Y(S), .C(halfAdder2), .A(halfAdderBoth), .B(CI));	//2nd half adder
or or1(CO, halfAdder1, halfAdder2);	//combines 2 half adders together

endmodule 
