//
// test module for RiSC cpu
//

`define	IO_REGS		8'h7f
`define	ROM_PAGE	8'h7e

`define	DISK_REQ_ADDR	{ `IO_REGS, 8'h10 }
`define	DISK_AR1_ADDR	{ `IO_REGS, 8'h11 }
`define	DISK_AR2_ADDR	{ `IO_REGS, 8'h12 }
`define	DISK_RDY_ADDR	{ `IO_REGS, 8'h13 }

`define	ROM_ADDR	{ `ROM_PAGE, 8'd0 }

`define	REQ_NULL	16'd0
`define	REQ_DONE	16'd1
`define	REQ_READ	16'h1234
`define	REQ_WRITE	16'h4321

module top ();
    reg		clk, reset;

    reg		[15:0]	disk_req, address, filenum;

    RiSC	cpu(clk, reset);

    integer i;
    integer j;

    initial begin
	for (i=0; i<65536; i=i+1) begin
	    cpu.MEM.m[i] = 0;
	end
	reset = 0;
	#1 reset = 1;
	#1 clk=1;
	#1 reset = 0;
	$readmemh("init.rom", cpu.MEM.m, `ROM_ADDR);
	cpu.MEM.m[`DISK_RDY_ADDR] = `REQ_NULL;
	#1000	$finish;
    end

    always begin
	#10
	wait (cpu.MEM.m[`DISK_REQ_ADDR] != `REQ_NULL);

	#100

	disk_req = cpu.MEM.m[`DISK_REQ_ADDR];
	cpu.MEM.m[`DISK_REQ_ADDR] = `REQ_NULL;

	case (disk_req) 
	    `REQ_READ:	begin
		filenum = cpu.MEM.m[`DISK_AR1_ADDR];
		address = cpu.MEM.m[`DISK_AR2_ADDR];

		if (filenum == 16'd1) begin
		    $display("IO Read Request -- reading init.usr1 into %h", address);
		    $readmemh("init.usr1", cpu.MEM.m, address);
		end
		else if (filenum == 16'd2) begin
		    $display("IO Read Request -- reading init.usr2 into %h", address);
		    $readmemh("init.usr2", cpu.MEM.m, address);
		end
		else if (filenum == 16'd3) begin
		    $display("IO Read Request -- reading init.sys into %h", address);
		    $readmemh("init.sys", cpu.MEM.m, address);
		end
		else begin
		    $display("IO error: unknown file num %h ... .bye", filenum);
		    $finish;
		end

		end
	    `REQ_WRITE:	begin
		$display("IO Write Request -- Ignoring");
		end
	    default: begin
		$display("IO error: unknown request type %h ... .bye", cpu.MEM.m[`DISK_REQ_ADDR]);
		$finish;
		end
	endcase

	cpu.MEM.m[`DISK_RDY_ADDR] = `REQ_DONE;
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
