// 1kb data memory for MIPS microarch

module dataMemory (
    input               clk, rst, writeEnable,
    input      [31 : 0] address, dataWrite,
    output reg [31 : 0] dataOutput
);
    
    reg [31 : 0] data [1023 : 0];
    integer  i;
    always @(posedge clk, posedge rst) begin
        if(rst)
            for(i = 0;i < 1024;i++)
                data[i] <= 0;
        else if(writeEnable)   
                data[address] <= dataWrite;
    end


    always@(*)begin
        dataOutput = data[address];
    end
endmodule