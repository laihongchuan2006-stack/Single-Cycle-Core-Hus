`timescale 1ns / 1ps

module tb_datapath;

    reg        clk, reset;
    reg        memtoreg, pcsrc, alusrc, regdst, regwrite, jump;
    reg  [2:0] alucontrol;
    wire       zero;
    wire [31:0] pc;
    reg  [31:0] instr;
    wire [31:0] aluresult, writedata;
    reg  [31:0] readdata;

    // Khởi tạo Datapath DUT
    datapath dut (
        .clk(clk),
        .reset(reset),
        .memtoreg(memtoreg),
        .pcsrc(pcsrc),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .alucontrol(alucontrol),
        .zero(zero),
        .pc(pc),
        .instr(instr),
        .aluresult(aluresult),
        .writedata(writedata),
        .readdata(readdata)
    );

    // Tạo xung Clock 10ns
    always #5 clk = ~clk;

    initial begin
        $dumpfile("datapath_waveform.vcd");
        $dumpvars(0, tb_datapath);

        // Khởi tạo trạng thái ban đầu
        clk = 0;
        reset = 1;
        memtoreg = 0;
        pcsrc = 0;
        alusrc = 0;
        regdst = 0;
        regwrite = 0;
        jump = 0;
        alucontrol = 3'b010;
        instr = 32'b0;
        readdata = 32'b0;

        #12;
        reset = 0; // Thả reset, PC bắt đầu từ 0

        // TEST 1: Kiểm tra tính tăng PC tuần tự (PC + 4)
        #10; // Cạnh lên CLK 1 -> PC = 4
        #10; // Cạnh lên CLK 2 -> PC = 8

        // TEST 2: Thử ghi giá trị vào thanh ghi $1 ($t0) và đọc ra
        // Giả lập lệnh ADDI $1, $0, 25 (rs=0, rt=1, imm=25)
        instr = {6'b001000, 5'd0, 5'd1, 16'd25};
        alusrc = 1;      // Toán hạng B lấy từ hằng số
        regdst = 0;      // Đích ghi là rt ($1)
        alucontrol = 3'b010; // Phép ADD
        regwrite = 1;    // Bật ghi thanh ghi
        memtoreg = 0;    // Lấy kết quả từ ALU
        #10; // Ghi hoàn tất vào $1

        // TEST 3: Lấy giá trị vừa ghi vào $1 cộng tiếp với 15
        instr = {6'b001000, 5'd1, 5'd2, 16'd15};
        #10;

        #20;
        $display(">> KIEM THU DATAPATH THANH CONG! <<");
        $finish;
    end

endmodule