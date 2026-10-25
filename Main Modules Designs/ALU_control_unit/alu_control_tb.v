Verilog
`timescale 1ns / 1ps

module alu_control_tb;

    reg [1:0] aluOp;
    reg [5:0] funct;
    wire [3:0] aluControl;

    ALUControlUnit uut (
        .aluOp(aluOp),
        .funct(funct),
        .aluControl(aluControl)
    );

    initial begin
        $dumpfile("alu_control.vcd");
        $dumpvars(0, alu_control_tb);

        $display("Time\t ALUOp\t Funct\t | ALUControl\t (Expect)");

        aluOp = 2'b00; funct = 6'bxxxxxx; #10;
        $display("%0t\t %b\t %b\t | %b\t\t (0010 - ADD)", $time, aluOp, funct, aluControl);

        aluOp = 2'b01; funct = 6'bxxxxxx; #10;
        $display("%0t\t %b\t %b\t | %b\t\t (0110 - SUB)", $time, aluOp, funct, aluControl);

        aluOp = 2'b10; funct = 6'b100000; #10;
        $display("%0t\t %b\t %b\t | %b\t\t (0010 - ADD)", $time, aluOp, funct, aluControl);

        aluOp = 2'b10; funct = 6'b100101; #10;
        $display("%0t\t %b\t %b\t | %b\t\t (0001 - OR)", $time, aluOp, funct, aluControl);

        aluOp = 2'b10; funct = 6'b101010; #10;
        $display("%0t\t %b\t %b\t | %b\t\t (0111 - SLT)", $time, aluOp, funct, aluControl);

        #10;
        $finish;
    end

endmodule