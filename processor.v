`timescale 1 ns / 1 ps

module processor (
    input clk, reset,
    output [31:0] Result
);

// Control wiring
wire        reg_write, mem2reg, alu_src;
wire        mem_read, mem_write;
wire [1:0]  alu_op;
wire [3:0]  alu_cc;

// Instruction fields
wire [6:0] opcode;
wire [6:0] funct7;
wire [2:0] funct3;

// ALU result
wire [31:0] alu_result;
assign Result = alu_result;

// Instantiating the datapath
Datapath dp_inst (
    .clk(clk),
    .reset(reset),
    .reg_write(reg_write),
    .mem2reg(mem2reg),
    .alu_src(alu_src),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .alu_cc(alu_cc),
    .opcode(opcode),
    .funct7(funct7),
    .funct3(funct3),
    .alu_result(alu_result)
);

// Instantiating he controller
Controller controller_inst (
    .Opcode(opcode),
    .ALUSrc(alu_src),
    .MemtoReg(mem2reg),
    .RegWrite(reg_write),
    .MemRead(mem_read),
    .MemWrite(mem_write),
    .ALUOp(alu_op)
);

// Instantiating the ALUOp
ALUController alu_ctrl_inst (
    .ALUOp(alu_op),
    .Funct7(funct7),
    .Funct3(funct3),
    .Operation(alu_cc)
);

endmodule
