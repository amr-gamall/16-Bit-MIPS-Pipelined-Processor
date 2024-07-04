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
            data[0] <= 32'h8C0A0020; // lw $t1, 32($0)
            data[32]<= 32'b01010101010101010101010101010101;
        end
        else if(writeEnable)   
                data[address] <= dataWrite;
    end


    assign dataOutput = data[address];
endmodule