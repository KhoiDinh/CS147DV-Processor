// Name: barrel_shifter.v
// Module: SHIFT32_L , SHIFT32_R, SHIFT32
//
// Notes: 32-bit barrel shifter
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

// 32-bit shift amount shifter
module SHIFT32(Y,D,S, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [31:0] S;
input LnR;

wire[31:0] orWire;
wire[31:0] shiftWire;
wire orR;//change
reg [31:0] tempWire = 0;

BARREL_SHIFTER32 Barrel_shf1(.Y(shiftWire),.D(D),.S(S[4:0]), .LnR(LnR));

OR32X1_shifter inst_or1(.Y(orR), .S({5'b0,{S[31:5]}}));//need to put S with 4:0 replacsed?

MUX32_2x1 mux1_shift1(.Y(Y), .I0(shiftWire), .I1(tempWire), .S(orR));



endmodule

// Shift with control L or R shift
module BARREL_SHIFTER32(Y,D,S, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;
input LnR;
wire[31:0] shift1, shift2;
wire orR;//change

SHIFT32_R right(.Y(shift1), .D(D), .S(S));
SHIFT32_L left(.Y(shift2), .D(D), .S(S));

MUX32_2x1 muxShift(.Y(Y), .I0(shift1), .I1(shift2), .S(LnR));

endmodule

// Right shifter
module SHIFT32_R(Y,D,S);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;
wire [31:0] wire1, wire2,wire4,wire8;

//right shift via diagram
genvar index;
generate
for(index =31; index>=0; index = index-1)
begin
	if(index>31-1)
	begin
		MUX1_2x1 mux1P1(.Y(wire1[index]),.I0(D[index]), .I1(1'b0), .S(S[0]));
	end
	else 
	begin
		MUX1_2x1 mux1P2(.Y(wire1[index]),.I0(D[index]), .I1(D[index+1]), .S(S[0]));
	end 

	if(index>31-2)
	begin
		MUX1_2x1 mux2P1(.Y(wire2[index]),.I0(wire1[index]), .I1(1'b0), .S(S[1]));
	end
	else
	begin
		MUX1_2x1 mux2P2(.Y(wire2[index]),.I0(wire1[index]), .I1(wire1[index+2]), .S(S[1]));
	end

	if(index>31-4)
	begin
		MUX1_2x1 mux3P1(.Y(wire4[index]),.I0(wire2[index]), .I1(1'b0), .S(S[2]));
	end
	else 
	begin
		MUX1_2x1 mux3P2(.Y(wire4[index]),.I0(wire2[index]), .I1(wire2[index+4]), .S(S[2]));
	end

	if(index>31-8)
	begin
		MUX1_2x1 mux4P1(.Y(wire8[index]),.I0(wire4[index]), .I1(1'b0), .S(S[3]));
	end
	else 
	begin
		MUX1_2x1 mux4P2(.Y(wire8[index]),.I0(wire4[index]), .I1(wire4[index+8]), .S(S[3]));
	end

	if(index>31-16)
	begin
		MUX1_2x1 mux5P1(.Y(Y[index]),.I0(wire8[index]), .I1(1'b0), .S(S[4]));
	end
	else
	begin
		MUX1_2x1 mux5P2(.Y(Y[index]),.I0(wire8[index]), .I1(wire8[index+16]), .S(S[4]));	
	end
end
endgenerate
	
endmodule

// Left shifter
module SHIFT32_L(Y,D,S);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;
wire [31:0] wire1, wire2,wire4,wire8;

//left shift via diagram
genvar index;
generate
for(index =0; index<32; index = index+1)
begin
	if(index<1)
	begin
		MUX1_2x1 mux1P1(.Y(wire1[index]),.I0(D[index]), .I1(1'b0), .S(S[0]));
	end
	else 
	begin
		MUX1_2x1 mux1P2(.Y(wire1[index]),.I0(D[index]), .I1(D[index-1]), .S(S[0]));
	end 

	if(index<2)
	begin
		MUX1_2x1 mux2P1(.Y(wire2[index]),.I0(wire1[index]), .I1(1'b0), .S(S[1]));
	end
	else 
	begin
		MUX1_2x1 mux2P2(.Y(wire2[index]),.I0(wire1[index]), .I1(wire1[index-2]), .S(S[1]));
	end

	if(index<4)
	begin
		MUX1_2x1 mux3P1(.Y(wire4[index]),.I0(wire2[index]), .I1(1'b0), .S(S[2]));
	end
	else 
	begin
		MUX1_2x1 mux3P2(.Y(wire4[index]),.I0(wire2[index]), .I1(wire2[index-4]), .S(S[2]));
	end

	if(index<8)
	begin
		MUX1_2x1 mux4P1(.Y(wire8[index]),.I0(wire4[index]), .I1(1'b0), .S(S[3]));
	end
	else 
	begin
		MUX1_2x1 mux4P2(.Y(wire8[index]),.I0(wire4[index]), .I1(wire4[index-8]), .S(S[3]));
	end

	if(index<16)
	begin
		MUX1_2x1 mux5P1(.Y(Y[index]),.I0(wire8[index]), .I1(1'b0), .S(S[4]));
	end
	else 
	begin
		MUX1_2x1 mux5P2(.Y(Y[index]),.I0(wire8[index]), .I1(wire8[index-16]), .S(S[4]));	
	end
end
endgenerate
endmodule

//OR's values 32 times
module OR32X1_shifter(Y, S);
output Y;
input [31:0] S;
wire[31:0] ORWire;
genvar index;
generate
for(index=0; index<31; index=index+1)
begin : OR32_LOOP
	if(index == 0)
	begin
		or or1(ORWire[index], S[index], S[index+1]);
	end
	else if(index == 30)
	begin
		or or2(Y, ORWire[index-1], S[index+1]);
	end
	else if(index != 0 && index != 30)
	begin
		or or3(ORWire[index], ORWire[index-1], S[index+1]);
	end
end
endgenerate
endmodule
