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
`define INSTRUCTION_IM	6:0	// immediate (7-bit)
`define INSTRUCTION_LI	9:0	// large unsigned immediate (10-bit, 0-extended)
`define INSTRUCTION_SB	6	// immediate's sign bit

`define ZERO		16'd0

`define HALTINSTRUCTION	{ `EXTEND, 3'd0, 3'd0, 3'd7, 4'd1 }


module not_equivalent (alu1, alu2, out);
	input	[15:0]	alu1;
	input	[15:0]	alu2;
	output		out;

	assign	out = (((((alu1[0] ^ alu2[0]) |
			(alu1[1] ^ alu2[1])) |
			((alu1[2] ^ alu2[2]) |
			(alu1[3] ^ alu2[3]))) |
			(((alu1[4] ^ alu2[4]) |
			(alu1[5] ^ alu2[5])) |
			((alu1[6] ^ alu2[6]) |
			(alu1[7] ^ alu2[7])))) |
			((((alu1[8] ^ alu2[8]) |
			(alu1[9] ^ alu2[9])) |
			((alu1[10] ^ alu2[10]) |
			(alu1[11] ^ alu2[11]))) |
			(((alu1[12] ^ alu2[12]) |
			(alu1[13] ^ alu2[13])) |
			((alu1[14] ^ alu2[14]) |
			(alu1[15] ^ alu2[15])))));
endmodule

module arithmetic_logic_unit (op, alu1, alu2, bus);
	input	[2:0]	op;
	input	[15:0]	alu1;
	input	[15:0]	alu2;
	output	[15:0]	bus;

	assign bus =	(op == `ADD) ? alu1 + alu2 :
			(op == `NAND) ? ~(alu1 & alu2) :
			alu2;
endmodule




module IFID	(clk, reset, IFID_we, IFID_instr__in, IFID_pc__in,
		IFID_instr__out, IFID_pc__out);

	input		clk, reset, IFID_we;
	input	[15:0]	IFID_instr__in, IFID_pc__in;
	output	[15:0]	IFID_instr__out, IFID_pc__out;

	wire	clk_A, clk_B, clk_C, clk_D, clk_E, clk_F, clk_G, clk_H,
		res_A, res_B, res_C, res_D, res_E, res_F, res_G, res_H;

	buf	cA(clk_A, clk), cB(clk_B, clk), cC(clk_C, clk), cD(clk_D, clk),
		cE(clk_E, clk), cF(clk_F, clk), cG(clk_G, clk), cH(clk_H, clk),
		rA(res_A, reset), rB(res_B, reset), rC(res_C, reset), rD(res_D, reset),
		rE(res_E, reset), rF(res_F, reset), rG(res_G, reset), rH(res_H, reset);

	registerX #(16)		IFID_instr (.reset(res_A), .clk(clk_A), .out(IFID_instr__out), .in(IFID_instr__in), .we(IFID_we));
	registerX #(16)		IFID_pc (.reset(res_B), .clk(clk_B), .out(IFID_pc__out), .in(IFID_pc__in), .we(IFID_we));

endmodule


module IDEX	(clk, reset, IDEX_op0__in, IDEX_op1__in, IDEX_op2__in, IDEX_op__in, IDEX_rT__in, IDEX_x__in, IDEX_pc__in,
		IDEX_op0__out, IDEX_op1__out, IDEX_op2__out, IDEX_op__out, IDEX_rT__out, IDEX_x__out, IDEX_pc__out);

	input		clk, reset;
	input	[15:0]	IDEX_op0__in, IDEX_op1__in, IDEX_op2__in;
	input	[2:0]	IDEX_op__in;
	input	[2:0]	IDEX_rT__in;
	output	[15:0]	IDEX_op0__out, IDEX_op1__out, IDEX_op2__out;
	output	[2:0]	IDEX_op__out;
	input	[2:0]	IDEX_rT__out;
	input	[15:0]	IDEX_pc__in;
	input		IDEX_x__in;
	output	[15:0]	IDEX_pc__out;
	output		IDEX_x__out;

	wire	clk_A, clk_B, clk_C, clk_D, clk_E, clk_F, clk_G, clk_H,
		res_A, res_B, res_C, res_D, res_E, res_F, res_G, res_H;

	buf	cA(clk_A, clk), cB(clk_B, clk), cC(clk_C, clk), cD(clk_D, clk),
		cE(clk_E, clk), cF(clk_F, clk), cG(clk_G, clk), cH(clk_H, clk),
		rA(res_A, reset), rB(res_B, reset), rC(res_C, reset), rD(res_D, reset),
		rE(res_E, reset), rF(res_F, reset), rG(res_G, reset), rH(res_H, reset);

	registerX #(16)		IDEX_op0 (.reset(res_A), .clk(clk_A), .out(IDEX_op0__out), .in(IDEX_op0__in), .we(1'd1));
	registerX #(16)		IDEX_op1 (.reset(res_B), .clk(clk_B), .out(IDEX_op1__out), .in(IDEX_op1__in), .we(1'd1));
	registerX #(16)		IDEX_op2 (.reset(res_C), .clk(clk_C), .out(IDEX_op2__out), .in(IDEX_op2__in), .we(1'd1));
	registerX #(3)		IDEX_op (.reset(res_D), .clk(clk_D), .out(IDEX_op__out), .in(IDEX_op__in), .we(1'd1));
	registerX #(3)		IDEX_rT (.reset(res_E), .clk(clk_E), .out(IDEX_rT__out), .in(IDEX_rT__in), .we(1'd1));
	registerX #(1)		IDEX_x (.reset(res_F), .clk(clk_F), .out(IDEX_x__out), .in(IDEX_x__in), .we(1'd1));
	registerX #(16)		IDEX_pc (.reset(res_G), .clk(clk_G), .out(IDEX_pc__out), .in(IDEX_pc__in), .we(1'd1));

endmodule


module EXMEM	(clk, reset, EXMEM_stdata__in, EXMEM_ALUout__in, EXMEM_op__in, EXMEM_rT__in, EXMEM_x__in, EXMEM_pc__in,
		EXMEM_stdata__out, EXMEM_ALUout__out, EXMEM_op__out, EXMEM_rT__out, EXMEM_x__out, EXMEM_pc__out);

	input		clk, reset;
	input	[15:0]	EXMEM_stdata__in, EXMEM_ALUout__in;
	input	[2:0]	EXMEM_op__in;
	input	[2:0]	EXMEM_rT__in;
	output	[15:0]	EXMEM_stdata__out, EXMEM_ALUout__out;
	output	[2:0]	EXMEM_op__out;
	input	[2:0]	EXMEM_rT__out;
	input	[15:0]	EXMEM_pc__in;
	input		EXMEM_x__in;
	output	[15:0]	EXMEM_pc__out;
	output		EXMEM_x__out;

	wire	clk_A, clk_B, clk_C, clk_D, clk_E, clk_F, clk_G, clk_H,
		res_A, res_B, res_C, res_D, res_E, res_F, res_G, res_H;

	buf	cA(clk_A, clk), cB(clk_B, clk), cC(clk_C, clk), cD(clk_D, clk),
		cE(clk_E, clk), cF(clk_F, clk), cG(clk_G, clk), cH(clk_H, clk),
		rA(res_A, reset), rB(res_B, reset), rC(res_C, reset), rD(res_D, reset),
		rE(res_E, reset), rF(res_F, reset), rG(res_G, reset), rH(res_H, reset);

	registerX #(16)		EXMEM_stdata (.reset(res_A), .clk(clk_A), .out(EXMEM_stdata__out), .in(EXMEM_stdata__in), .we(1'd1));
	registerX #(16)		EXMEM_ALUout (.reset(res_B), .clk(clk_B), .out(EXMEM_ALUout__out), .in(EXMEM_ALUout__in), .we(1'd1));
	registerX #(3)		EXMEM_op (.reset(res_C), .clk(clk_C), .out(EXMEM_op__out), .in(EXMEM_op__in), .we(1'd1));
	registerX #(3)		EXMEM_rT (.reset(res_D), .clk(clk_D), .out(EXMEM_rT__out), .in(EXMEM_rT__in), .we(1'd1));
	registerX #(1)		EXMEM_x (.reset(res_E), .clk(clk_E), .out(EXMEM_x__out), .in(EXMEM_x__in), .we(1'd1));
	registerX #(16)		EXMEM_pc (.reset(res_F), .clk(clk_F), .out(EXMEM_pc__out), .in(EXMEM_pc__in), .we(1'd1));

endmodule


module MEMWB	(clk, reset, MEMWB_rfdata__in, MEMWB_rT__in, MEMWB_x__in, MEMWB_pc__in,
		MEMWB_rfdata__out, MEMWB_rT__out, MEMWB_x__out, MEMWB_pc__out);

	input		clk, reset;
	input	[15:0]	MEMWB_rfdata__in;
	input	[2:0]	MEMWB_rT__in;
	output	[15:0]	MEMWB_rfdata__out;
	output	[2:0]	MEMWB_rT__out;
	input	[15:0]	MEMWB_pc__in;
	input		MEMWB_x__in;
	output	[15:0]	MEMWB_pc__out;
	output		MEMWB_x__out;

	wire	clk_A, clk_B, clk_C, clk_D, clk_E, clk_F, clk_G, clk_H,
		res_A, res_B, res_C, res_D, res_E, res_F, res_G, res_H;

	buf	cA(clk_A, clk), cB(clk_B, clk), cC(clk_C, clk), cD(clk_D, clk),
		cE(clk_E, clk), cF(clk_F, clk), cG(clk_G, clk), cH(clk_H, clk),
		rA(res_A, reset), rB(res_B, reset), rC(res_C, reset), rD(res_D, reset),
		rE(res_E, reset), rF(res_F, reset), rG(res_G, reset), rH(res_H, reset);

	registerX #(16)		MEMWB_rfdata (.reset(res_A), .clk(clk_A), .out(MEMWB_rfdata__out), .in(MEMWB_rfdata__in), .we(1'd1));
	registerX #(3)		MEMWB_rT (.reset(res_B), .clk(clk_B), .out(MEMWB_rT__out), .in(MEMWB_rT__in), .we(1'd1));
	registerX #(1)		MEMWB_x (.reset(res_C), .clk(clk_C), .out(MEMWB_x__out), .in(MEMWB_x__in), .we(1'd1));
	registerX #(16)		MEMWB_pc (.reset(res_D), .clk(clk_D), .out(MEMWB_pc__out), .in(MEMWB_pc__in), .we(1'd1));

endmodule






module RiSC (clk, reset);
	input	clk;
	input	reset;



	// clock tree, reset tree
	wire	clk_A, clk_B, clk_C, clk_D, clk_E, clk_F, clk_G, clk_H,
		res_A, res_B, res_C, res_D, res_E, res_F, res_G, res_H;

	buf	cA(clk_A, clk), cB(clk_B, clk), cC(clk_C, clk), cD(clk_D, clk),
		cE(clk_E, clk), cF(clk_F, clk), cG(clk_G, clk), cH(clk_H, clk),
		rA(res_A, reset), rB(res_B, reset), rC(res_C, reset), rD(res_D, reset),
		rE(res_E, reset), rF(res_F, reset), rG(res_G, reset), rH(res_H, reset);



	wire	[15:0]	PC__out;

	wire	[15:0]	IFID_instr__out;
	wire	[15:0]	IFID_pc__out;

	wire	[15:0]	IDEX_op0__out;
	wire	[15:0]	IDEX_op1__out;
	wire	[15:0]	IDEX_op2__out;
	wire	[2:0]	IDEX_op__out;
	wire	[2:0]	IDEX_rT__out;
	wire		IDEX_x__out;
	wire	[15:0]	IDEX_pc__out;

	wire	[15:0]	EXMEM_stdata__out;
	wire	[15:0]	EXMEM_ALUout__out;
	wire	[2:0]	EXMEM_op__out;
	wire	[2:0]	EXMEM_rT__out;
	wire		EXMEM_x__out;
	wire	[15:0]	EXMEM_pc__out;

	wire	[15:0]	MEMWB_rfdata__out;
	wire	[2:0]	MEMWB_rT__out;
	wire		MEMWB_x__out;
	wire	[15:0]	MEMWB_pc__out;



	wire	[15:0]	PC__in;

	wire	[15:0]	IFID_instr__in;
	wire	[15:0]	IFID_pc__in;

	wire	[15:0]	IDEX_op0__in;
	wire	[15:0]	IDEX_op1__in;
	wire	[15:0]	IDEX_op2__in;
	wire	[2:0]	IDEX_op__in;
	wire	[2:0]	IDEX_rT__in;
	wire		IDEX_x__in;
	wire	[15:0]	IDEX_pc__in;

	wire	[15:0]	EXMEM_stdata__in;
	wire	[15:0]	EXMEM_ALUout__in;
	wire	[2:0]	EXMEM_op__in;
	wire	[2:0]	EXMEM_rT__in;
	wire		EXMEM_x__in;
	wire	[15:0]	EXMEM_pc__in;

	wire	[15:0]	MEMWB_rfdata__in;
	wire	[2:0]	MEMWB_rT__in;
	wire		MEMWB_x__in;
	wire	[15:0]	MEMWB_pc__in;




	wire	[2:0]	IFID_op = IFID_instr__out[ `INSTRUCTION_OP ];
	wire	[2:0]	IFID_rA = IFID_instr__out[ `INSTRUCTION_RA ];
	wire	[2:0]	IFID_rB = IFID_instr__out[ `INSTRUCTION_RB ];
	wire	[2:0]	IFID_rC = IFID_instr__out[ `INSTRUCTION_RC ];
	wire	[6:0]	IFID_im = IFID_instr__out[ `INSTRUCTION_IM ];
	wire		IFID_sb = IFID_instr__out[ `INSTRUCTION_SB ];

	wire	[15:0]	IFID_simm = { {9{IFID_sb}}, IFID_im };
	wire	[15:0]	IFID_uimm = { IFID_instr__out[ `INSTRUCTION_LI ], 6'd0 };



	wire	[15:0]	PC__out_plus1 = PC__out+1;				// dedicated adder
	wire	[15:0]	IFID_pc_plus1 = IFID_pc__out+1;				// dedicated adder
	wire	[15:0]	IFID_pc_plus_signext_plus1 = IFID_pc_plus1+IFID_simm;	// dedicated adder



	wire		PC_we;
	wire		IFID_we;

	wire	[15:0]	MUXpc_out;
	wire	[2:0]	MUXs2_out;
	wire		Pstall;
	wire		Pstomp;
	wire	[15:0]	MUXimm_out;	
	wire	[15:0]	MUXop2_out;
	wire	[15:0]	MUXop1_out;
	wire	[15:0]	MUXalu2_out;

	wire	[2:0]	FUNCalu = ((IDEX_op__out == `ADDI) || (IDEX_op__out == `SW) || (IDEX_op__out == `LW))
				? `ADD
				: IDEX_op__out;

	wire		WEdmem;
	wire	[15:0]	MUXout_out;

	wire	[15:0]	ALU_out;

	wire	[15:0]	RF__out1;
	wire	[2:0]	RF__src1;
	wire	[15:0]	RF__out2;
	wire	[2:0]	RF__src2;
	wire	[15:0]	RF__in;
	wire	[2:0]	RF__tgt;
	wire	[15:0]	MEM__data1;
	wire	[15:0]	MEM__addr1;
	wire	[15:0]	MEM__data2out;
	wire	[15:0]	MEM__addr2;




	//
	// PC UPDATE
	//
	wire		not_equal;
	wire		ifid_is_bne = (IFID_op == `BNE);
	wire		ifid_is_jalr = (IFID_op == `JALR && IFID_im == 7'd0);
	wire		takenBranch = (ifid_is_bne & not_equal);

	registerX #(16)		PC (.reset(res_A), .clk(clk_A), .out(PC__out), .in(PC__in), .we(PC_we));
	not_equivalent		NEQ (.alu1(MUXop1_out), .alu2(MUXop2_out), .out(not_equal));


	assign 	MUXpc_out = (takenBranch) ? IFID_pc_plus_signext_plus1 : 
	                    (ifid_is_jalr) ? MUXop1_out : 
	                    (IDEX_x__in) ? 0 :
	                    PC__out_plus1;
	assign 	PC__in =	MUXpc_out;
	assign	PC_we = 	~Pstall;






	//
	// FETCH STAGE
	//

	IFID	ifid_reg (.reset(res_B), .clk(clk_B), .IFID_instr__in(IFID_instr__in), .IFID_pc__in(IFID_pc__in),
			.IFID_we(IFID_we), .IFID_instr__out(IFID_instr__out), .IFID_pc__out(IFID_pc__out));


	assign	MEM__addr1 =		PC__out;
	assign	IFID_instr__in = 	(Pstomp) ? 0 : MEM__data1;
	assign	IFID_pc__in = 		(Pstomp) ? 0 : PC__out;
	assign	IFID_we =		    ~Pstall;




	//
	// DECODE STAGE
	//
	wire		s1nonzero = (RF__src1[2:0] != 3'd0);
	wire		s2nonzero = (RF__src2[2:0] != 3'd0);
	wire		ifid_is_addORnand = (IFID_op == `ADD) | (IFID_op == `NAND);
	wire		idex_is_lw = (IDEX_op__out == `LW);
	wire		ifid_is_lui = (IFID_op == `LUI);
	wire		ifid_uses_simm = (IFID_op == `ADDI) | (IFID_op == `LW) | (IFID_op == `SW) | (IFID_op == `BNE);
	wire		ifid_writesRF =	(~IFID_op[2] | IFID_op[0]);
	
	wire        haltinstruction = (IFID_instr__out == `HALTINSTRUCTION);
	wire        ifid_is_jalr_noimm = (IFID_op == `JALR);
	
	


        three_port_aregfile     RF (.on(res_C), .clk(clk_C), .abus1(RF__src1), .dbus1(RF__out1), .abus2(RF__src2),
                                        .dbus2(RF__out2), .abus3(RF__tgt), .dbus3(RF__in));

	IDEX	idex_reg(.reset(res_D), .clk(clk_D), .IDEX_op0__in(IDEX_op0__in), .IDEX_op1__in(IDEX_op1__in), 
			.IDEX_op2__in(IDEX_op2__in), .IDEX_op__in(IDEX_op__in), .IDEX_rT__in(IDEX_rT__in), 
			.IDEX_pc__in(IDEX_pc__in), .IDEX_x__in(IDEX_x__in),
			.IDEX_pc__out(IDEX_pc__out), .IDEX_x__out(IDEX_x__out),
			.IDEX_op0__out(IDEX_op0__out), .IDEX_op1__out(IDEX_op1__out), .IDEX_op2__out(IDEX_op2__out),
			.IDEX_op__out(IDEX_op__out), .IDEX_rT__out(IDEX_rT__out));


	wire		idex_targets_src1 = (s1nonzero & (IDEX_rT__out == RF__src1));
	wire		idex_targets_src2 = (s2nonzero & (IDEX_rT__out == RF__src2));
	wire		exmem_targets_src1 = (s1nonzero & (EXMEM_rT__out == RF__src1));
	wire		exmem_targets_src2 = (s2nonzero & (EXMEM_rT__out == RF__src2));
	wire		memwb_targets_src1 = (s1nonzero & (MEMWB_rT__out == RF__src1));
	wire		memwb_targets_src2 = (s2nonzero & (MEMWB_rT__out == RF__src2));

	wire	[2:0]	CTL6_out_op =	(Pstall) ? `ADD :
	                                IFID_op;
	wire	[2:0]	CTL6_out_rT =   (Pstall | ~ifid_writesRF) ? 3'd0 : IFID_rA; 

	assign	Pstall =	idex_is_lw & (idex_targets_src1 | idex_targets_src2); //CTL6 done
	assign	Pstomp =    ifid_is_jalr | takenBranch | IDEX_x__in; //CTL4 done
	assign	RF__src1 =	IFID_rB;
	assign	RF__src2 =	MUXs2_out;
	assign	MUXs2_out =	(ifid_is_addORnand) ? IFID_rC : IFID_rA; //CTL7
	assign	MUXimm_out =	(ifid_is_lui) ? IFID_uimm : 
	                        (ifid_is_jalr_noimm) ? IFID_pc_plus1 :
	                        IFID_simm;
	assign	MUXop1_out =    (idex_targets_src1) ? ALU_out :
	                        (exmem_targets_src1) ? MUXout_out :
	                        (memwb_targets_src1) ? MEMWB_rfdata__out :
	                        RF__out1; //CTL5 done
	assign	MUXop2_out =	(idex_targets_src2) ? ALU_out :
                            (exmem_targets_src2) ? MUXout_out :
                            (memwb_targets_src2) ? MEMWB_rfdata__out :
                            RF__out2; //CTL5 done
	assign	IDEX_op__in =	CTL6_out_op; //done
	assign	IDEX_rT__in =	CTL6_out_rT; //done
	assign	IDEX_op0__in =	(Pstall) ? 0 : MUXimm_out; //done
	assign	IDEX_op1__in =	(Pstall) ? 0 : MUXop1_out; //done
	assign	IDEX_op2__in =	(Pstall) ? 0 : MUXop2_out; //done
	assign	IDEX_pc__in =	(Pstall) ? 0 : IFID_pc__out; //done
	assign	IDEX_x__in =	(haltinstruction) ? 1'b1 : 1'b0; //done




	//
	// EXECUTE STAGE
	//
	wire		idex_is_addORnand = (IDEX_op__out == `ADD) | (IDEX_op__out == `NAND);
	wire		idex_is_lui = (IDEX_op__out == `LUI);

	arithmetic_logic_unit	ALU (.op(FUNCalu), .alu1(IDEX_op1__out), .alu2(MUXalu2_out), .bus(ALU_out));

	EXMEM	exmem_reg(.reset(res_E), .clk(clk_E), .EXMEM_stdata__in(EXMEM_stdata__in), .EXMEM_ALUout__in(EXMEM_ALUout__in),
			.EXMEM_op__in(EXMEM_op__in), .EXMEM_rT__in(EXMEM_rT__in), .EXMEM_stdata__out(EXMEM_stdata__out),
			.EXMEM_pc__in(EXMEM_pc__in), .EXMEM_x__in(EXMEM_x__in),
			.EXMEM_pc__out(EXMEM_pc__out), .EXMEM_x__out(EXMEM_x__out),
			.EXMEM_ALUout__out(EXMEM_ALUout__out), .EXMEM_op__out(EXMEM_op__out), .EXMEM_rT__out(EXMEM_rT__out));


	assign	MUXalu2_out = 		(idex_is_addORnand) ? IDEX_op2__out : IDEX_op0__out; //CTL3
	assign	EXMEM_op__in = 		IDEX_op__out;
	assign	EXMEM_rT__in = 		IDEX_rT__out;
	assign	EXMEM_pc__in = 		IDEX_pc__out;
	assign	EXMEM_x__in = 		IDEX_x__out;
	assign	EXMEM_stdata__in = 	IDEX_op2__out;
	assign	EXMEM_ALUout__in = 	ALU_out;



	//
	// MEMORY STAGE
	//
	wire		exmem_is_lw = (EXMEM_op__out == `LW);
	wire		exmem_is_sw = (EXMEM_op__out == `SW);

	wire	[15:0]	MEM__data2in;

	three_port_aram		MEM (.clk(clk_F), .abus1(MEM__addr1), .dbus1(MEM__data1), .abus2(MEM__addr2),
				.dbus2o(MEM__data2out), .dbus2i(MEM__data2in), .we(WEdmem));

	MEMWB	memwb_reg(.reset(res_G), .clk(clk_G), .MEMWB_rfdata__in(MEMWB_rfdata__in), .MEMWB_rT__in(MEMWB_rT__in),
			.MEMWB_pc__in(MEMWB_pc__in), .MEMWB_x__in(MEMWB_x__in), 
			.MEMWB_pc__out(MEMWB_pc__out), .MEMWB_x__out(MEMWB_x__out), 
			.MEMWB_rfdata__out(MEMWB_rfdata__out), .MEMWB_rT__out(MEMWB_rT__out));


	assign	MEM__addr2 =		EXMEM_ALUout__out;
	assign	MEM__data2in =		EXMEM_stdata__out;
	assign	WEdmem =		    exmem_is_sw;
	assign	MUXout_out =		(exmem_is_lw) ? MEM__data2out : EXMEM_ALUout__out;
	assign	MEMWB_rT__in =		EXMEM_rT__out;
	assign	MEMWB_pc__in =		EXMEM_pc__out;
	assign	MEMWB_x__in =		EXMEM_x__out;
	assign	MEMWB_rfdata__in =	MUXout_out;




	//
	// WRITEBACK STAGE
	//
	assign	RF__tgt = 	MEMWB_rT__out;
	assign	RF__in = 	MEMWB_rfdata__out;



	always @(posedge clk) begin
                $display("------------- (time %h)", $time);
                $display("regs  %h %h %h %h %h %h %h",
                        RF.m[1], RF.m[2], RF.m[3], RF.m[4], RF.m[5], RF.m[6], RF.m[7]);
                $display("pipe  PC=%h", PC__out);
                $display("pipe  IFID_instr=%h (op=%h rA=%h rB=%h rC=%h imm=%d) IFID_pc=%h",
                        IFID_instr__out, IFID_op, IFID_rA, IFID_rB, IFID_rC, IFID_im, IFID_pc__out);
                $display("pipe  IDEX_op0=%h IDEX_op1=%h IDEX_op2=%h IDEX_op=%h IDEX_rT=%h IDEX_pc=%h IDEX_x=%h",
                        IDEX_op0__out, IDEX_op1__out, IDEX_op2__out, IDEX_op__out, IDEX_rT__out, IDEX_pc__out, IDEX_x__out);
                $display("pipe  EXMEM_stdata=%h EXMEM_ALUout=%h EXMEM_op=%h EXMEM_rT=%h EXMEM_pc=%h EXMEM_x=%h",
                        EXMEM_stdata__out, EXMEM_ALUout__out, EXMEM_op__out, EXMEM_rT__out, EXMEM_pc__out, EXMEM_x__out);
                $display("pipe  MEMWB_rfdata=%h MEMWB_rT=%h MEMWB_pc=%h MEMWB_x=%h",
                        MEMWB_rfdata__out, MEMWB_rT__out, MEMWB_pc__out, MEMWB_x__out);
                $display("etc.  Pstall=%h Pstomp=%h jalr=%h branch=%h simm=%d",
                        Pstall, Pstomp, ifid_is_jalr, takenBranch, IFID_simm);

		if (MEMWB_x__out) $finish;
	end
endmodule

