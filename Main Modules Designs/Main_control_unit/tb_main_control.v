`timescale 1ns / 1ps

module tb_main_control;

    reg  [5:0] op;
    wire       reg_write;
    wire       reg_dst;
    wire       alu_src;
    wire       branch;
    wire       mem_write;
    wire       mem_to_reg;
    wire [1:0] alu_op;
    wire       jump;

    // Khởi tạo module uut
    main_control uut (
        .op(op),
        .reg_write(reg_write),
        .reg_dst(reg_dst),
        .alu_src(alu_src),
        .branch(branch),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .jump(jump)
    );

    initial begin
        // Tạo file VCD để mở bằng GTKWave
        $dumpfile("main_control.vcd");
        $dumpvars(0, tb_main_control);

        $display("--- BAT DAU TESTBENCH MAIN CONTROL ---");

        // Test 1: R-type
        op = 6'b000000; #10;
        if ({reg_write, reg_dst, alu_src, branch, mem_write, mem_to_reg, alu_op, jump} === 9'b1_1_0_0_0_0_10_0)
            $display("[PASS] R-type decoding dung");
        else
            $display("[FAIL] R-type decoding sai");

        // Test 2: lw
        op = 6'b100011; #10;
        if ({reg_write, reg_dst, alu_src, branch, mem_write, mem_to_reg, alu_op, jump} === 9'b1_0_1_0_0_1_00_0)
            $display("[PASS] lw decoding dung");
        else
            $display("[FAIL] lw decoding sai");

        // Test 3: sw
        op = 6'b101011; #10;
        if ({reg_write, mem_write, alu_src, alu_op, jump} === 6'b0_1_1_00_0)
            $display("[PASS] sw decoding dung");
        else
            $display("[FAIL] sw decoding sai");

        // Test 4: beq
        op = 6'b000100; #10;
        if ({reg_write, branch, alu_src, mem_write, alu_op, jump} === 7'b0_1_0_0_01_0)
            $display("[PASS] beq decoding dung");
        else
            $display("[FAIL] beq decoding sai");

        // Test 5: addi
        op = 6'b001000; #10;
        if ({reg_write, reg_dst, alu_src, branch, mem_write, mem_to_reg, alu_op, jump} === 9'b1_0_1_0_0_0_00_0)
            $display("[PASS] addi decoding dung");
        else
            $display("[FAIL] addi decoding sai");

        // Test 6: j (Jump)
        op = 6'b000010; #10;
        if (jump === 1'b1 && reg_write === 1'b0 && mem_write === 1'b0)
            $display("[PASS] j decoding dung");
        else
            $display("[FAIL] j decoding sai");

        $display("--- HOAN THANH MO PHONG ---");
        $finish;
    end

endmodule