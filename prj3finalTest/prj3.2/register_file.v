// Name: register_file.v
// Module: REGISTER_FILE_32x32
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"

// This is going to be +ve edge clock triggered register file.
// Reset on RST=0
module REGISTER_FILE_32x32(DATA_R1, DATA_R2, ADDR_R1, ADDR_R2, 
                            DATA_W, ADDR_W, READ, WRITE, CLK, RST);

input READ, WRITE, CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_W;
input [4:0] ADDR_R1, ADDR_R2, ADDR_W;
output [`DATA_INDEX_LIMIT:0] DATA_R1,DATA_R2;

wire [31:0] decodeWire, andWire;	//connection wires
wire [31:0] tempWire1,tempWire2;
wire [31:0] temp [31:0];


DECODER_5x32 decoder(.D(decodeWire) ,.I( ADDR_W   ) );	//perform decode operation

and and0(andWire[0] ,decodeWire[0], WRITE);	// logical and's specific bits in wire
and and1(andWire[1],decodeWire[1], WRITE);
and and2(andWire[2],decodeWire[2], WRITE);
and and3(andWire[3],decodeWire[3], WRITE);
and and4(andWire[4],decodeWire[4], WRITE);
and and5(andWire[5],decodeWire[5], WRITE);
and and6(andWire[6],decodeWire[6], WRITE);
and and7(andWire[7],decodeWire[7], WRITE);
and and8(andWire[8],decodeWire[8], WRITE);
and and9(andWire[9],decodeWire[9], WRITE);
and and10(andWire[10],decodeWire[10], WRITE);
and and11(andWire[11],decodeWire[11], WRITE);
and and12(andWire[12],decodeWire[12], WRITE);
and and13(andWire[13],decodeWire[13], WRITE);
and and14(andWire[14],decodeWire[14], WRITE);
and and15(andWire[15],decodeWire[15], WRITE);
and and16(andWire[16],decodeWire[16], WRITE);
and and17(andWire[17],decodeWire[17], WRITE);
and and18(andWire[18],decodeWire[18], WRITE);
and and19(andWire[19],decodeWire[19], WRITE);
and and20(andWire[20],decodeWire[20], WRITE);
and and21(andWire[21],decodeWire[21], WRITE);
and and22(andWire[22],decodeWire[22], WRITE);
and and23(andWire[23],decodeWire[23], WRITE);
and and24(andWire[24],decodeWire[24], WRITE);
and and25(andWire[25],decodeWire[25], WRITE);
and and26(andWire[26],decodeWire[26], WRITE);
and and27(andWire[27],decodeWire[27], WRITE);
and and28(andWire[28],decodeWire[28], WRITE);
and and29(andWire[29],decodeWire[29], WRITE);
and and30(andWire[30],decodeWire[30], WRITE);
and and31(andWire[31],decodeWire[31], WRITE);

REG32 reg0( .Q(temp[0]), .D(DATA_W), .LOAD( andWire[0]), .CLK(CLK),.RESET(RST)); //creates registers
REG32 reg1( .Q(temp[1]), .D(DATA_W), .LOAD( andWire[1]), .CLK(CLK),.RESET(RST));
REG32 reg2( .Q(temp[2]), .D(DATA_W), .LOAD( andWire[2]), .CLK(CLK),.RESET(RST));
REG32 reg3( .Q(temp[3]), .D(DATA_W), .LOAD( andWire[3]), .CLK(CLK),.RESET(RST));
REG32 reg4( .Q(temp[4]), .D(DATA_W), .LOAD( andWire[4]), .CLK(CLK),.RESET(RST));
REG32 reg5( .Q(temp[5]), .D(DATA_W), .LOAD( andWire[5]), .CLK(CLK),.RESET(RST));
REG32 reg6( .Q(temp[6]), .D(DATA_W), .LOAD( andWire[6]), .CLK(CLK),.RESET(RST));
REG32 reg7( .Q(temp[7]), .D(DATA_W), .LOAD( andWire[7]), .CLK(CLK),.RESET(RST));
REG32 reg8( .Q(temp[8]), .D(DATA_W), .LOAD( andWire[8]), .CLK(CLK),.RESET(RST));
REG32 reg9( .Q(temp[9]), .D(DATA_W), .LOAD( andWire[9]), .CLK(CLK),.RESET(RST));
REG32 reg10( .Q(temp[10]), .D(DATA_W), .LOAD( andWire[10]), .CLK(CLK),.RESET(RST));
REG32 reg11( .Q(temp[11]), .D(DATA_W), .LOAD( andWire[11]), .CLK(CLK),.RESET(RST));
REG32 reg12( .Q(temp[12]), .D(DATA_W), .LOAD( andWire[12]), .CLK(CLK),.RESET(RST));
REG32 reg13( .Q(temp[13]), .D(DATA_W), .LOAD( andWire[13]), .CLK(CLK),.RESET(RST));
REG32 reg14( .Q(temp[14]), .D(DATA_W), .LOAD( andWire[14]), .CLK(CLK),.RESET(RST));
REG32 reg15( .Q(temp[15]), .D(DATA_W), .LOAD( andWire[15]), .CLK(CLK),.RESET(RST));
REG32 reg16( .Q(temp[16]), .D(DATA_W), .LOAD( andWire[16]), .CLK(CLK),.RESET(RST));
REG32 reg17( .Q(temp[17]), .D(DATA_W), .LOAD( andWire[17]), .CLK(CLK),.RESET(RST));
REG32 reg18( .Q(temp[18]), .D(DATA_W), .LOAD( andWire[18]), .CLK(CLK),.RESET(RST));
REG32 reg19( .Q(temp[19]), .D(DATA_W), .LOAD( andWire[19]), .CLK(CLK),.RESET(RST));
REG32 reg20( .Q(temp[20]), .D(DATA_W), .LOAD( andWire[20]), .CLK(CLK),.RESET(RST));
REG32 reg21( .Q(temp[21]), .D(DATA_W), .LOAD( andWire[21]), .CLK(CLK),.RESET(RST));
REG32 reg22( .Q(temp[22]), .D(DATA_W), .LOAD( andWire[22]), .CLK(CLK),.RESET(RST));
REG32 reg23( .Q(temp[23]), .D(DATA_W), .LOAD( andWire[23]), .CLK(CLK),.RESET(RST));
REG32 reg24( .Q(temp[24]), .D(DATA_W), .LOAD( andWire[24]), .CLK(CLK),.RESET(RST));
REG32 reg25( .Q(temp[25]), .D(DATA_W), .LOAD( andWire[25]), .CLK(CLK),.RESET(RST));
REG32 reg26( .Q(temp[26]), .D(DATA_W), .LOAD( andWire[26]), .CLK(CLK),.RESET(RST));
REG32 reg27( .Q(temp[27]), .D(DATA_W), .LOAD( andWire[27]), .CLK(CLK),.RESET(RST));
REG32 reg28( .Q(temp[28]), .D(DATA_W), .LOAD( andWire[28]), .CLK(CLK),.RESET(RST));
REG32 reg29( .Q(temp[29]), .D(DATA_W), .LOAD( andWire[29]), .CLK(CLK),.RESET(RST));
REG32 reg30( .Q(temp[30]), .D(DATA_W), .LOAD( andWire[30]), .CLK(CLK),.RESET(RST));
REG32 reg31( .Q(temp[31]), .D(DATA_W), .LOAD( andWire[31]), .CLK(CLK),.RESET(RST));


MUX32_32x1 mux1(.Y(tempWire2) ,.I0(temp[0]) ,.I1(temp[1]),.I2(temp[2]),.I3(temp[3]),.I4(temp[4]),.I5(temp[5])
,.I6(temp[6]),.I7(temp[7]),.I8(temp[8]),.I9(temp[9]),.I10(temp[10]),.I11(temp[11]),.I12(temp[12]),.I13(temp[13]),
.I14(temp[14]),.I15(temp[15]),.I16(temp[16]),.I17(temp[17]) 
,.I18(temp[18]) ,.I19(temp[19]) ,.I20(temp[20]) ,.I21(temp[21]) ,.I22(temp[22]) ,.I23(temp[23]) 
,.I24(temp[24]) ,.I25(temp[25]) ,.I26(temp[26]) ,.I27(temp[27]) ,.I28(temp[28]) ,.I29(temp[29]),.I30(temp[30]) 
,.I31(temp[31]), .S(ADDR_R1));


//creates mux's for choosing
MUX32_32x1 mux2(.Y(tempWire1) ,.I0(temp[0]) ,.I1(temp[1]),.I2(temp[2]),.I3(temp[3]),.I4(temp[4]),.I5(temp[5])
,.I6(temp[6]),.I7(temp[7]),.I8(temp[8]),.I9(temp[9]),.I10(temp[10]),.I11(temp[11]),.I12(temp[12]),.I13(temp[13]),
.I14(temp[14]),.I15(temp[15]),.I16(temp[16]),.I17(temp[17]) 
,.I18(temp[18]) ,.I19(temp[19]) ,.I20(temp[20]) ,.I21(temp[21]) ,.I22(temp[22]) ,.I23(temp[23]) 
,.I24(temp[24]) ,.I25(temp[25]) ,.I26(temp[26]) ,.I27(temp[27]) ,.I28(temp[28]) ,.I29(temp[29]),.I30(temp[30]) 
,.I31(temp[31]), .S(ADDR_R2));

MUX32_2x1 mux3(.Y(DATA_R1), .I0(32'hzzzzzzzz) , .I1(tempWire2), .S(READ));
MUX32_2x1 mux4(.Y(DATA_R2), .I0(32'hzzzzzzzz), .I1(tempWire1), .S(READ) );



endmodule
