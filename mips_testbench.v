`include "mips.v"
`timescale 1ns/1ps
module tb;

    reg clk, rst;
    reg [4 : 0] addressTest;

    MIPS d(clk, rst, addressTest);

    always #10 clk ^= 1;

    initial begin
        $dumpfile("mips_testbench.vcd");
        $dumpvars(0, tb);
        clk = 0;

        rst = 1;
        #5;
        rst = 0;

        addressTest = 10;
        #300;
        $finish;
    end

endmodule