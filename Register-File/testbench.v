`include "Register-File.v"

module tb;

    reg  [31 : 0] addressA, addressB,addressWrite, dataWrite;
    reg writeEnable, clk, rst;         
    wire [31 : 0] dataA, dataB;


    registerFile dut(.addressA(addressA), .addressB(addressB), .addressWrite(addressWrite), .writeEnable(writeEnable), .dataWrite(dataWrite), .dataA(dataA), .dataB(dataB), .rst(rst), .clk(clk));

    always #10 clk ^= 1;

    initial begin
        clk = 0; // init clk
        $dumpfile("testbench.vcd");
        $dumpvars(0, tb);

        // resetting

        rst = 1;
        #10
        rst = 0;

        addressA = 10;
        addressB = 11;

        // writing

        @(negedge clk);
        dataWrite = 8'h55;
        addressWrite = 9;
        writeEnable = 1;
        
        @(negedge clk);
        dataWrite = 4'b1111;
        addressWrite = 10;
        
        @(negedge clk);
        dataWrite = 4'b1100;
        addressWrite = 11;

        writeEnable = 0;

        //reading
        @(negedge clk);
        addressA = 9;
        addressB = 10;
        
        @(negedge clk);
        addressA = 10;
        addressB = 9;
        
        @(negedge clk);
        addressA = 10;
        addressB = 11;

        #50


        $finish;

    end

endmodule