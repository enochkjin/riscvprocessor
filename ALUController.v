`timescale 1 ns / 1 ps

module ALUController (
    input  [1:0] ALUOp,
    input  [6:0] Funct7,
    input  [2:0] Funct3,
    output reg [3:0] Operation
);

always @(*) begin
    case (ALUOp)
        2'b00: begin // I-type ALU ops: addi, andi, ori, slti, etc.
            case (Funct3)
                3'b000: Operation = 4'b0010; // addi
                3'b111: Operation = 4'b0000; // andi
                3'b110: Operation = 4'b0001; // ori
                3'b100: Operation = 4'b1100; // nori
                3'b010: Operation = 4'b0111; // slti
                default: Operation = 4'b1111; // undefined
            endcase
        end
        2'b01: begin // lw/sw
            Operation = 4'b0010; // only add
        end
        2'b10: begin // R-type
            case ({Funct7, Funct3})
                {7'b0000000, 3'b000}: Operation = 4'b0010; // add
                {7'b0100000, 3'b000}: Operation = 4'b0110; // sub
                {7'b0000000, 3'b111}: Operation = 4'b0000; // and
                {7'b0000000, 3'b110}: Operation = 4'b0001; // or
                {7'b0000000, 3'b100}: Operation = 4'b1100; // nor
                {7'b0000000, 3'b010}: Operation = 4'b0111; // slt
                default: Operation = 4'b1111; // undefined
            endcase
        end
        default: Operation = 4'b1111; // invalid ALUOp
    endcase
end
endmodule // ALUController
