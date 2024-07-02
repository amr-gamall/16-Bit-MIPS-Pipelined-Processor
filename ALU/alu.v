
module ALU(
    input      [31 : 0] SrcA, SrcB,
    input      [2 : 0] ALUControl,
    output reg [31 : 0]ALUResult);

localparam 
add = 3'b010,
sub = 3'b110,
andd= 3'b000,
orr = 3'b001, // ignore for now
slt = 3'b111; // ignore for now

always @(*) begin
    case (ALUControl)
        add :  ALUResult = SrcA + SrcB;
        sub :  ALUResult = SrcA - SrcB;
        andd:  ALUResult = SrcA & SrcB;
        default: ALUResult = 0;
    endcase
end


endmodule



