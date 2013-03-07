//
// RiSC-16 skeleton
//

`define ADD	3'd0
`define ADDI	3'd1
`define NAND	3'd2
`define LUI	3'd3
`define SW	3'd4
`define LW	3'd5
`define BNE	3'd6
`define JALR	3'd7
`define EXTEND	3'd7

`define INSTRUCTION_OP	15:13	// opcode
`define INSTRUCTION_RA	12:10	// rA 
`define INSTRUCTION_RB	9:7	// rB 
`define INSTRUCTION_RC	2:0	// rC 
`define INSTRUCTION_IM	6:0	// immediate (7-bit, to be sign-extended)
`define INSTRUCTION_LI	9:0	// large unsigned immediate (10-bit, to be 0-extended)
`define INSTRUCTION_SB	6	// immediate's sign bit

`define ZERO		16'd0

`define HALTINSTRUCTION	{ `EXTEND, 3'd0, 3'd0, 3'd7, 4'd1 }

module RiSC (clk);
    input       clk;
    reg		[15:0]  rf[0:7];
    reg		[15:0]	pc;
    reg		[15:0]	m[0:65535];
    reg     [15:0]  instr;

    always @(negedge clk) begin
	   rf[0] <= `ZERO;
    end

    always @(posedge clk) begin
        instr = m[pc];
        case (instr[ `INSTRUCTION_OP])
        `ADD: rf[instr[`INSTRUCTION_RA]] <= rf[instr[`INSTRUCTION_RB]] + rf[instr[`INSTRUCTION_RC]];
        `ADDI: rf[instr[`INSTRUCTION_RA]] <= rf[instr[`INSTRUCTION_RB]] + instr[`INSTRUCTION_RC];
        `NAND: rf[instr[`INSTRUCTION_RA]] <= rf[instr[`INSTRUCTION_RB]] & rf[instr[`INSTRUCTION_RC]];
        `LUI: rf[instr[`INSTRUCTION_RA]] <= {instr[`INSTRUCTION_LI], 6'd0};
        `SW: if (instr[`INSTRUCTION_SB])
                    m[rf[instr[`INSTRUCTION_RB]] + {{3{`EXTEND}}, instr[`INSTRUCTION_IM]}] 
                    <= rf[instr[`INSTRUCTION_RA]];
                else
                    m[rf[instr[`INSTRUCTION_RB]] + instr[`INSTRUCTION_IM]] <= 
                    rf[instr[`INSTRUCTION_RA]];
        `LW: if (instr[`INSTRUCTION_SB])
                    rf[instr[`INSTRUCTION_RA]]
                    <= m[rf[instr[`INSTRUCTION_RB]] + {{3{`EXTEND}}, instr[`INSTRUCTION_IM]}];
                else
                    rf[instr[`INSTRUCTION_RA]]
                    <= m[rf[instr[`INSTRUCTION_RB]] + instr[`INSTRUCTION_IM]];
        `BNE: if (rf[instr[`INSTRUCTION_RA]] != rf[instr[`INSTRUCTION_RB]])
                if (instr[`INSTRUCTION_SB])
                    pc = pc + {{3{`EXTEND}}, instr[`INSTRUCTION_IM]};
                else
                    pc = pc + instr[`INSTRUCTION_IM];
        `JALR:
        begin
            rf[instr[`INSTRUCTION_RA]] <= pc + 1;
            pc = rf[instr[`INSTRUCTION_RB]] - 1;
        end
        endcase
        
        if (instr == `HALTINSTRUCTION)
            $finish;
        
        pc <= pc + 1;
    end

endmodule