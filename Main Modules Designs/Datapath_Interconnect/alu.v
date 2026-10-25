`timescale 1ns / 1ps

module alu (
    input  wire [31:0] a, b,
    input  wire [2:0]  alucontrol,
    output reg  [31:0] result,
    output wire        zero
);
    always @(*) begin
        case (alucontrol)
            3'b000: result = a & b;                      // AND (slide 24, 65)
            3'b001: result = a | b;                      // OR  (slide 24, 65)
            3'b010: result = a + b;                      // ADD (slide 24, 65)
            3'b110: result = a - b;                      // SUB (slide 24, 65)
            3'b111: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // SLT (slide 24, 65)
            default: result = 32'b0;
        endcase
    end

    assign zero = (result == 32'b0); // Cờ Zero bật khi kết quả bằng 0 (slide 42, 63)
endmodule