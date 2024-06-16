`include "alu.v"
`timescale 1ns/1ns



module test;
    reg [2 : 0] opcodeTest;
    reg [`N - 1 : 0]firstOperandTest, secondOperandTest;
    wire[`N - 1 : 0] resultTest;
    wire carryOut;
    ALU DUT(
        .OPCODE(opcodeTest),
        .a(firstOperandTest),
        .b(secondOperandTest),
        .cOut(carryOut),
        .s(resultTest)
    );

    wire result;
    integer opcode, firstOperand, secondOperand;
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);
        for(opcode = 0;opcode < 8;opcode = opcode + 1)begin
            for(firstOperand = 0;firstOperand < 8;firstOperand = firstOperand + 1)begin
                for(secondOperand = 0;secondOperand < 8;secondOperand = secondOperand + 1)begin
                    opcodeTest = opcode; firstOperandTest = firstOperand; secondOperandTest = secondOperand;
                    opcodeTest = opcode;
                    #10;
                end
            end
        end
        #10
        opcodeTest = 0;
        firstOperandTest = 32767;
        secondOperandTest = 5;
        #10
        $finish;
    end

endmodule