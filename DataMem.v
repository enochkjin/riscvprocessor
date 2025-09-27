`timescale 1ns / 1ps

module DataMem (
    input clk,
    input MemRead,
    input MemWrite,
    input [8:0] addr,             // 9-bit address supports 512 bytes (2^9 = 512)
    input [31:0] write_data,
    output reg [31:0] read_data
);

    // Define memory with 128 words, 32 bits each
    reg [31:0] Data_Memory [0:127];

    // Write happens on clock edge if enabled
    always @(posedge clk) begin
        if (MemWrite)
            Data_Memory[addr[8:2]] <= write_data; // Only using bits 2-8 for word addressing
    end

    // Read is immediate if enabled, else return 0
    always @(*) begin
        if (MemRead)
            read_data = Data_Memory[addr[8:2]];
        else
            read_data = 32'b0;
    end
endmodule
