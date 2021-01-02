`define VERBOSE
module sha256_tb;

reg [8191:0] status = "Init";

reg pwr = 1'b0;
reg gnd = 1'b0;
reg clk = 0;
reg rst = 0;

reg [37:0] io_in = 0;
wire [37:0] io_oeb;
wire [37:0] io_out = 0;
reg [127:0] la_data_in = 0;
wire [127:0] la_data_out;
reg [127:0] la_oen = 0;

reg wb_stb = 0;
reg wb_we = 0;
reg [31:0] wb_adr = 0;
reg [31:0] wb_dat_wr = 0;
wire [31:0] wb_dat_rd;
wire wb_ack;

wire wb_cyc = wb_stb;
reg [3:0] wb_sel = 4'b1111;

accelerator_top uut (
`ifdef GL
	.vccd1(pwr),
	.vssd1(gnd),
	.vccd2(pwr),
	.vssd2(gnd),
	.vdda1(pwr),
	.vssa1(gnd),
	.vdda2(pwr),
	.vssa2(gnd),
`endif

	.io_in(io_in),
	.io_oeb(io_oeb),
	.io_out(io_out),
	.la_data_in(la_data_in),
	.la_data_out(la_data_out),
	.la_oen(la_oen),

	.wb_clk_i(clk),
	.wb_rst_i(rst),

	.wbs_ack_o(wb_ack),
	.wbs_adr_i(wb_adr),
	.wbs_cyc_i(wb_cyc),
	.wbs_dat_i(wb_dat_wr),
	.wbs_dat_o(wb_dat_rd),
	.wbs_sel_i(wb_sel),
	.wbs_stb_i(wb_stb),
	.wbs_we_i(wb_we)
);

always #5 clk = pwr && ~clk;

reg [31:0] wb_out;
task wb_rd (input [31:0] addr);
	wb_adr = addr;
	wb_we = 0;
	wb_stb = 1;
	@(negedge clk);
	while (!wb_ack) @(negedge clk);
	wb_out = wb_dat_rd;
	wb_stb = 0;
	@(negedge clk);

`ifdef VERBOSE
	$display("wb_rd(%x) = %x", addr, wb_out);
`endif
endtask

task wb_wr (input [31:0] addr, input [31:0] data);
	wb_adr = addr;
	wb_dat_wr = data;
	wb_we = 1;
	wb_stb = 1;
	@(negedge clk);
	while (!wb_ack) @(negedge clk);
	wb_stb = 0;
	@(negedge clk);

`ifdef VERBOSE
	$display("wb_wr(%x, %x)", addr, data);
`endif
endtask

string prefix = "";
reg pass;
initial begin
	$dumpfile("build/sha256_tb.vcd");
	$dumpvars(0, uut);
	$dumpvars(0, status);

	clk = 0;
	pwr = 1;

	rst = 1;
	#10
	@(negedge clk);
	rst = 0;

	prefix = "SHA256";
	$sformat(status, "%s: Start hash", prefix);
	wb_wr(32'h10000, 1);

	$sformat(status, "%s: Input data  1/16", prefix);
	wb_wr(32'h10004, 32'h34687039);

	$sformat(status, "%s: Input data  2/16", prefix);
	wb_wr(32'h10004, 32'h345A6665);

	$sformat(status, "%s: Input data  3/16", prefix);
	wb_wr(32'h10004, 32'h55584D59);

	$sformat(status, "%s: Input data  4/16", prefix);
	wb_wr(32'h10004, 32'h49435647);

	$sformat(status, "%s: Input data  5/16", prefix);
	wb_wr(32'h10004, 32'h696E3737);

	$sformat(status, "%s: Input data  6/16", prefix);
	wb_wr(32'h10004, 32'h51755773);

	$sformat(status, "%s: Input data  7/16", prefix);
	wb_wr(32'h10004, 32'h5A4E6761);

	$sformat(status, "%s: Input data  8/16", prefix);
	wb_wr(32'h10004, 32'h434A5652);

	$sformat(status, "%s: Input data  9/16", prefix);
	wb_wr(32'h10004, 32'h566C776E);

	$sformat(status, "%s: Input data 10/16", prefix);
	wb_wr(32'h10004, 32'h52786734);

	$sformat(status, "%s: Input data 11/16", prefix);
	wb_wr(32'h10004, 32'h53345243);

	$sformat(status, "%s: Input data 12/16", prefix);
	wb_wr(32'h10004, 32'h37644F35);

	$sformat(status, "%s: Input data 13/16", prefix);
	wb_wr(32'h10004, 32'h62653733);

	$sformat(status, "%s: Input data 14/16", prefix);
	wb_wr(32'h10004, 32'h69556C80);

	$sformat(status, "%s: Input data 15/16", prefix);
	wb_wr(32'h10004, 32'h00000000);

	$sformat(status, "%s: Input data 16/16", prefix);
	wb_wr(32'h10004, 32'h000001B8);

	$sformat(status, "%s: Compute hash", prefix);
	wb_out = 0; while ((wb_out & 16'h4) != 16'h4) wb_rd(32'h10000); 

	$sformat(status, "%s: Read back result", prefix);
	pass = 1;
	wb_rd(32'h10010);
	if (!(wb_out == 32'h2BFC20BF)) pass = 0;
	wb_rd(32'h10014);
	if (!(wb_out == 32'hD0EE9E66)) pass = 0;
	wb_rd(32'h10018);
	if (!(wb_out == 32'hD761A809)) pass = 0;
	wb_rd(32'h1001C);
	if (!(wb_out == 32'hDEB465D8)) pass = 0;
	wb_rd(32'h10020);
	if (!(wb_out == 32'h61291245)) pass = 0;
	wb_rd(32'h10024);
	if (!(wb_out == 32'hED3F782B)) pass = 0;
	wb_rd(32'h10028);
	if (!(wb_out == 32'h19C3F4E2)) pass = 0;
	wb_rd(32'h1002C);
	if (!(wb_out == 32'hCFA7562E)) pass = 0;

	if (pass) $display("PASS");
	else $display("FAIL");

	$display("Done, cycles = %d", $time / 10);
	$finish;
end

endmodule
