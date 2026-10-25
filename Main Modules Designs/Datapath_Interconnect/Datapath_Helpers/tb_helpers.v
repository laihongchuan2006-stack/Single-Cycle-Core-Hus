`timescale 1ns / 1ps

module tb_helpers;

    // Tín hiệu đồng hồ và điều khiển
    reg clk;
    reg reset;

    // Tín hiệu kiểm thử MUX2
    reg  [31:0] mux_d0, mux_d1;
    reg         mux_s;
    wire [31:0] mux_y;

    // Tín hiệu kiểm thử Adder
    reg  [31:0] add_a, add_b;
    wire [31:0] add_y;

    // Tín hiệu kiểm thử SignExt
    reg  [15:0] se_a;
    wire [31:0] se_y;

    // Tín hiệu kiểm thử Shift Left 2
    reg  [31:0] sl_a;
    wire [31:0] sl_y;

    // Tín hiệu kiểm thử Flopr
    reg  [31:0] d;
    wire [31:0] q;

    // Instantiate các module cần kiểm tra
    mux2 #(32) dut_mux (.d0(mux_d0), .d1(mux_d1), .s(mux_s), .y(mux_y));
    adder      dut_add (.a(add_a), .b(add_b), .y(add_y));
    signext    dut_se  (.a(se_a), .y(se_y));
    sl2        dut_sl  (.a(sl_a), .y(sl_y));
    flopr #(32) dut_ff (.clk(clk), .reset(reset), .d(d), .q(q));

    // Bộ tạo xung Clock (chu kỳ 10ns)
    always #5 clk = ~clk;

    initial begin
        // Khởi tạo file xuất dạng sóng xem trên GTKWave
        $dumpfile("helpers_waveform.vcd");
        $dumpvars(0, tb_helpers);

        clk = 0;
        reset = 1;
        d = 32'h0;
        mux_d0 = 32'hAAAA_AAAA;
        mux_d1 = 32'h5555_5555;
        mux_s = 0;
        add_a = 32'd0;
        add_b = 32'd4;
        se_a = 16'h0000;
        sl_a = 32'd0;

        #12; // Thả reset
        reset = 0;

        // 1. Kiểm tra MUX2
        #5;
        mux_s = 0; // Kì vọng mux_y = 32'hAAAA_AAAA
        #5;
        mux_s = 1; // Kì vọng mux_y = 32'h5555_5555

        // 2. Kiểm tra Adder (PC + 4 và Offset)
        #5;
        add_a = 32'd100;
        add_b = 32'd4;   // Kì vọng add_y = 104

        // 3. Kiểm tra Sign Extension (Số dương và số âm bù 2)
        #5;
        se_a = 16'h000A; // Số dương +10 -> Kì vọng se_y = 32'h0000_000A
        #5;
        se_a = 16'hFFF4; // Số âm -12 (slide 16) -> Kì vọng se_y = 32'hFFFF_FFF4

        // 4. Kiểm tra Shift Left 2
        #5;
        sl_a = 32'd3;    // Dịch trái 2 bit (3 * 4) -> Kì vọng sl_y = 12

        // 5. Kiểm tra Thanh ghi PC (Flopr)
        #5;
        d = 32'h0040_0004; // Nạp địa chỉ mới
        #10;               // Chờ cạnh lên CLK -> Kì vọng q = 32'h0040_0004
        d = 32'h0040_0008;
        #10;               // Kì vọng q = 32'h0040_0008

        #20;
        $display(">> TAT CA CAC TEST CHO DATAPATH HELPERS DA HOAN TAT THANH CONG! <<");
        $finish;
    end

endmodule