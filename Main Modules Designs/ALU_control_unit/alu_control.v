`timescale 1ns / 1ps

module ALUControlUnit(
    input wire [1:0] aluOp,
    input wire [5:0] funct,
    output reg [3:0] aluControl
);

    always @(*) begin
        case(aluOp)
            2'b00: aluControl = 4'b0010;
            2'b01: aluControl = 4'b0110;
            2'b10: begin
                case(funct)
                    6'b100000: aluControl = 4'b0010;
                    6'b100010: aluControl = 4'b0110;
                    6'b100100: aluControl = 4'b0000;
                    6'b100101: aluControl = 4'b0001;
                    6'b101010: aluControl = 4'b0111;
                    default:   aluControl = 4'b1111;
                endcase
            end
            default: aluControl = 4'b1111;
        endcase
    end
endmodule