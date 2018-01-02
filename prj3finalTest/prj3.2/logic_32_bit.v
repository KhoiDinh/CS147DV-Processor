// Name: logic_32_bit.v
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

// 32-bit NOR
module NOR32_2x1(Y,A,B);
//output 
output [31:0] Y;
//input
input [31:0] A;
input [31:0] B;

genvar index;
generate
for(index = 0; index < 32; index = index + 1)
begin: nor32_Loop
		nor norIter(Y[index], A[index], B[index]);
end
endgenerate
endmodule

// 32-bit AND
module AND32_2x1(Y,A,B);
//output 
output [31:0] Y;
//input
input [31:0] A;
input [31:0] B;

genvar index;
generate
for(index = 0; index < 32; index = index + 1)
begin: and32_Loop
	and andIter(Y[index], A[index], B[index]);
end
endgenerate
endmodule

// 32-bit inverter
module INV32_1x1(Y,A);
//output 
output [31:0] Y;
//input
input [31:0] A;

genvar index;
generate
	for(index = 0; index < 32; index = index + 1)
	begin: not32_Loop
		not notIter(Y[index], A[index]);
	end
endgenerate
endmodule

// 32-bit OR
module OR32_2x1(Y,A,B);
//output 
output [31:0] Y;
//input
input [31:0] A;
input [31:0] B;
wire [31:0] norWire;

NOR32_2x1 nor1(norWire, A, B);
INV32_1x1 inv1(Y, norWire);

endmodule

module BUF32X32(Y, S);
output [31:0] Y;
input [31:0] S;
genvar index;
generate
for(index = 0; index < 32; index = index + 1)
begin: buf32x32_Loop
	buf bufIter(Y[index], S[index]);
end
endgenerate

endmodule 