module controller (
    input [5 : 0] opcode, funct,
    input         rst, clk,

    // controls from l to r
    output reg    PCEn, IorD, Memwrite, IRWrite, 
                  RegDst, MemtoReg, RegWrite, ALUsrcA,
    output reg [1 : 0] ALUsrcB, 
    output reg [2 : 0] ALUControl,
    output reg PCsrc
);
    // opcodes
    localparam rType = 6'b000000,
               lw    = 6'b100011,
               sw    = 6'b101011,
               beq   = 6'b000100;

    // funct fields
    localparam add = 6'b100000,
               sub = 6'b100010;

    // states
    localparam fetch     = 0,
               decode    = 1,
               execute1  = 2,
               execute2  = 3,
               execute3  = 4, // at most 3 cycles
               writeBack = 5;
    

    reg [2 : 0] currState, nextState;
    always @(posedge clk, posedge rst)begin
        if(rst)currState <= 0;
        else currState <= nextState;
    end

    always @(*) begin
        // next state compute, edit for all instructions
        nextState = currState + 1;

        // output compute
        casez (currState)
            fetch : begin
                // writes
                Memwrite  = 0;
                RegWrite  = 0;
                IRWrite   = 1;
                PCEn      = 1;
                // muxes
                IorD      = 0;
                RegDst    = 0;
                MemtoReg  = 0;
                ALUsrcA   = 0;
                ALUsrcB   = 1;
                ALUControl= 2;
                PCsrc     = 0;
            end 

            decode : begin
                // writes
                Memwrite  = 0;
                RegWrite  = 0;
                IRWrite   = 0;
                PCEn      = 0;
            end

            execute1: begin
                case (opcode)
                    lw : begin
                        // writes
                        Memwrite  = 0;
                        RegWrite  = 0;
                        IRWrite   = 0;
                        PCEn      = 0;
                        // muxes
                        IorD      = 0;
                        RegDst    = 0;
                        MemtoReg  = 0;
                        ALUsrcA   = 1;
                        ALUsrcB   = 0;
                        ALUControl= 2;
                        PCsrc     = 0;
                    end 
                    default: PCsrc = 0; // invalid instruction
                endcase
            end

            execute2: begin
                case (opcode)
                        lw: begin
                            // writes
                            Memwrite  = 0;
                            RegWrite  = 0;
                            IRWrite   = 0;
                            PCEn      = 0;
                            // muxes
                            IorD      = 1;
                            RegDst    = 0;
                            MemtoReg  = 0;
                            ALUsrcA   = 0;
                            ALUsrcB   = 0;
                            ALUControl= 0;
                            PCsrc     = 0;
                        end
                    default: PCsrc = 0;
                endcase
            end

            execute3: begin
                case (opcode)
                    lw:begin
                        // writes
                        Memwrite  = 0;
                        RegWrite  = 1;
                        IRWrite   = 0;
                        PCEn      = 0;
                        // muxes
                        IorD      = 0;
                        RegDst    = 0;
                        MemtoReg  = 1;
                        ALUsrcA   = 0;
                        ALUsrcB   = 0;
                        ALUControl= 0;
                        PCsrc     = 0;
                    end
                    default: PCsrc = 0;
                endcase
            end            
            default: PCsrc = 0;
        endcase        
    end

endmodule


// TODO insert the don't cares instead of the dumb shit you did.

/*
    // writes
    Memwrite  = 0;
    RegWrite  = 0;
    IRWrite   = 1;
    PCEn      = 1;
    // muxes
    IorD      = 0;
    RegDst    = 0;
    MemtoReg  = 0;
    ALUsrcA   = 0;
    ALUsrcB   = 1;
    ALUControl= 2;
    PCsrc     = 0;
*/