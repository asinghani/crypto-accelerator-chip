`define VERBOSE
module aes256_tb;

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
reg [15:0] aes_mask;
reg [15:0] block_mask;
reg pass;
task aes_test(input [31:0] key0, input [31:0] key1, input [31:0] key2, input [31:0] key3,
              input [31:0] key4, input [31:0] key5, input [31:0] key6, input [31:0] key7,
              input [31:0] iv0,  input [31:0] iv1,  input [31:0] iv2,  input [31:0] iv3,
              input [31:0] in0,  input [31:0] in1,  input [31:0] in2,  input [31:0] in3,
              input [31:0] out0, input [31:0] out1, input [31:0] out2, input [31:0] out3,
			  input enc, input aes256, input both);

	// Set AES type
	$sformat(status, "%s: Set AES type", prefix);
	if (aes256) aes_mask = 16'h10;
	else aes_mask = 16'h00;

	if (((iv0 | iv1 | iv2 | iv3) != 0)) block_mask = 16'h08;
	else block_mask = 16'h00;

	wb_wr(16'h00, aes_mask | block_mask);

	// Load top-half of key
	if (aes256) begin
		$sformat(status, "%s: Load top key", prefix);
		wb_wr(16'h40, key4);
		wb_wr(16'h40, key5);
		wb_wr(16'h40, key6);
		wb_wr(16'h40, key7);
		wb_wr(16'h0C, 2); // Shift in
	end

    // Load key
	$sformat(status, "%s: Load key", prefix);
	wb_wr(16'h40, key0);
	wb_wr(16'h40, key1);
	wb_wr(16'h40, key2);
	wb_wr(16'h40, key3);

    // Update key (generate round keys)
	$sformat(status, "%s: Generate round keys", prefix);
	wb_wr(16'h0C, 1);
	@(posedge clk);
	wb_out = 0; while ((wb_out & 16'h3) != 16'h3) wb_rd(16'h00); 

    // Set IV
	if ((iv0 | iv1 | iv2 | iv3) != 0) begin
		$sformat(status, "%s: Set IV", prefix);
		wb_wr(16'h20, iv0);
		wb_wr(16'h20, iv1);
		wb_wr(16'h20, iv2);
		wb_wr(16'h20, iv3);
	end

    // Load input data
	$sformat(status, "%s: Load input data", prefix);
	wb_wr(16'h10, in0);
	wb_wr(16'h10, in1);
	wb_wr(16'h10, in2);
	wb_wr(16'h10, in3);

	if (enc) $sformat(status, "%s: Run encryption", prefix);
	else $sformat(status, "%s: Run decryption", prefix);

    if (enc) wb_wr(16'h4, 1);
    else wb_wr(16'h8, 1);
	@(posedge clk);

	// Wait until done
	wb_rd(16'h00);
	wb_out = 0; while ((wb_out & 16'h4) != 16'h4) wb_rd(16'h00); 

    // Read back result
	$sformat(status, "%s: Read back result", prefix);
	pass = 1;
	wb_rd(16'h30);
	if (!(wb_out == out0)) pass = 0;
	wb_rd(16'h34);
	if (!(wb_out == out1)) pass = 0;
	wb_rd(16'h38);
	if (!(wb_out == out2)) pass = 0;
	wb_rd(16'h3C);
	if (!(wb_out == out3)) pass = 0;

	// Re-run but in other direction
	if (both) begin
		// Set IV
		if ((iv0 | iv1 | iv2 | iv3) != 0) begin
			$sformat(status, "%s: Set IV", prefix);
			wb_wr(16'h20, iv0);
			wb_wr(16'h20, iv1);
			wb_wr(16'h20, iv2);
			wb_wr(16'h20, iv3);
		end

		// Load input data
		$sformat(status, "%s: Load input data", prefix);
		wb_wr(16'h10, out0);
		wb_wr(16'h10, out1);
		wb_wr(16'h10, out2);
		wb_wr(16'h10, out3);

		// Flipped
		if (enc) $sformat(status, "%s: Run decryption", prefix);
		else $sformat(status, "%s: Run encryption", prefix);
		if (enc) wb_wr(16'h8, 1);
		else wb_wr(16'h4, 1);
		@(posedge clk);

		// Wait until done
		wb_rd(16'h00);
		wb_out = 0; while ((wb_out & 16'h4) != 16'h4) wb_rd(16'h00); 

		// Read back result
		$sformat(status, "%s: Read back result", prefix);
		pass = 1;
		wb_rd(16'h30);
		if (!(wb_out == in0)) pass = 0;
		wb_rd(16'h34);
		if (!(wb_out == in1)) pass = 0;
		wb_rd(16'h38);
		if (!(wb_out == in2)) pass = 0;
		wb_rd(16'h3C);
		if (!(wb_out == in3)) pass = 0;
	end

	if (pass) $display("PASS");
	else $display("FAIL");
endtask


reg [31:0] x = 0;
initial begin
	$dumpfile("build/aes256_tb.vcd");
	$dumpvars(0, uut);
	$dumpvars(0, status);

	clk = 0;
	pwr = 1;

	rst = 1;
	#10
	@(negedge clk);
	rst = 0;

	prefix = "AES256";
	aes_test(1333600292, 2067428908, 724464948, 1210611756,
             2087725097, 2049403466, 1044015937, 1296971573,
             1247963967, 1903436343, 2034596968, 1952329507,
             1570058230, 4070621038, 2773892934, 3961869708,
             846873392, 1043276127, 961370419, 674374475,
             0, 1, 1);

	$display("Done, cycles = %d", $time / 10);
	$finish;
end

endmodule
