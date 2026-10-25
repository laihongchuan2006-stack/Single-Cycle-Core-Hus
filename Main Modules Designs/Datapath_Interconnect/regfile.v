`timescale 1ns / 1ps

module regfile (
    input  wire        clk,
    input  wire        we3,
    input  wire [4:0]  a1, a2, a3,
    input  wire [31:0] wd3,
    output wire [31:0] rd1, rd2
);
    reg [31:0] rf [31:0];

    // Ghi đồng bộ theo cạnh lên xung nhịp (slide 23)
    always @(posedge clk) begin
        if (we3) rf[a3] <= wd3;
    end

    // Đọc bất đồng bộ; Thanh ghi $0 luôn giữ giá trị 0 (slide 23)
    assign rd1 = (a1 != 5'b0) ? rf[a1] : 32'b0;
    assign rd2 = (a2 != 5'b0) ? rf[a2] : 32'b0;
endmodule