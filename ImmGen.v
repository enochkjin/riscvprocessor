module ImmGen (
    input [31:0] InstCode,
    output reg [31:0] ImmOut
);

always @ (InstCode) begin
    case (InstCode[6:0])
        // I-type (e.g., Load and immediate ALU ops)
        7'b0000011, // Load
        7'b0010011: // ALU immediate
            ImmOut = {{20{InstCode[31]}}, InstCode[31:20]};
        
        // S-type (Store)
        7'b0100011:
            ImmOut = {{20{InstCode[31]}}, InstCode[31:25], InstCode[11:7]};
        
        // U-type (LUI/AUIPC)
        7'b0010111:
            ImmOut = {InstCode[31:12], 12'b0};
        
        // Default case
        default:
            ImmOut = 32'b0;
    endcase
end

endmodule