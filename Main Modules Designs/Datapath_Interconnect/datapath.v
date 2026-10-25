`timescale 1ns / 1ps

module datapath (
    input  wire        clk,
    input  wire        reset,

    // Tín hiệu điều khiển từ Control Unit
    input  wire        memtoreg,
    input  wire        pcsrc,
    input  wire        alusrc,
    input  wire        regdst,
    input  wire        regwrite,
    input  wire        jump,
    input  wire [2:0]  alucontrol,

    // Cờ trạng thái trả về cho Control Unit
    output wire        zero,

    // Giao tiếp với Instruction Memory
    output wire [31:0] pc,
    input  wire [31:0] instr,

    // Giao tiếp với Data Memory
    output wire [31:0] aluresult,
    output wire [31:0] writedata,
    input  wire [31:0] readdata
);

    // =========================================================
    // 1. Khai báo các đường dây nội bộ (Internal Interconnect)
    // =========================================================
    wire [4:0]  writereg;
    wire [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
    wire [31:0] signimm, signimmsh;
    wire [31:0] srca, srcb;
    wire [31:0] result;
    wire [31:0] pcjump;

    // =========================================================
    // 2. Logic cập nhật Program Counter (PC Logic)
    // =========================================================
    // Thanh ghi PC (slide 47, 53)
    flopr #(32) pcreg (
        .clk(clk),
        .reset(reset),
        .d(pcnext),
        .q(pc)
    );

    // Bộ cộng tính PC + 4 (slide 11, 59)
    adder pcadd1 (
        .a(pc),
        .b(32'd4),
        .y(pcplus4)
    );

    // Dịch trái 2 bit cho trường Sign-extended offset (slide 41, 62)
    sl2 immsh (
        .a(signimm),
        .y(signimmsh)
    );

    // Bộ cộng tính địa chỉ nhánh PCBranch = (PC + 4) + (SignImm << 2) (slide 41, 62)
    adder pcadd2 (
        .a(pcplus4),
        .b(signimmsh),
        .y(pcbranch)
    );

    // MUX chọn giữa PCPlus4 và PCBranch qua tín hiệu pcsrc (slide 62, 63)
    mux2 #(32) pcbrmux (
        .d0(pcplus4),
        .d1(pcbranch),
        .s(pcsrc),
        .y(pcnextbr)
    );

    // Ghép địa chỉ JTA: {(PC+4)[31:28], instr[25:0], 2'b00} (slide 48, 72)
    assign pcjump = {pcplus4[31:28], instr[25:0], 2'b00};

    // MUX chọn giữa địa chỉ tuần tự/nhánh và địa chỉ Jump (slide 72)
    mux2 #(32) pcmux (
        .d0(pcnextbr),
        .d1(pcjump),
        .s(jump),
        .y(pcnext)
    );

    // =========================================================
    // 3. Logic Tập thanh ghi (Register File Logic)
    // =========================================================
    // Khối Register File: 2 cổng đọc bất đồng bộ, 1 cổng ghi đồng bộ (slide 17, 23)
    regfile rf (
        .clk(clk),
        .we3(regwrite),
        .a1(instr[25:21]),
        .a2(instr[20:16]),
        .a3(writereg),
        .wd3(result),
        .rd1(srca),
        .rd2(writedata)
    );

    // MUX chọn thanh ghi ghi: rt (instr[20:16]) hay rd (instr[15:11]) (slide 61, 63)
    mux2 #(5) wrmux (
        .d0(instr[20:16]),
        .d1(instr[15:11]),
        .s(regdst),
        .y(writereg)
    );

    // MUX chọn dữ liệu ghi ngược Result: từ ALUResult hay từ RAM (slide 58, 63)
    mux2 #(32) resmux (
        .d0(aluresult),
        .d1(readdata),
        .s(memtoreg),
        .y(result)
    );

    // =========================================================
    // 4. Mạch mở rộng dấu (Sign Extension)
    // =========================================================
    // Mở rộng 16-bit hằng số thành 32-bit có dấu (slide 50, 56)
    signext se (
        .a(instr[15:0]),
        .y(signimm)
    );

    // =========================================================
    // 5. Logic Khối tính toán số học & logic (ALU Logic)
    // =========================================================
    // MUX chọn toán hạng B: từ thanh ghi (writedata) hay từ hằng số (signimm) (slide 57, 63)
    mux2 #(32) srcbmux (
        .d0(writedata),
        .d1(signimm),
        .s(alusrc),
        .y(srcb)
    );

    // Khối ALU thực thi các phép toán (slide 24, 25, 65, 66)
    alu alu_inst (
        .a(srca),
        .b(srcb),
        .alucontrol(alucontrol),
        .result(aluresult),
        .zero(zero)
    );

endmodule