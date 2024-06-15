`include "aluSingleB.v"
`timescale 1ns/1ns

module testbench;
    reg a, b, ci;
    wire s, co;
    oneBAdder testOneBAdder(
        .s(s),
        .cOut(co),
        .a(a),
        .b(b),
        .cIn(ci)
    );
    integer i, j, k;
    initial begin
        $dumpfile("testOneBAdder.vcd");
        $dumpvars(0, testbench);
        for(i = 0 ;i <= 1;i = i + 1)begin
            for(j = 0 ;j <= 1;j = j + 1)begin
                for(k = 0 ;k <= 1;k = k + 1)begin
                    a = i; b = j; ci = k; 
                    #10;
                end
            end
        end
        $finish;
    end

endmodule
