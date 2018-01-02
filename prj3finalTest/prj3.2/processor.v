// Name: processor.v

`include "prj_definition.v"
module PROC_CS147_SEC05(DATA_OUT, ADDR, DATA_IN, READ, WRITE, CLK, RST);
// output list
output [`ADDRESS_INDEX_LIMIT:0] ADDR;
output [`DATA_INDEX_LIMIT:0] DATA_OUT;
output READ, WRITE;
// input list
input  CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_IN;

// net section
wire zero;
wire [`CTRL_WIDTH_INDEX_LIMIT:0] ctrl;
wire [`DATA_INDEX_LIMIT:0] INSTRUCTION;

// instantiation section
// Control unit




CONTROL_UNIT cu_inst (.CTRL(ctrl), .READ(READ), .WRITE(WRITE), 
                      .ZERO(zero), .INSTRUCTION(INSTRUCTION),
                      .CLK(CLK),   .RST(RST));

// data path
DATA_PATH    data_path_inst (.DATA_OUT(DATA_OUT),  .INSTRUCTION(INSTRUCTION), .DATA_IN(DATA_IN), .ADDR(ADDR), .ZERO(zero),
                             .CTRL(ctrl),  .CLK(CLK),   .RST(RST));

endmodule;