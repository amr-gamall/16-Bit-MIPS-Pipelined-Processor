module registerFile (
    input rst, clk, writeEnable,
    input [31 : 0] dataWrite, 
    input [4 : 0] addressWrite, addressA, addressB,
    output reg [31 : 0] dataA, dataB
);
    integer  i;
    reg [31 : 0] registerFileData [31 : 0];

    always @(posedge clk, posedge rst) begin
        if(rst)
            for(i = 0; i < 32; i++)
                registerFileData[i] <= 0;
        else if(writeEnable)
            registerFileData[addressWrite] = dataWrite;
    end


    
    always@(*)begin
        dataA = registerFileData[addressA];
        dataB = registerFileData[addressB];
    end

endmodule