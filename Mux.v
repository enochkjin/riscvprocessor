module Mux21 (
    input S,
    input [31:0] D1,
    input [31:0] D2,
    output [31:0] Y
);
    assign Y = S ? D2 : D1;
endmodule
