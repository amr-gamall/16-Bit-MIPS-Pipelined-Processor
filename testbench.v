`include "data_path.v"
`timescale 1ns/1ps

module tb;

    reg rst, clk, PCEn, IorD, Memwrite, IRWrite, RegDst, MemtoReg, RegWrite, ALUsrcA, PCsrc;
    reg [1 : 0] ALUsrcB;
    reg [2 : 0] ALUControl;

    // clock
    
    always #10 clk ^= 1;
    
    // data path

    reg [4 : 0] addressTest;
    wire [31 : 0] outputTest;
    dataPath dp(rst, clk, PCEn, IorD, Memwrite, 
            IRWrite, RegDst, MemtoReg, RegWrite, ALUsrcA,
            ALUsrcB, ALUControl, PCsrc, addressTest, outputTest);


    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0, tb);

        clk = 0;

        // resetting pc

        rst = 1;
        #5;
        rst = 0;

        // set all to 0 for simplicity

        addressTest = 10;
        Memwrite  = 0;
        RegWrite  = 0;
        IRWrite   = 0;
        PCEn      = 0;
        IorD      = 0;
        RegDst    = 0;
        MemtoReg  = 0;
        ALUsrcA   = 0;
        ALUsrcB   = 0;
        ALUControl=0;
        PCsrc     = 0;


        // testing lw $t1, 32($0)
        /*
        fetch:
            writes: IRWrite & PCEn
            Muxes : srcA = 0, srcB = 1, IorD = 0, PCsrc = 0, ALUControl = 2;
        */

        @(negedge clk);
        IRWrite = 1; PCEn = 1;
        ALUsrcA    = 0; ALUsrcB = 1;
        IorD    = 0; PCsrc= 0;
        ALUControl = 2;
        
        /*
        decode: 
            Nothing just wait
        */

        @(negedge clk);
        // just resetting what I done in fetch
        ALUsrcB = 0;
        IRWrite = 0; PCEn = 0;

        /*
            Execute:
                clk0 => compute address
                clk1 => get the address from mem
                clk2 => write the address to regfile
        */

        //clk0
        @(negedge clk);
        ALUsrcA = 1; ALUsrcB = 2; ALUControl = 2;

        //clk1
        @(negedge clk);
        IorD = 1;

        //clk2
        @(negedge clk);
        MemtoReg = 1; RegWrite = 1; RegDst = 0;


        // next instruction
        @(negedge clk);
        addressTest = 10;
        Memwrite  = 0;
        RegWrite  = 0;
        IRWrite   = 0;
        PCEn      = 0;
        IorD      = 0;
        RegDst    = 0;
        MemtoReg  = 0;
        ALUsrcA   = 0;
        ALUsrcB   = 0;
        ALUControl= 0;
        PCsrc     = 0;
        // mem[32] = 5
        // reg[20] = 10
        // lw  $10, mem[32]
        // add $10, $10, $20; 


        // fetch r instruction and write new PC
        @(negedge clk);
        IorD = 0; PCEn = 1; ALUsrcA = 0; ALUsrcB = 1; IRWrite = 1; ALUControl = 2;
        PCsrc= 0;

        // decode r instruction
        @(negedge clk);
        ALUsrcB = 0;
        IRWrite = 0; PCEn = 0;
        //nothing       

        // execute
        @(negedge clk);
        ALUsrcA = 1; ALUsrcB = 0; ALUControl = 2;

        // write back
        @(negedge clk);
        RegDst = 1; MemtoReg = 0; RegWrite = 1;


        #150;
        $finish;

    end


endmodule