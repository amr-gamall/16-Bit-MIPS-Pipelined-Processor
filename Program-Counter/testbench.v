`include "Program_Counter.v"

module tb;

    reg rst, clk;
    reg [31 : 0] dataInput;


    programCounter dut(.clk(clk), .dataInput(dataInput), .rst(rst));

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
        dataInput = 4'b1010;
        
        @(negedge clk);
        dataInput = 4'b1111;

        #50


        $finish;

    end

endmodule