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

// LFSR for generating cacti
module rng (
    input wire entropy_in,
    output reg [4:0] out,
    input wire clk,
    input wire sys_rst
);

always @(posedge clk) begin
    if (sys_rst) begin
        out <= 1;
    end
    else if (entropy_in) begin
        out[0] <= out[1] ^ out[4];
        out[1] <= out[0];
        out[2] <= out[1];
        out[3] <= out[2];
        out[4] <= out[3];
    end
end

endmodule

