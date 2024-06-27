module programCounter (
    input clk, rst,
    input [31 : 0] dataInput,
    output reg [31 : 0] dataOutput
);
    always @(posedge clk, posedge rst) begin
        if(rst)
            dataOutput <= 0;
        else
            dataOutput <=  dataInput;
    end



endmodule