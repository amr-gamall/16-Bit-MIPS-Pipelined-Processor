`include "alu.v"
`timescale 1ns/1ps
module tb;

    reg[31 : 0] a, b;
    reg [2 : 0] c;

    ALU dut(.SrcA(a), .SrcB(b), .ALUControl(c));


    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0, tb);

        a = 2;
        b = 3;
        c = 2;
        #5;
        a = 3;
        b = 5;
        c = 6;
        #10;

    end

endmodule