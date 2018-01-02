`include "prj_definition.v"
`timescale 1ns/1ps

module alu_tb;
reg [`ALU_OPRN_INDEX_LIMIT:0] OPRN;
reg [`DATA_INDEX_LIMIT:0] OP1, OP2;
wire[`DATA_INDEX_LIMIT:0]  OUT;
wire ZERO;

ALU alu1(.OUT(OUT), .ZERO(ZERO), .OP1(OP1), .OP2(OP2), .OPRN(OPRN));


initial 
begin
	OP1= 0; OP2=0; OPRN=0;
	#5 OP1 =5; OP2=-5; OPRN=1; // add
	#5 $write("\n op1:%d op2:%d oprn:%d out:%d zero:%d", OP1, OP2, OPRN, OUT, ZERO);
	#5 OP1 =10; OP2=4; OPRN=2; //sub
	#5 $write("\n op1:%d op2:%d oprn:%d out:%d zero:%d", OP1, OP2, OPRN, OUT, ZERO);
	#5 OP1 =5; OP2=5; OPRN=3; //mult
	#5 $write("\n op1:%d op2:%d oprn:%d out:%d zero:%d", OP1, OP2, OPRN, OUT, ZERO);
	#5 OP1 =600203; OP2=1000; OPRN=3; //mult
	#5 $write("\n op1:%d op2:%d oprn:%d out:%d zero:%d", OP1, OP2, OPRN, OUT, ZERO);
	#5 OP1 =15; OP2=1; OPRN=4; // shift Right
	#5 $write("\n op1:%d op2:%d oprn:%d out:%d zero:%d", OP1, OP2, OPRN, OUT, ZERO);
	#5 OP1 =20; OP2=3; OPRN=5; //shift Left
	#5 $write("\n op1:%d op2:%d oprn:%d out:%d zero:%d", OP1, OP2, OPRN, OUT, ZERO);
	#5 OP1 =13; OP2=5; OPRN=6; //and
	#5 $write("\n op1:%d op2:%d oprn:%d out:%d zero:%d", OP1, OP2, OPRN, OUT, ZERO);
	#5 OP1 =5; OP2=10; OPRN=7; //or
	#5 $write("\n op1:%d op2:%d oprn:%d out:%d zero:%d", OP1, OP2, OPRN, OUT, ZERO);
	#5 OP1 =5; OP2=-5; OPRN=8; //nor
	#5 $write("\n op1:%d op2:%d oprn:%d out:%d zero:%d", OP1, OP2, OPRN, OUT, ZERO);
	#5 OP1 =5; OP2=5; OPRN=9; //slt
	#5 $write("\n op1:%d op2:%d oprn:%d out:%d zero:%d", OP1, OP2, OPRN, OUT, ZERO);
	#5 OP1 =2; OP2=10; OPRN=9; //slt
	#5 $write("\n op1:%d op2:%d oprn:%d out:%d zero:%d", OP1, OP2, OPRN, OUT, ZERO);
	#5 OP1 =10; OP2=2; OPRN=9; //slt
	#5 $write("\n op1:%d op2:%d oprn:%d out:%d zero:%d", OP1, OP2, OPRN, OUT, ZERO);
end
endmodule
