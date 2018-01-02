// Name: rc_add_sub_32.v
// Module: RC_ADD_SUB_32
//
// Output: Y : Output 32-bit
//         CO : Carry Out
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//        SnA : if SnA=0 it is add, subtraction otherwise
//
// Notes: 32-bit adder / subtractor implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"


module RC_ADD_SUB_64(Y, CO, A, B, SnA);
// output list
output [63:0] Y;
output CO;
// input list
input [63:0] A;
input [63:0] B;
input SnA;
wire[63:0] FAWConnector, product;//FAW= full adder wire

genvar index;
generate
for(index = 0; index < 64; index = index + 1)	//adds certain bits in 2 64 bits numbers together
begin : rippleCarry_64
	xor start(product[index], SnA, B[index]);
	if(index == 0)
	begin
           	FULL_ADDER two(.S(Y[index]), .CO(FAWConnector[index]), .A(A[index]), .B(product[index]), .CI(SnA));
        end
        else if(index == 63)
        begin
                FULL_ADDER three(.S(Y[index]), .CO(CO), .A(A[index]), .B(product[index]), .CI(FAWConnector[index-1]));
        end
	else if(index != 0 && index != 63)
	begin
           	FULL_ADDER one(.S(Y[index]), .CO(FAWConnector[index]), .A(A[index]), .B(product[index]), .CI(FAWConnector[index-1]));
	end 
end
endgenerate
endmodule



module RC_ADD_SUB_32(Y, CO, A, B, SnA);
// output list
output [`DATA_INDEX_LIMIT:0] Y;
output CO;
// input list
input [`DATA_INDEX_LIMIT:0] A; 
input [`DATA_INDEX_LIMIT:0] B;
input SnA;

wire[31:0] FAWConnector, product;


genvar index;
generate
for(index = 0; index < 32; index = index + 1)	//adds certain bits of 2 32 bit numbers together
begin : rippleCarry_32
	   xor start(product[index], SnA, B[index]);
           if(index == 0)
	   begin
           	FULL_ADDER two(.S(Y[index]), .CO(FAWConnector[index]), .A(A[index]), .B(product[index]), .CI(SnA));
           end
           else if(index == 31)
           begin
                FULL_ADDER three(.S(Y[index]), .CO(CO), .A(A[index]), .B(product[index]), .CI(FAWConnector[index-1]));
           end
	   else if(index != 0 && index != 31)
	   begin
           	FULL_ADDER one(.S(Y[index]), .CO(FAWConnector[index]), .A(A[index]), .B(product[index]), .CI(FAWConnector[index-1]));
	    end 
end
endgenerate 
endmodule

