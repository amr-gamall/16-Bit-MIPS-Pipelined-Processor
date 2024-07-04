`include "data_path.v"
module tb;
    reg rst, clk,
    reg PCEn, IorD, Memwrite, IRWrite, RegDst, MemtoReg, RegWrite, ALUsrcA;
    reg [1 : 0] ALUsrcB;
    reg [2 : 0] ALUControl,
    reg PCsrc;

    // clock
    
    reg clk;
    always #10 clk ^= 1;



    // data path
    dataPath dp(rst, clk, PCEn, IorD, Memwrite, 
            IRWrite, RegDst, MemtoReg, RegWrite, ALUsrcA
            ALUsrcB, ALUControl, PCsrc);


    // writing instructions to memory

    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0, tb);

        clk = 0;
    end

endmodule