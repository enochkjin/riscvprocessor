`timescale 1 ns / 1 ps

module RegFile (

    clk, reset, rg_wrt_en,
    rg_wrt_addr,
    rg_rd_addr1,
    rg_rd_addr2,
    rg_wrt_data,
    rg_rd_data1,
    rg_rd_data2
);

    input clk;
    input reset;
    input rg_wrt_en;
    input [4:0] rg_wrt_addr;
    input [4:0] rg_rd_addr1;
    input [4:0] rg_rd_addr2;
    input [31:0] rg_wrt_data;
    output [31:0] rg_rd_data1;
    output [31:0] rg_rd_data2;

    //32 registers: 32 bits each
    reg [31:0] reg_array [0:31];

    // For the always() block
    integer i;
    initial i = 0;

    // Async reset and sync write
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                reg_array[i] <= 32'h00000000;
            end
        end
        else if (rg_wrt_en) begin // Write to the register if enabled
            reg_array[rg_wrt_addr] <= rg_wrt_data;
        end
    end

    // Async read for combinational logic
    assign rg_rd_data1 = reg_array[rg_rd_addr1];
    assign rg_rd_data2 = reg_array[rg_rd_addr2];

endmodule