`define ZERO 16'h0
`define HighImpedance 16'bZ

// writable only on port 2i
module three_port_aram (clk, abus1, dbus1, abus2, dbus2i, dbus2o, we);
	input		clk;

	input	[15:0]	abus1;
	output	[15:0]	dbus1;

	input	[15:0]	abus2;
	output	[15:0]	dbus2o;
	input	[15:0]	dbus2i;

	input		we;

	reg	[15:0]	m[0:65536];

	assign dbus1 = m[abus1];

	assign dbus2o = m[abus2];

	always @(posedge clk) begin
		if (we) m[abus2] <= dbus2i;
	end

endmodule


// writable only on port 3, r0=0
module three_port_aregfile (on, clk, abus1, dbus1, abus2, dbus2, abus3, dbus3, we);
	input		on;
	input		clk;

	input	[2:0]	abus1;
	output	[15:0]	dbus1;

	input	[2:0]	abus2;
	output	[15:0]	dbus2;

	input	[2:0]	abus3;
	input	[15:0]	dbus3;

	input		we;

	wire		iclk = on | clk;

	reg	[15:0]	m[1:7];

	assign	dbus1 =	(abus1 == 3'd0) ? `ZERO : m[abus1];

	assign	dbus2 =	(abus2 == 3'd0) ? `ZERO : m[abus2];

	always @(posedge iclk) begin
		if (on) begin
			m[1] <= `ZERO;
			m[2] <= `ZERO;
			m[3] <= `ZERO;
			m[4] <= `ZERO;
			m[5] <= `ZERO;
			m[6] <= `ZERO;
			m[7] <= `ZERO;
		end 
		else  m[abus3] <= (we & (abus3 != 3'd0)) ? dbus3 : m[abus3];
	end

endmodule



//
// default: 16 bits ... override parm when instantiated to get different widths
//
module registerX (reset, clk, in, out, we);

    parameter width = 16;

	input		reset;
	input		clk;
	output	[width-1:0]	out;
	input	[width-1:0]	in;
	input		we;

	reg	[width-1:0]	m;

	assign out = m;

	always @(posedge clk) begin
		m <=	(reset) ? 0 :
			(we) ? in :
			m;
	end

endmodule

//
// writable only on ports 3 & 4, r0=0, cr0=0, exports cr4 on dedicated bus
// PSR is exposed all the time (dedicated in and out ports)
// control regs have THREE write ports (way too huge)
// the regular regs have 1 write port
//
module control_and_general_regfile (reset, clk, abus1, dbus1, abus2, dbus2, abus3, dbus3, abus4, dbus4, psr_in, psr_out, psr_we);
	input		reset, clk, psr_we;
	input	[3:0]	abus1, abus2, abus3, abus4;
	input	[15:0]	psr_in;
	output	[15:0]	dbus1, dbus2, dbus3, dbus4, psr_out;

	wire		iclk = reset | clk;


	reg	[15:0]	m[1:7];
	reg	[15:0]	cr[1:7];
	reg	[15:0]	psr_kfifo;

	wire	[2:0]	regnum1 = abus1[2:0];
	wire	[2:0]	regnum2 = abus2[2:0];
	wire	[2:0]	regnum3 = abus3[2:0];
	wire	[2:0]	regnum4 = abus4[2:0];
	wire		regbank1 = abus1[3];
	wire		regbank2 = abus2[3];
	wire		regbank3 = abus3[3];
	wire		regbank4 = abus4[3];
	wire	[15:0]	cr4 = cr[4];

	assign	dbus1 =	(regnum1 == 3'd0) ? `ZERO :
			(regbank1) ? cr[regnum1] : m[regnum1];

	assign	dbus2 =	(regnum2 == 3'd0) ? `ZERO :
			(regbank2) ? cr[regnum2] : m[regnum2];

	assign	psr_out = { psr_kfifo[15:7], 1'b0, cr4[5:0] };

	always @(posedge iclk) begin
		if (reset) begin
			m[1] <= `ZERO;
			m[2] <= `ZERO;
			m[3] <= `ZERO;
			m[4] <= `ZERO;
			m[5] <= `ZERO;
			m[6] <= `ZERO;
			m[7] <= `ZERO;
			cr[1] <= `ZERO;
			cr[2] <= `ZERO;
			cr[3] <= `ZERO;
			cr[4] <= `ZERO;
			cr[5] <= `ZERO;
			cr[6] <= `ZERO;
			cr[7] <= `ZERO;
			psr_kfifo <= `ZERO;
		end 
		else  begin
			if (regnum3 != 3'd0) begin
			    m[regnum3] <= (~regbank3) ? dbus3 : m[regnum3];
			    cr[regnum3] <= (regbank3) ? dbus3 : cr[regnum3];
			end
			if ((regnum4 != 3'd0) && (abus3 != abus4)) begin
			    cr[regnum4] <= (regbank4) ? dbus4 : cr[regnum4];
			end
			if (psr_we) begin
			    psr_kfifo <= psr_in;
			end
		end
	end

endmodule
