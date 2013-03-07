`define ZERO 16'h0

// writable only on port 2i
module three_port_aram (clk, abus1, dbus1, abus2, dbus2i, dbus2o, we);
	input		clk;

	input	[15:0]	abus1;
	output	[15:0]	dbus1;

	input	[15:0]	abus2;
	output	[15:0]	dbus2o;
	input	[15:0]	dbus2i;

	input		we;

	reg	[15:0]	m[0:128];

	assign dbus1 = m[abus1];

	assign dbus2o = m[abus2];

	always @(posedge clk) begin
		if (we) m[abus2] <= dbus2i;
	end

endmodule


// writable only on port 3, r0=0
module three_port_aregfile (on, clk, abus1, dbus1, abus2, dbus2, abus3, dbus3);
	input		on;
	input		clk;

	input	[2:0]	abus1;
	output	[15:0]	dbus1;

	input	[2:0]	abus2;
	output	[15:0]	dbus2;

	input	[2:0]	abus3;
	input	[15:0]	dbus3;


	wire		iclk = on | clk;

	reg	[15:0]	m[0:7];

	assign	dbus1 =	(abus1 == 3'd0) ? `ZERO : m[abus1];

	assign	dbus2 =	(abus2 == 3'd0) ? `ZERO : m[abus2];

	always @(posedge iclk) begin
		if (on) begin
		    m[0] <= `ZERO;
			m[1] <= `ZERO;
			m[2] <= `ZERO;
			m[3] <= `ZERO;
			m[4] <= `ZERO;
			m[5] <= `ZERO;
			m[6] <= `ZERO;
			m[7] <= `ZERO;
		end 
		else if (abus3 != 3'd0) begin
		    m[abus3] <= dbus3;
		end
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
