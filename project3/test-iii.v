//
// test module for RiSC cpu
//

module top ();
    reg		clk, reset;

    RiSC	cpu(clk, reset);

    integer i;
    integer j;

    initial begin
	reset = 0;
	#1 reset = 1;
	#1 clk=1;
	#1 reset = 0;
	$readmemh("init3.sys", cpu.MEM.m);
	$readmemh("init3.usr", cpu.MEM.m, 16'h0300);
	cpu.TLB.tlbregB_v.m = 1;
	cpu.TLB.tlbregB_asid.m = 6'd0;
	cpu.TLB.tlbregB_vpn.m = 8'hC9;
	cpu.TLB.tlbregB_pfn.m = 8'd2;
	cpu.RF.cr[4] = 16'h0009;
	#1000	$finish;
    end

    always begin
        #5 clk = 0;
        #5 clk = 1;
    end

    always @(posedge clk) begin
        #1
        $display("--");

        $display("MEMORY:");
        for (i=0; i<4; i=i+1) begin
            for (j=0; j<256; j=j+16)
                $display("%h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h",
                    cpu.MEM.m[(i<<8)+j+0], cpu.MEM.m[(i<<8)+j+1], cpu.MEM.m[(i<<8)+j+2], cpu.MEM.m[(i<<8)+j+3],
                    cpu.MEM.m[(i<<8)+j+4], cpu.MEM.m[(i<<8)+j+5], cpu.MEM.m[(i<<8)+j+6], cpu.MEM.m[(i<<8)+j+7],
                    cpu.MEM.m[(i<<8)+j+8], cpu.MEM.m[(i<<8)+j+9], cpu.MEM.m[(i<<8)+j+10], cpu.MEM.m[(i<<8)+j+11],
                    cpu.MEM.m[(i<<8)+j+12], cpu.MEM.m[(i<<8)+j+13], cpu.MEM.m[(i<<8)+j+14], cpu.MEM.m[(i<<8)+j+15]);
            $display("");
        end
    end

endmodule
