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

// Calculate X-position for cactus and floor
module scroll (
    input wire halt,
    output reg [10:0] pos,
    output wire [23:0] speed,

    input wire [7:0] speed_change,
    input wire [7:0] move_amt,

	input wire game_rst,
    input wire clk,
    input wire sys_rst
);

localparam INITIAL_SPEED = 250000; // 10ms at 25Mhz

reg [17:0] ctr;
reg [17:0] tick_time;

assign speed = tick_time;

always @(posedge clk) begin
    if (game_rst || sys_rst) begin
        pos <= 0;
        ctr <= 0;
        tick_time <= INITIAL_SPEED;
    end
    else if (!halt) begin
        ctr <= ctr + 1;
        if(ctr >= tick_time)begin
            ctr <= 0;
            tick_time <= tick_time - speed_change;
            pos <= pos + move_amt;
        end
    end
end

endmodule

