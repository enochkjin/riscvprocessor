`timescale 1 ns / 1 ps

module Datapath (
    input clk,
    input reset,
    input reg_write,
    input mem2reg,
    input alu_src,
    input mem_write,
    input mem_read,
    input [3:0] alu_cc,
    output [6:0] opcode,
    output [6:0] funct7,
    output [2:0] funct3,
    output [31:0] alu_result
);

    // Program Counter
    wire [7:0] pc_out, pc_in;
    assign pc_in = pc_out + 8'd4;

    FlipFlop pc_reg (
        .clk(clk),
        .reset(reset),
        .d(pc_in),
        .q(pc_out)
    );

    // Instruction Memory
    wire [31:0] instruction;
    InstMem imem (
        .addr(pc_out),
        .instruction(instruction)
    );

    assign opcode = instruction[6:0];
    wire [4:0] rd   = instruction[11:7];
    assign funct3   = instruction[14:12];
    wire [4:0] rs1  = instruction[19:15];
    wire [4:0] rs2  = instruction[24:20];
    assign funct7   = instruction[31:25];

    // Register File
    wire [31:0] reg_data1, reg_data2, write_back_data;

    RegFile rf (
        .clk(clk),
        .reset(reset),
        .rg_wrt_en(reg_write),
        .rg_wrt_addr(rd),
        .rg_rd_addr1(rs1),
        .rg_rd_addr2(rs2),
        .rg_wrt_data(write_back_data),
        .rg_rd_data1(reg_data1),
        .rg_rd_data2(reg_data2)
    );

    // Immediate Generator
    wire [31:0] imm_out;

    ImmGen immgen (
        .InstCode(instruction),
        .ImmOut(imm_out)
    );

    // ALU input mux
    wire [31:0] alu_input2;

    Mux21 alu_mux (
        .S(alu_src),
        .D1(reg_data2),
        .D2(imm_out),
        .Y(alu_input2)
    );

    // ALU
    wire carry_out, zero, overflow;

    ALU alu (
        .A_in(reg_data1),
        .B_in(alu_input2),
        .ALU_Sel(alu_cc),
        .ALU_Out(alu_result),
        .Carry_Out(carry_out),
        .Zero(zero),
        .Overflow(overflow)
    );

    // Data Memory
    wire [31:0] mem_data;

    DataMem dmem (
        .MemRead(mem_read),
        .MemWrite(mem_write),
        .addr(alu_result),
        .write_data(reg_data2),
        .read_data(mem_data)
    );

    // Write-back mux
    Mux21 wb_mux (
        .S(mem2reg),
        .D1(alu_result),
        .D2(mem_data),
        .Y(write_back_data)
    );

endmodule
