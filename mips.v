`include "control_unit.v"
`include "data_path.v"

module MIPS(input clk, rst,
            input [4 : 0] addressTest);

    wire [5 : 0] opcode, funct;
    wire         PCEn, IorD, Memwrite, IRWrite, RegDst, MemtoReg, RegWrite, ALUsrcA,PCsrc;
    wire [1 : 0] ALUsrcB;
    wire [2 : 0] ALUControl;

    controller cu(.clk(clk), .rst(rst), .opcode(opcode), .funct(funct), .PCEn(PCEn), .IorD(IorD), 
                .Memwrite(Memwrite), .IRWrite(IRWrite), .RegDst(RegDst), .MemtoReg(MemtoReg), .RegWrite(RegWrite),
                .ALUsrcA(ALUsrcA),.PCsrc(PCsrc), .ALUsrcB(ALUsrcB), .ALUControl(ALUControl));

    dataPath   dp(.rst(rst), .clk(clk), .PCEn(PCEn), .IorD(IorD), .Memwrite(Memwrite),
                  .IRWrite(IRWrite), . RegDst( RegDst), .MemtoReg(MemtoReg), .RegWrite(RegWrite),
                  .ALUsrcA(ALUsrcA), .ALUsrcB(ALUsrcB), . ALUControl( ALUControl), .PCsrc(PCsrc), 
                  .addressTest(addressTest), .opcode(opcode), .funct(funct)); 
endmodule