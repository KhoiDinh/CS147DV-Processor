`include "prj_definition.v"
module CONTROL_UNIT(CTRL,READ,WRITE,ZERO,INSTRUCTION,CLK,RST  );

output [31:0] CTRL;
reg [31:0] CTRL;
output ZERO,READ,WRITE;
reg READ,WRITE;
input [31:0] INSTRUCTION;
input CLK,RST;

//define sections of parsed instructions
reg [5:0] opcode;
reg [4:0] rs,rt,rd;
reg [4:0] shamt;
reg [5:0] funct;
reg [15:0] immediate;
reg [25:0] address;
wire [2:0] proc_state;
PROC_SM state_machine(.STATE(proc_state),.CLK(CLK),.RST(RST));

initial
begin
CTRL= 32'h00000000;
READ = 1;
WRITE = 0;
opcode = 0;
rs = 0;
rt = 0;
rd = 0;
funct = 0;
shamt = 0;
immediate = 0;
address = 0;
end

always @ (proc_state)  
begin
     case(proc_state)
	`PROC_FETCH: //gets instructions, control signal always the same
        begin
		READ=1;
		WRITE=0;
		CTRL = 32'h20000020;
        end
        `PROC_DECODE: //breaks instruction up, always the same control signal
 	begin 	
		CTRL = 32'h00000110;
		//print_instruction(INSTRUCTION);
		//{opcode, rs, rt, rd, shamt, funct} = INSTRUCTION;
		//{opcode, rs, rt, immediate } = INSTRUCTION;
		//{opcode,address}= INSTRUCTION;
		READ=0;
		WRITE=0;
	end
	`PROC_EXE: //choose operation based on function and opcode
	begin	
		READ=0;
		WRITE=0;
		print_instruction(INSTRUCTION);
		{opcode, rs, rt, rd, shamt, funct} = INSTRUCTION;
		{opcode, rs, rt, immediate } = INSTRUCTION;
		{opcode,address}= INSTRUCTION;

	   	case (opcode) 
			6'h00:    // R-types
			begin
			   case(funct)
				6'h20: //add
				begin
					CTRL = 32'h00601500;
				end
 				6'h22: //sub
				begin
					CTRL = 32'h00A01500;
				end
 				6'h2c: //mul
				begin
					CTRL = 32'h00E01500;
				end
 				6'h24: //and
				begin
					CTRL = 32'h01A01100;
				end
 				6'h25:  //or
				begin
					CTRL = 32'h01E01100;
				end
 				6'h27:  //nor
				begin
					CTRL = 32'h02201100;
				end 
 				6'h2a:   //slt
				begin
					CTRL = 32'h02601100;
				end
 				6'h01:  //sll
				begin
					CTRL = 32'h01541500;
				end
 				6'h02: //srl
				begin
					CTRL = 32'h01141500;
	 			end    
				6'h08: //jr
				begin
					CTRL = 32'h00000100;
				end
				default:
				begin
				CTRL = 32'h00000110;
				end
		           endcase 
			end

			6'h08:  //addi
			begin
				CTRL = 32'h00481500;
			end	
			6'h1d :  //muli
			begin
				CTRL = 32'h00c81500;
			end
			6'h0c : //andi
			begin
				CTRL = 32'h01801500;
			end
			6'h0d :  //ori
			begin
				CTRL = 32'h01c01500;
			end

			6'h0a :   //slti
			begin
				CTRL = 32'h02481500;
			end
			
			6'h0f: //lui
			begin
				CTRL = 32'h00001500;
			end
			6'h04: //beq
			begin
				CTRL = 32'h00A01500;
			end
			6'h05: //bneq
			begin
				CTRL = 32'h00A01500;
			end
			6'h1b:  // push
			begin
				CTRL = 32'h10920180;
			end
			6'h1c:  // pop
			begin
				CTRL = 32'h005A0100;
			end
			6'h23 : //lw
			begin
				CTRL = 32'h00481500;
			end
			6'h2b: //sw
			begin
				CTRL = 32'h00480100;
			end
			6'h02: //jmp
			begin
				CTRL = 32'h00000000;
			end
			6'h03: //jal
			begin
				CTRL = 32'h00000900;
			end
		endcase

	end	
	`PROC_MEM:
	begin
		READ=0;
		WRITE=0;
		case(opcode)
			6'h23 : //lw
			begin
				WRITE =0;
				READ =1;
				CTRL = 32'h00481520;
			end
			6'h2b: //sw
			begin
				WRITE = 1;
				READ = 0;
				CTRL = 32'h00480140;
			end
			6'h1b:  // push
			begin
				WRITE = 1;
				READ=0;
				CTRL = 32'h109201C0;
			end

			6'h1c:  //pop
			begin
				WRITE = 0;
				READ = 1;
				CTRL = 32'h005A0120;
			end
		endcase
	end
	`PROC_WB:
	begin
		READ=0;
		WRITE=0;
		case(opcode)
			6'h00:  // R-types
			begin
			   case(funct)
				6'h00:    // No Op
				begin
				CTRL = 32'h0000000b;
				end
				6'h20: // add
				begin
				CTRL = 32'h0060930b;//32'h0040930b;
				end
 				6'h22: //sub
				begin
					CTRL = 32'h00A0930b;
				end
 				6'h2c: //mul
				begin
					CTRL = 32'h00E0930b;
				end
				6'h24: //and
				begin
					CTRL = 32'h01A0930b;
				end
				6'h2a:   //slt
				begin
					CTRL = 32'h0260930b;
				end
 				6'h25:  //or
				begin
					CTRL = 32'h01E0930b;
				end
				6'h27:  //nor
				begin
					CTRL = 32'h0220930b;
				end 
				6'h01: //sll
				begin
					CTRL = 32'h0154930b;
				end
				6'h02: //srl
				begin
					CTRL = 32'h0114930b;
				end
				6'h08: //jr
				begin
					CTRL = 32'h00000109;
				end
				default:
				begin
				   CTRL = 32'h0000000b;
				end
			  endcase
			end
			6'h2b : // sw
			begin
				CTRL = 32'h0048000b;
			end
			6'h23 : //lw
			begin
				CTRL = 32'h0048b70b;
			end
			6'h0f :   //lui
			begin
				CTRL = 32'h0000d60b;
							
			end
			6'h08:   //addi
			begin	
				//$write("Addi statement reached: ");
				CTRL=  32'h0048970b;
			end		
			6'h1d :   //multi
			begin
				CTRL = 32'h00c8970b;
			end
			6'h0c :   //andi
			begin
				CTRL = 32'h0180970b;
			end
			6'h0d :   //ori
			begin
				CTRL = 32'h01c0970b;
			end
			6'h0a :  //slti
			begin
				CTRL = 32'h0248970b;
			end
			6'h04:	//beq
			begin
				if(ZERO ===1)
				begin
					CTRL = 32'h00A0150D;
				end
				else
				begin
					CTRL = 32'h00A0150B;
				end
				
			end
			
			6'h05:	//bneq
			begin
				if(ZERO ===0)
				begin
					CTRL = 32'h00A0150D;
				end
				else
				begin
					CTRL = 32'h00A0150B;
				end
				
			end
			6'h02 :   //jmp
			begin
				CTRL = 32'h00000801;
			end
			6'h03 :   //jal
			begin
				CTRL = 32'h00000A01;
			end
			6'h1b:  //push
			begin
				CTRL = 32'h1093018b;
			end
			6'h1c:  //pop
			begin
				CTRL = 32'h005BA30b;
			end
			default:  //Unknown type
			begin
				CTRL = 32'h0000000b; // increments the program counter
			end
		endcase
	end
     endcase
end


task print_instruction;	//debugging purpose, attributions to cs club
input [`DATA_INDEX_LIMIT:0] inst;
reg [5:0] opcode;
reg [4:0] rs;
reg [4:0] rt;
reg [4:0] rd;
reg [4:0] shamt;
reg [5:0] funct;
reg [15:0] immediate;
reg [25:0] address;
begin
// parse the instruction
// R-type
{opcode, rs, rt, rd, shamt, funct} = inst;
// I-type
{opcode, rs, rt, immediate } = inst;
// J-type
{opcode, address} = inst;
$write("@ %6dns -> [0X%08h] ", $time, inst);
case(opcode)
// R-Type
6'h00 : begin
 case(funct)
 6'h20: $write("add r[%02d], r[%02d], r[%02d];", rd, rt, rs); // need to change these as i do them
 6'h22: $write("sub r[%02d], r[%02d], r[%02d];", rs, rt, rd);
 6'h2c: $write("mul r[%02d], r[%02d], r[%02d];", rs, rt, rd);
 6'h24: $write("and r[%02d], r[%02d], r[%02d];", rs, rt, rd);

 6'h25: $write("or r[%02d], r[%02d], r[%02d];", rs, rt, rd);
 6'h27: $write("nor r[%02d], r[%02d], r[%02d];", rs, rt, rd);
 6'h2a: $write("slt r[%02d], r[%02d], r[%02d];", rs, rt, rd);
 6'h01: $write("sll r[%02d], %2d, r[%02d];", rs, shamt, rd);
 6'h02: $write("srl r[%02d], %02d, r[%02d];", rs, shamt, rd);
 6'h08: $write("jr r[%02d];", rs);
 default: $write("");
 endcase
 end
// I-type
6'h08 : $write("addi r[%02d], r[%02d], 0X%04h;", rt, rs, immediate);
6'h1d : $write("muli r[%02d], r[%02d], 0X%04h;", rt, rs, immediate);
6'h0c : $write("andi r[%02d], r[%02d], 0X%04h;", rt, rs, immediate);
6'h0d : $write("ori r[%02d], r[%02d], 0X%04h;", rt, rs, immediate);
6'h0f : $write("lui r[%02d], 0X%04h;", rt, immediate);
6'h0a : $write("slti r[%02d], r[%02d], 0X%04h;", rt, rs, immediate);
6'h04 : $write("beq r[%02d], r[%02d], 0X%04h;", rt, rs, immediate);
6'h05 : $write("bne r[%02d], r[%02d], 0X%04h;", rt, rs, immediate);
6'h23 : $write("lw r[%02d], r[%02d], 0X%04h;", rt, rs, immediate);
6'h2b : $write("sw r[%02d], r[%02d], 0X%04h;", rt, rs, immediate);
// J-Type
6'h02 : $write("jmp 0X%07h;", address);
6'h03 : $write("jal 0X%07h;", address);
6'h1b : $write("push;");
6'h1c : $write("pop;");
default: $write("not working");
endcase
$write("\n");
end
endtask
endmodule;

//------------------------------------------------------------------------------------------
// Module: CONTROL_UNIT
// Output: STATE      : State of the processor
//         
// Input:  CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Processor continuously cycle witnin fetch, decode, execute, 
//          memory, write back state. State values are in the prj_definition.v
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
module PROC_SM(STATE,CLK,RST);
// list of inputs
input CLK, RST;
// list of outputs
output [2:0] STATE;
reg [2:0] STATE;
reg [2:0] NEXT_STATE;

always @ (negedge RST or posedge CLK)	//controls state order
begin

  if(RST ===1'b0)
     begin
	NEXT_STATE =`PROC_FETCH ;
        STATE  = 'bxx;
     end 
   else 
     begin
         STATE = NEXT_STATE;
         case (STATE)
            `PROC_FETCH : NEXT_STATE = `PROC_DECODE;
            `PROC_DECODE : NEXT_STATE = `PROC_EXE;
            `PROC_EXE : NEXT_STATE = `PROC_MEM;
            `PROC_MEM : NEXT_STATE = `PROC_WB;
            `PROC_WB : NEXT_STATE = `PROC_FETCH;
         endcase
     end 
end
endmodule;
