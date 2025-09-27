module ALU (
    input [31:0] A_in, B_in,              // 32-bit inputs
    input [3:0] ALU_Sel,                  // 4-bit ALU operation select
    output [31:0] ALU_Out,                // 32-bit ALU output
    output reg Carry_Out,                 // Carry flag
    output Zero,                          // Zero flag
    output reg Overflow                   // Overflow flag
);

reg [31:0] ALU_Result;
reg [32:0] temp;
reg [32:0] twos_com;

assign ALU_Out = ALU_Result;
assign Zero = (ALU_Result == 32'b0);

always @(*) begin
    Overflow = 1'b0;
    Carry_Out = 1'b0;
    case (ALU_Sel)
        4'b0000: ALU_Result = A_in & B_in;
        4'b0001: ALU_Result = A_in | B_in;
        4'b0010: begin // Signed addition
            ALU_Result = $signed(A_in) + $signed(B_in);
            temp = {1'b0, A_in} + {1'b0, B_in};
            Carry_Out = temp[32];
            Overflow = (A_in[31] & B_in[31] & ~ALU_Result[31]) |
                       (~A_in[31] & ~B_in[31] & ALU_Result[31]);
        end
        4'b0110: begin // Signed subtraction
            ALU_Result = $signed(A_in) - $signed(B_in);
            twos_com = ~B_in + 1;
            Overflow = (A_in[31] & twos_com[31] & ~ALU_Result[31]) |
                       (~A_in[31] & ~twos_com[31] & ALU_Result[31]);
        end
        4'b0111: ALU_Result = ($signed(A_in) < $signed(B_in)) ? 32'd1 : 32'd0;
        4'b1100: ALU_Result = ~(A_in | B_in);
        4'b1111: ALU_Result = (A_in == B_in) ? 32'd1 : 32'd0;
        default: ALU_Result = A_in + B_in;
    endcase
end

endmodule