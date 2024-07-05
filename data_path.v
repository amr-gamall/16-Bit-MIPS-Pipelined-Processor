`include "Data-Memory/Data_Memory.v"
`include "ALU/alu.v"
`include "Register-File/Register-File.v"
`include "Program-Counter/Program_Counter.v"

module dataPath(
    input         rst, clk,
    // controls from l to r
    input         PCEn, IorD, Memwrite, IRWrite, 
                  RegDst, MemtoReg, RegWrite, ALUsrcA,
    input [1 : 0] ALUsrcB, 
    input [2 : 0] ALUControl,
    input PCsrc,
    // for testing register file
    input [4 : 0] addressTest,
    output [31 : 0] outputTest,
    // for controller
    output [5 : 0] opcode, funct
    );

    //controller out
    assign opcode = Instr[31 : 26];
    assign funct  = Instr[5 : 0];

    // SignImm
    wire [31 : 0] SignImm;
    assign SignImm = {Instr[15]?16'hffff : 16'h0000 , Instr[15 : 0]};

    // data/instruction memory ins and outs
    wire [31 : 0] Adr, dataOutput;
    reg [31 : 0] Instr, Data;
    always @(posedge clk)
        if(IRWrite)
            Instr <= dataOutput;
    always @(posedge clk)
        Data  <= dataOutput;
    assign Adr = IorD?ALUOut:PC;
    dataMemory m(.clk(clk), .rst(rst), .writeEnable(Memwrite), .address(Adr), .dataWrite(B), .dataOutput(dataOutput));

    
    // ALU ins and outs
    wire[31 : 0] ALUResult;
    reg [31 : 0] SrcA, SrcB, ALUOut;
    always @(posedge clk)ALUOut <= ALUResult;
    ALU a(.SrcA(SrcA), .SrcB(SrcB), .ALUControl(ALUControl), .ALUResult(ALUResult));
    always @(*) begin
        case (ALUsrcA)
            0:SrcA = PC;
            1:SrcA = A;
            default: SrcA = 0;
        endcase
        case (ALUsrcB)
            0:SrcB = B;
            1:SrcB = 1; // for simplicty it's word addressable
            2:SrcB = SignImm;
            3:SrcB = SignImm << 2;
            default: SrcB = 0;
        endcase
    end
    
    // PC ins and outs
    wire [31 : 0] PCPrime, PC;
    assign PCPrime = PCsrc ? ALUOut : ALUResult;
    programCounter p(.en(PCEn), .rst(rst), .dataInput(PCPrime), .clk(clk), .dataOutput(PC));

    // RF ins and outs
    wire [31 : 0]RwriteData;
    wire [4 : 0] Radr;
    assign Radr = RegDst?Instr[15 : 11] : Instr[20 : 16];
    assign RwriteData = MemtoReg?Data : ALUOut;
    wire [31 : 0] atmp, btmp;
    reg [31 : 0] A, B;
    always @(posedge clk)begin
        A<=atmp;
        B<=btmp;
    end
    registerFile r(.clk(clk), .rst(rst), .writeEnable(RegWrite), .dataWrite(RwriteData),
                   .addressWrite(Radr), .addressA(Instr[25 : 21]), .addressB(Instr[20 : 16]),
                   .dataA(atmp), .dataB(btmp), .addressTest(addressTest),
                    .outputTest(outputTest));
endmodule



/** TODO : maybe unify MemtoReg and RegDst as one line
 ** Maybe add rst to the non-architectural registers, although it's unnecessary. 
 ** the only register that needs rst is PC. 
 ** Change the data/instruction memory to byte addressable and concatenate the bytes.
**/
