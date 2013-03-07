//
// test module for RiSC cpu
//
`define ZERO 16'd0
module top ();
    reg		clk;

    RiSC	cpu(clk);

    integer j;

    initial begin
	#1 cpu.pc = 0;
	cpu.rf[0] = `ZERO;
	cpu.rf[1] = `ZERO;
	cpu.rf[2] = `ZERO;
	cpu.rf[3] = `ZERO;
	cpu.rf[4] = `ZERO;
	cpu.rf[5] = `ZERO;
	cpu.rf[6] = `ZERO;
	cpu.rf[7] = `ZERO;
	for (j=0; j<65536; j=j+1)
	    cpu.m[j] = 0;

	#1 $readmemh("init.dat", cpu.m);

	#1000	$finish;
    end

    always begin
	#5 clk = 0; 
	#5 clk = 1;

    $display("PC: %h", cpu.pc);
	$display("Register Contents:");
	$display("  r0 - %h", cpu.rf[0]);
	$display("  r1 - %h", cpu.rf[1]);
	$display("  r2 - %h", cpu.rf[2]);
	$display("  r3 - %h", cpu.rf[3]);
	$display("  r4 - %h", cpu.rf[4]);
	$display("  r5 - %h", cpu.rf[5]);
	$display("  r6 - %h", cpu.rf[6]);
	$display("  r7 - %h", cpu.rf[7]);
	$display("  m[60] - %h", cpu.m[60]);

    end

endmodule
