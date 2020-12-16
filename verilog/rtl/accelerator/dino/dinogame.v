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

`ifdef SIM
`include "accelerator/dino/dinosprite.v"
`include "accelerator/dino/jumping.v"
`include "accelerator/dino/rendering.v"
`include "accelerator/dino/rng.v"
`include "accelerator/dino/score.v"
`include "accelerator/dino/scroll.v"
`include "accelerator/dino/vga.v"
`else
`include "./dinosprite.v"
`include "./jumping.v"
`include "./rendering.v"
`include "./rng.v"
`include "./score.v"
`include "./scroll.v"
`include "./vga.v"
`endif

module dinogame (
    input wire jump_in,
    input wire halt_in,
    input wire debug_in,

    output wire vga_hsync,
    output wire vga_vsync,
    output wire [3:0] vga_red,
    output wire [3:0] vga_green,
    output wire [3:0] vga_blue,
    output wire vga_pixel,

`ifdef DINO_CONFIG
    output wire dbg_reset,
    output wire dbg_halt,

    output wire dbg_pixel,
    output wire [10:0] dbg_scrolladdr,
    output wire [23:0] dbg_speed,
    output wire [15:0] dbg_score,

    input wire [3:0] cfg_accel,
`endif
    input wire [3:0] cfg_speed,

    input wire clk,
    input wire sys_rst
);

assign vga_red = {4{vga_pixel}};
assign vga_green = {4{vga_pixel}};
assign vga_blue = {4{vga_pixel}};


localparam START_TIME = 30000000;
reg [31:0] start_ctr;
wire game_reset = game_over & jump_in & (no_jump_ctr > 100000);
wire game_halt = game_over || halt_in || (start_ctr < START_TIME);

wire [23:0] speed;
wire [2:0] cactus_select;
reg [2:0] cactus_select_last;
reg [2:0] cactus_type;
wire collision;

wire [10:0] scrolladdr;
wire [9:0] vaddr;
wire [9:0] haddr;
wire [6:0] jump_pos;
wire [4:0] random;
wire dinosprite_num;
wire score_pixel;

wire [15:0] score_out;

reg game_over;
reg [19:0] no_jump_ctr;

`ifdef DINO_CONFIG
    assign dbg_reset = game_reset;
    assign dbg_halt = game_halt;

    assign dbg_pixel = vga_pixel;
    assign dbg_scrolladdr = scrolladdr;
    assign dbg_speed = speed;
    assign dbg_score = score_out;
`else
    wire [3:0] cfg_accel = 4;
`endif


jumping jumping_inst (
    .speed(250000),
    .jump(jump_in),
    .jump_pos(jump_pos),
    .halt(game_halt),

    .game_rst(game_reset),
    .clk(clk),
    .sys_rst(sys_rst)
);

dinosprite dinosprite_inst (
    .halt(game_halt),
    .sprite(dinosprite_num),

    .clk(clk),
    .sys_rst(sys_rst)
);

scroll scroll_inst (
    .speed(speed),
    .pos(scrolladdr[10:0]),
    .halt(game_halt),

    .speed_change(cfg_accel),
    .move_amt(cfg_speed),

    .game_rst(game_reset),
    .clk(clk),
    .sys_rst(sys_rst)
);

vga vga_inst (
    .vaddr(vaddr),
    .haddr(haddr),
    .hsync(vga_hsync),
    .vsync(vga_vsync),

    .clk(clk),
    .sys_rst(sys_rst)
);

rng rng_inst (
    .entropy_in(jump_in),
    .out(random),

    .clk(clk),
    .sys_rst(sys_rst)
);

score score_inst (
    .halt(game_halt),
    .vaddr(vaddr),
    .haddr(haddr),
    .pixel(score_pixel),
    .score_out(score_out),

    .game_rst(game_reset),
    .clk(clk),
    .sys_rst(sys_rst)
);

rendering rendering_inst (
    .pixel(vga_pixel),
    .collision(collision),
    .cactus_select(cactus_select),

    .game_over(game_over),
    .game_start_blink(start_ctr >= START_TIME || start_ctr[22] || game_over),
    .score_pixel(score_pixel),
    .dinosprite_num(dinosprite_num),

    .cactus_type(cactus_type),
    .jump_pos(jump_pos),
    .vaddr(vaddr),
    .haddr(haddr),
    .scrolladdr(scrolladdr),

    .clk(clk),
    .sys_rst(sys_rst)
);

always @(posedge clk) begin
    if (sys_rst) begin
        no_jump_ctr <= 0;
        start_ctr <= 0;
        game_over <= 1;
        cactus_type <= 0;
        cactus_select_last <= 0;
    end
    else begin
        if (jump_in) no_jump_ctr <= 0;
        else no_jump_ctr <= no_jump_ctr + 1;

        if (game_reset) start_ctr <= 0;
        else if (start_ctr < START_TIME) start_ctr <= start_ctr + 1;

        if (collision && ~debug_in) game_over <= 1;
        if (game_reset) game_over <= 0;

        if (cactus_select[2] && !cactus_select_last[2]) cactus_type[2] <= random[4];
        if (cactus_select[1] && !cactus_select_last[1]) cactus_type[1] <= random[3];
        if (cactus_select[0] && !cactus_select_last[0]) cactus_type[0] <= random[2];
        cactus_select_last <= cactus_select;
    end
end

endmodule

