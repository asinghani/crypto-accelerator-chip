// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

`timescale 1 ns / 1 ps

`include "caravel.v"
`include "spiflash.v"

module dino_vga_tb;
	reg clock;
	reg RSTB;
	reg power1, power2;
	reg power3, power4;

	wire gpio;
	wire [37:0] mprj_io;

	initial clock = 0;
	always #12.5 clock <= (clock === 1'b0);

	wire [40:0] dump = {clock, RSTB, gpio, mprj_io};
	initial begin
		$dumpfile("dino_vga.vcd");
		//$dumpvars(0, dino_vga_tb);
		$dumpvars(0, dump);

		$display("Start test...");

		repeat (200) begin
			repeat (1000) @(posedge clock);
		end
		$display ("Finished running test...");
		$finish;
	end

	initial begin
		RSTB <= 1'b0;
		#2000;
		RSTB <= 1'b1;	    // Release reset
	end

	initial begin           // Power-up sequence
		power1 <= 1'b0;
		power2 <= 1'b0;
		power3 <= 1'b0;
		power4 <= 1'b0;
		#200;
		power1 <= 1'b1;
		#200;
		power2 <= 1'b1;
		#200;
		power3 <= 1'b1;
		#200;
		power4 <= 1'b1;
	end

	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;

	wire VDD3V3 = power1;
	wire VDD1V8 = power2;
	wire USER_VDD3V3 = power3;
	wire USER_VDD1V8 = power4;
	wire VSS = 1'b0;

	caravel uut (
		.vddio	  (VDD3V3),
		.vssio	  (VSS),
		.vdda	  (VDD3V3),
		.vssa	  (VSS),
		.vccd	  (VDD1V8),
		.vssd	  (VSS),
		.vdda1    (USER_VDD3V3),
		.vdda2    (USER_VDD3V3),
		.vssa1	  (VSS),
		.vssa2	  (VSS),
		.vccd1	  (USER_VDD1V8),
		.vccd2	  (USER_VDD1V8),
		.vssd1	  (VSS),
		.vssd2	  (VSS),
		.clock	  (clock),
		.gpio     (gpio),
		.mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	rgbs_logger rgb (
		.clk(clock),
		.reset(0),

		.r({mprj_io[32], mprj_io[32], mprj_io[32], 1'b0}),
		.g({mprj_io[32], mprj_io[32], mprj_io[32], 1'b0}),
		.b({mprj_io[32], mprj_io[32], mprj_io[32], 1'b0}),

		.hsync(mprj_io[31]),
		.vsync(mprj_io[30])
	);

	spiflash #(
		.FILENAME("dino_vga.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

endmodule

// From
// https://github.com/dan-rodrigues/caravel_vdp_lite/blob/vdp-lite-master/verilog/dv/vdp_lite/video_frame/video_frame_tb.v
module rgbs_logger #(
    parameter FILENAME = "rgb.log"
) (
    input clk,
    input reset,

    input [3:0] r, g, b,
    input hsync, vsync
);
    integer file;

    initial begin
        file = $fopen(FILENAME, "wb");

        if (!file) begin
            $display("Couldn't open file: %s", FILENAME);
        end
    end

    integer started_writing = 0;

    always @(posedge clk) begin
		$fwrite(file, "%u", {vsync, hsync, {2{r}}, {2{g}}, {2{b}}});

		if (!started_writing) begin
			$display("Started writing RGBS output..");
			started_writing = 1;
		end
    end

endmodule

`default_nettype wire
