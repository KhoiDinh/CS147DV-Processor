`include "prj_definition.v"
module DATA_PATH(DATA_OUT, ADDR, ZERO, INSTRUCTION, DATA_IN, CTRL, CLK, RST);
 
output [31:0] DATA_OUT,INSTRUCTION;
output ZERO;
output [25:0] ADDR;
input [31:0] DATA_IN, CTRL;
input CLK,RST;

wire [31:0] PROGRAM_COUNTER,STACK_POINTER,PC_IMM, PC_ADD_1;
wire [31:0] DATA_R1,DATA_R2;
wire [31:0] op1_sel_1_out,op2_sel_1_out,op2_sel_2_out,op2_sel_3_out,op2_sel_4_out;
wire [31:0] wa_sel_1_out ,wa_sel_2_out, wa_sel_3_out;
wire [31:0] wd_sel_1_out,wd_sel_2_out,wd_sel_3_out;
wire [31:0] ma_sel_1_out;
wire [31:0] r1_sel_1_out;
wire [31:0] pc_sel_1_out, pc_sel_2_out,pc_sel_3_out;
wire [31:0] OUT;

//program counter
defparam pc_inst.PATTERN = `INST_START_ADDR;
REG32_PP pc_inst(.Q( PROGRAM_COUNTER ), .D( pc_sel_3_out  ), .LOAD( CTRL[0] ), .CLK(CLK), .RESET(RST));

//stack pointer
defparam sp_inst.PATTERN = `INIT_STACK_POINTER;
REG32_PP sp_inst(.Q(STACK_POINTER), .D(OUT), .LOAD( CTRL[16] ), .CLK(CLK), .RESET(RST));
REG32 INSTRUCTIONREGISTER(.Q(INSTRUCTION), .D(DATA_IN), .LOAD(CTRL[4]), .CLK(CLK), .RESET(RST) );

//inititalization of control unit
MUX32_2x1 op1_sel_1_mux(.Y( op1_sel_1_out ) , .I0( DATA_R1 ), .I1( STACK_POINTER ), .S(   CTRL[17]) );
MUX32_2x1 op2_sel_1_mux(.Y( op2_sel_1_out) , .I0( 32'b1 ), .I1(  {{27'b0} ,INSTRUCTION[10:6]}  ), .S( CTRL[18]  ) );
MUX32_2x1 op2_sel_2_mux(.Y( op2_sel_2_out) , .I0( {{16'b0} ,INSTRUCTION[15:0]}  ), .I1(   {{16{INSTRUCTION[15]}} ,INSTRUCTION[15:0]}   ), .S(  CTRL[19]  ) );
MUX32_2x1 op2_sel_3_mux(.Y( op2_sel_3_out) , .I0( op2_sel_2_out ), .I1(op2_sel_1_out ), .S( CTRL[20] ));
MUX32_2x1 op2_sel_4_mux(.Y( op2_sel_4_out) , .I0( op2_sel_3_out ), .I1( DATA_R2 ), .S( CTRL[21]) );


MUX32_2x1 wa_sel_1_mux(.Y( wa_sel_1_out) , .I0(  { {27{1'b0}}, INSTRUCTION[15:11] }), .I1({ {27{1'b0}}, INSTRUCTION[20:16] } ),.S( CTRL[10] ));
MUX32_2x1 wa_sel_2_mux(.Y( wa_sel_2_out) , .I0(  32'h00000000  ), .I1( 32'b11111  ), .S( CTRL[11]));
MUX32_2x1 wa_sel_3_mux(.Y( wa_sel_3_out) , .I0( wa_sel_2_out ), .I1( wa_sel_1_out ), .S( CTRL[12]) );


MUX32_2x1 wd_sel_1_mux(.Y( wd_sel_1_out ) , .I0( OUT ), .I1( DATA_IN), .S( CTRL[13] ) );
MUX32_2x1 wd_sel_2_mux(.Y( wd_sel_2_out ) , .I0( wd_sel_1_out), .I1( {INSTRUCTION[15:0],{16'b0}} ), .S( CTRL[14]) );
MUX32_2x1 wd_sel_3_mux(.Y( wd_sel_3_out ) , .I0(  PC_ADD_1 ), .I1( wd_sel_2_out  ), .S( CTRL[15] ) );


RC_ADD_SUB_32 rc1(.Y(PC_ADD_1) , .CO(decoy1) , .A(PROGRAM_COUNTER), .B(32'b1), .SnA( 1'b0));
RC_ADD_SUB_32 rc2(.Y(PC_IMM ) , .CO(decoy2) , .A( PC_ADD_1 ), .B( {{16{INSTRUCTION[15]}} ,INSTRUCTION[15:0]} ), .SnA( 1'b0));

ALU alu(.OUT(OUT), .ZERO(ZERO), .OP1(op1_sel_1_out), .OP2(op2_sel_4_out), .OPRN( CTRL[27:22]  ) );


MUX32_2x1 md_sel_1_mux(.Y( DATA_OUT ) , .I0(DATA_R2), .I1(DATA_R1  ), .S( CTRL[30] ) );


MUX32_2x1 ma_sel_1_mux(.Y(ma_sel_1_out) , .I0( OUT), .I1( STACK_POINTER), .S( CTRL[28]) );
MUX32_2x1 ma_sel_2_mux(.Y(ADDR) , .I0(ma_sel_1_out), .I1( PROGRAM_COUNTER ), .S( CTRL[29]  ) );

MUX32_2x1 r1_sel_1_mux(.Y( r1_sel_1_out) , .I0( { {27{1'b0}}, INSTRUCTION[25:21] } ), .I1( 32'b00000 ), .S( CTRL[7]));


REGISTER_FILE_32x32 REGISTERFILE( .DATA_R1(DATA_R1), .DATA_R2(DATA_R2), .ADDR_R1( r1_sel_1_out[4:0] ) , 
.ADDR_R2(  INSTRUCTION[20:16]  ) , .DATA_W(wd_sel_3_out), .ADDR_W( wa_sel_3_out[4:0] ) ,
 .READ( CTRL[8]  ), .WRITE(  CTRL[9] ), .CLK(CLK), .RST(RST) );

MUX32_2x1 pc_sel_1_mux(.Y( pc_sel_1_out) , .I0(DATA_R1 ), .I1( PC_ADD_1 ), .S( CTRL[1] ));
MUX32_2x1 pc_sel_2_mux(.Y( pc_sel_2_out) , .I0(pc_sel_1_out), .I1( PC_IMM ), .S( CTRL[2] ));
MUX32_2x1 pc_sel_3_mux(.Y( pc_sel_3_out ) , .I0( {{6'b0} ,INSTRUCTION[25:0]}    ), .I1( pc_sel_2_out  ), .S( CTRL[3] ));

endmodule;

//program pointer
module REG32_PP(Q, D, LOAD, CLK, RESET);
parameter PATTERN = 32'h00000000;
output [31:0] Q;

input CLK, LOAD;
input [31:0] D;
input RESET;

wire [31:0] qbar;

genvar i;
generate 
for(i=0; i<32; i=i+1)
begin : reg32_gen_loop
if (PATTERN[i] == 0)
REG1 reg_inst(.Q(Q[i]), .Qbar(qbar[i]), .D(D[i]), .L(LOAD), .C(CLK), .nP(1'b1), .nR(RESET)); 
else
REG1 reg_inst(.Q(Q[i]), .Qbar(qbar[i]), .D(D[i]), .L(LOAD), .C(CLK), .nP(RESET), .nR(1'b1));
end 
endgenerate

endmodule





