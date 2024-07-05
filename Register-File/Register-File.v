module registerFile (
    input rst, clk, writeEnable,
    input [31 : 0] dataWrite, 
    input [4 : 0] addressWrite, addressA, addressB,
    output reg [31 : 0] dataA, dataB,

    // for testing

    input [4 : 0]addressTest, 
    output reg [31 : 0] outputTest
);
    integer  i;
    reg [31 : 0] registerFileData [31 : 0];

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            for(i = 0; i < 32&&i!=5'b10100; i++)
                registerFileData[i] <= 0;
            registerFileData[5'b10100] = 10;
        end
        else if(writeEnable)
            registerFileData[addressWrite] = dataWrite;
    end



    always@(*)begin
        outputTest = registerFileData[addressTest];
        dataA = registerFileData[addressA];
        dataB = registerFileData[addressB];
    end

endmodule