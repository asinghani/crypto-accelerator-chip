//SPDX-FileCopyrightText: 2020 Ethan Polcyn & Anish Singhani
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

// Toggles the moving legs on the bottom of the sprite
module dinosprite (
    input wire halt,
	output reg sprite,

	input wire clk,
	input wire sys_rst
);

localparam TOGGLE_DIVIDER = 3000000;

reg [24:0] ctr;

always @(posedge clk) begin
	if (sys_rst) begin
		ctr <= 0;
		sprite <= 0;
	end
    else if (!halt) begin
		ctr <= ctr + 1;
		if (ctr >= TOGGLE_DIVIDER) begin
			sprite <= ~sprite;
			ctr <= 0;
		end
	end
end

endmodule

