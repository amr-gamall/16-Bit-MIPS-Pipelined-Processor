`include "Data_Memory.v"

module tb;

    reg  [31 : 0] address, dataWrite;
    wire [31 : 0] dataOutput;
    reg writeEnable, clk, rst;         


    dataMemory dut(.address(address), .writeEnable(writeEnable), .dataWrite(dataWrite), .dataOutput(dataOutput), .rst(rst), .clk(clk));

    always #10 clk ^= 1;

    initial begin
        clk = 0; // init clk
        $dumpfile("testbench.vcd");
        $dumpvars(0, tb);

        // resetting

        rst = 1;
        #10
        rst = 0;

        // writing and reading

        @(negedge clk);
        dataWrite = 8'h55;
        address = 9;
        writeEnable = 1;
        
        @(negedge clk);
        dataWrite = 4'b1111;
        address = 10;
        
        @(negedge clk);
        dataWrite = 4'b1100;
        address = 11;

        writeEnable = 0;


        #50


        $finish;

    end

endmodule