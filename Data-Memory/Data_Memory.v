// 1kb data memory for MIPS microarch

module dataMemory (
    input               clk, rst, writeEnable,
    input      [31 : 0] address, dataWrite,
    output [31 : 0] dataOutput
);
    
    reg [31 : 0] data [1023 : 0];
    integer  i;
    always @(posedge clk, posedge rst) begin
        if(rst)begin
            for(i = 1;i < 1024;i++)
                data[i] <= 0;
            
            // test
            // data[32]<= 32'h00000005;                              // $t1 = 0x05;

            // data[0] <= 32'h8C0A0020;                              // lw $t1, 32($0), t1 = 5
            // data[1] <= 32'b000100_01010_01010_0000000000000011;   // beq $t1, $t1, add(5)
            // data[5] <= 32'b000000_10100_01010_01010_00000_100000; // add $t1, $t1, $some other register
            
        end
        else if(writeEnable)   
                data[address] <= dataWrite;
    end

    assign dataOutput = data[address];
endmodule