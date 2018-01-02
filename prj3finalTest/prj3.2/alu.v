`include "prj_definition.v"
module ALU(OUT, ZERO, OP1, OP2, OPRN);
input [`DATA_INDEX_LIMIT:0] OP1, OP2; 
input [`ALU_OPRN_INDEX_LIMIT:0] OPRN; 
output [`DATA_INDEX_LIMIT:0] OUT; 
output ZERO;
wire [`DATA_INDEX_LIMIT:0] temp0,temp1,temp2,
temp3,temp4,temp5,temp6;
wire [31:0] LO,HI;
wire C0,SnA;
wire notAdd;
wire sltWire;

//define operations
and andOp( sltWire , OPRN[3], OPRN[0] );
not notOp( notAdd, OPRN[0]);
or orOp(SnA,notAdd, sltWire);
RC_ADD_SUB_32 addSubOp(.Y(temp0), .CO(C0), .A(OP1),.B(OP2),.SnA(SnA) );
SHIFT32 shiftOp(.Y(temp1),.D(OP1),.S(OP2), .LnR(OPRN[0]) );
AND32_2x1 and32Op(.Y(temp2),.A(OP1),.B(OP2) );
OR32_2x1 Or32Op(.Y(temp3),.A(OP1),.B(OP2) );
MULT32 multOP(.HI(HI), .LO(LO), .A(OP1), .B(OP2) );
NOR32_2x1 Nor32Op(.Y(temp5),.A(OP1),.B(OP2) );

//I1/I2 = add/sub, I3 = mult, I4/I5 = shift left and right, I6 = and, I7 = or, I8 = nor, I9 = slt, rest is jump and branch operations
MUX32_16x1  muxgate(.Y(OUT),.I0(32'h00000000),.I1(temp0),
.I2(temp0),.I3(LO),.I4(temp1),.I5(temp1), //i4 = left shift
 .I6(temp2),.I7(temp3),.I8(temp5),.I9( { {31{1'b0}},temp0[31]} ),
.I10(32'h00000000),.I11(32'h00000000),.I12(32'h00000000)
,.I13(32'h0),.I14(32'h0),.I15(32'h0),.S({OPRN[3:0]}));

//nor the outputs
nor nor2(ZERO,OUT[0],OUT[1] ,OUT[2] ,OUT[3] ,OUT[4] 
,OUT[5] ,OUT[6],OUT[7] ,OUT[8] ,OUT[09] ,OUT[10] ,OUT[11]
 ,OUT[12] ,OUT[13] ,OUT[14] ,OUT[15] ,OUT[16] ,OUT[17]
 ,OUT[18] ,OUT[19] ,OUT[20] ,OUT[21] ,OUT[22] 
,OUT[23] ,OUT[24] ,OUT[25] ,OUT[26] ,OUT[27] ,OUT[28] 
,OUT[29] ,OUT[30] ,OUT[31]);
endmodule
