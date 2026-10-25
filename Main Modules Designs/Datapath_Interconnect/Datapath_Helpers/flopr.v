`timescale 1ns / 1ps

module flopr #(
    parameter WIDTH = 32
) (
    input  wire             clk,
    input  wire             reset,
    input  wire [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= {WIDTH{1'b0}}; // Xóa về 0 khi có tín hiệu reset
        else
            q <= d;             // Chốt dữ liệu d tại cạnh lên xung nhịp clk
    end

endmodule