
module oneBAdder (
    input a, input b, input cIn, output s, output cOut
);
assign s = a ^ b ^ cIn;
assign cOut = (a & b) | (cIn & (a ^ b));
endmodule