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

// Generate VGA timings and address/sync signals
module vga (
    output reg [9:0] vaddr,
    output reg [9:0] haddr,
    output reg vsync,
    output reg hsync,

    input wire sys_rst,
    input wire clk
);

always @(posedge clk) begin
    if (sys_rst) begin
        vaddr <= 0;
        haddr <= 0;

        vsync <= 1;
        hsync <= 1;
    end
    else begin
        hsync <= 1;
        haddr <= haddr + 1;

        // Horizontal sync region
        if (haddr >= 656 && haddr < 752) begin
            hsync <= 1'b0;
        end
        
        // End of row
        if (haddr >= 800) begin
            haddr <= 0;
            vaddr <= vaddr + 1;

            // Vertical sync region
            if (vaddr >= 490 && vaddr < 492) begin
                vsync <= 0;
            end
            else begin
                vsync <= 1;
            end
            
            // End of frame
            if (vaddr >= 525) begin
                vaddr <= 0;
            end
        end
    end
end

endmodule

