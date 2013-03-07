//
// test module for RiSC cpu
//


module top ();
    reg		clk;
    reg		reset;

    RiSC	cpu(clk, reset);

    initial begin
        reset = 0;
        clk = 0;
        #1 reset = 1;
        #1 clk=1;
        #1 reset = 0;
	$readmemh("TESTS/6.exe", cpu.MEM.m);
	#1000	$finish;
    end

    always begin
	#5 clk = 0; 
	#5 clk = 1;
    end

endmodule
