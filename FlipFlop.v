`timescale 1 ns / 1 ps

module FlipFlop (

    input        clk,
    input        reset,
    input  [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 8'b0;    // Clear output if reset is high on clock edge
        else
            q <= d;       // Otherwise, store input value
    end

endmodule