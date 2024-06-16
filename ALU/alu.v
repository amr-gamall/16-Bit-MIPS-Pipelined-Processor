`include "oneBAdder/singleBAdder.v"
`define N 16 // I don't like parameters

/*
+--------+--------+
| OPCODE | Result |
+--------+--------+
| 0      | a + b  |
| 1      | a - b  |
| 2      | a & b  |
| 3      | a | b  |
| 4      | a ^ b  |
| 5      | a > b  |
| 6      | a << 1 |
| 7      | a >> 1 |
+--------+--------+
*/

module ALU(input [2 : 0] OPCODE, input [`N - 1 : 0]a, input [`N - 1 : 0] b, output reg [`N - 1 : 0] s, output cOut, output ovf);

    wire[`N - 1 : 0] andOut, orOut, xorOut, shiftrOut, shiftlOut, gtOut, addOut;
    wire [`N : 0] tmp_carry; // 0 1 .. N, tmp_carry[N] is cout.
    wire caryyInLastAdder;

    assign ovf = tmp_carry[`N] ^ tmp_carry[`N - 1];
    assign tmp_carry[0] = OPCODE[0]; // OPCODE & 0x1
    assign cOut = tmp_carry[`N]; 

    genvar i;
    generate
        for(i = 0;i < `N;i = i + 1)begin : NbitAdder
            oneBAdder aa(
                .a(a[i]),
                .b(b[i] ^ OPCODE[0]), 
                .cIn(tmp_carry[i]),
                .cOut(tmp_carry[i + 1]),
                .s(addOut[i])
            );
        end
    endgenerate
    assign andOut = a & b;
    assign orOut = a | b;
    assign xorOut = a ^ b;
    assign shiftrOut = a >> 1;
    assign shiftlOut = a << 1;
    assign gtOut = a > b ? 1 : 0;
    always @(*) begin
        case (OPCODE)
            0, 1: s = addOut;
            2   : s = andOut;
            3   : s = orOut;
            4   : s = xorOut;
            5   : s = gtOut;
            6   : s = shiftlOut;
            7   : s = shiftrOut;
            default : s = 0;
        endcase
    end

endmodule



