module controller (
    input [5 : 0] opcode, funct,
    input         rst, clk,
    input         zero,
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
    localparam sub = 6'b100000,
               add = 6'b100010;

    // states
    localparam fetch     = 0,
               decode    = 1,
               execute1  = 2,
               execute2  = 3,
               execute3  = 4, // at most 3 cycles
               writeBack = 5;
    

    reg [2 : 0] currState, nextState;
    always @(negedge clk, posedge rst)begin
        if(rst)currState <= 0;
        else currState <= nextState;
    end

    always @(*) begin
        // next state compute, edit for all instructions
        case (currState)
            fetch : nextState <= decode;
            decode : nextState <= execute1;
            execute1 :begin
                case (opcode)
                    lw:nextState <= execute2;
                    rType:nextState <= execute2;
                    beq: nextState <= fetch;
                    default: nextState <= fetch;
                endcase

            end
            execute2 : begin
                case (opcode)
                    lw : nextState <= execute3; 
                    rType : nextState <= fetch;
                    default: nextState <= fetch;
                endcase
            end 
            execute3:nextState <= fetch;
            default: nextState <= fetch;
        endcase

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
                // muxes
                IorD      = 0;
                RegDst    = 0;
                MemtoReg  = 0;
                ALUsrcA   = 0;
                ALUsrcB   = 3;
                ALUControl= 2;
                PCsrc     = 0;            
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
                        ALUsrcB   = 2;
                        ALUControl= 2;
                        PCsrc     = 0;
                    end 
                    rType: begin
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
                        PCsrc     = 0;
                        case (funct)
                            add : ALUControl = 2;
                            sub : ALUControl = 6;
                            default: ALUControl = 2;
                        endcase
                    end
                    beq :begin
                        // writes
                        Memwrite  = 0;
                        RegWrite  = 0;
                        IRWrite   = 0;
                        PCEn      = zero;
                        // muxes
                        IorD      = 0;
                        RegDst    = 0;
                        MemtoReg  = 0;
                        ALUsrcA   = 1;
                        ALUsrcB   = 0;
                        ALUControl= 6;
                        PCsrc     = 1;
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
                        rType: begin
                            // writes
                            Memwrite  = 0;
                            RegWrite  = 1;
                            IRWrite   = 0;
                            PCEn      = 0;
                            // muxes
                            IorD      = 0;
                            RegDst    = 1;
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