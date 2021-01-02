`default_nettype none
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

`timescale 1 ns / 1 ps

`include "caravel.v"
`include "spiflash.v"

module aes_tb;

	reg clock;
	reg power1;
	reg power2;
	reg RSTB;
	reg CSB;

	always #10 clock <= (clock === 1'b0);

	initial begin
		clock <= 0;
	end

	initial begin
		$dumpfile("aes.vcd");
		$dumpvars(0, aes_tb);

		`ifdef GL
			$display("Res: Starting AES (GL) test");
		`else
			$display("Res: Starting AES (RTL) test");
		`endif

		repeat (800) begin
			repeat (1000) @(posedge clock);
		end

		$display ("Res: Timeout, AES test FAILED");
		$finish;
	end

	wire [37:0] mprj_io;
	assign mprj_io[3] = CSB ? 1'b1 : 1'bZ;

	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;
	wire gpio;

	initial begin
		RSTB <= 1'b0;
		CSB  <= 1'b1;	// Force CSB high
		#2000;
		RSTB <= 1'b1;	// Release reset
	end

	initial begin
		power1 <= 1'b0;
		power2 <= 1'b0;
		#200;
		power1 <= 1'b1;
		#200;
		power2 <= 1'b1;
	end


	wire VDD3V3;
	wire VDD1V8;
	wire VSS;

	assign VDD3V3 = power1;
	assign VDD1V8 = power2;
	assign VSS = 1'b0;

	// Printf I/O
	always @(posedge gpio) begin
		CSB = 1'b0;		// CSB can be released
		#1
		$write("%c", mprj_io[15:8]);
		if (mprj_io[15:8] == 8'h04) begin // End of test
			$display("Res: AES test completed! (see results above)");
			$finish;
		end
	end

	caravel uut (
		.vddio	  (VDD3V3),
		.vssio	  (VSS),
		.vdda	  (VDD3V3),
		.vssa	  (VSS),
		.vccd	  (VDD1V8),
		.vssd	  (VSS),
		.vdda1    (VDD3V3),
		.vdda2    (VDD3V3),
		.vssa1	  (VSS),
		.vssa2	  (VSS),
		.vccd1	  (VDD1V8),
		.vccd2	  (VDD1V8),
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

	spiflash #(
		.FILENAME("aes.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

endmodule
`default_nettype wire
