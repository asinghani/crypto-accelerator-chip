`default_nettype none

// Calculate X-position for cactus and floor
module rendering (
    output wire pixel,
    output wire collision,
    output reg [2:0] cactus_select,

    input wire game_over,
    input wire game_start_blink,
    input wire score_pixel,
    input wire dinosprite_num,

    input wire [2:0] cactus_type,
    input wire [6:0] jump_pos,
    input wire [9:0] vaddr,
    input wire [9:0] haddr,
    input wire [10:0] scrolladdr,

    input wire clk,
    input wire sys_rst
);

// Load sprites
reg [22:0]  dinosprite1[46:0];
reg [22:0]  dinosprite2[46:0];
reg [22:0]  dinospritedead[46:0];
reg [255:0] floor[5:0];
reg [26:0]  cactussprite1[46:0];
reg [26:0]  cactussprite2[46:0];
reg [12:0]  cactussprite3[48:0];

reg [4:0] layers;

assign pixel = |{score_pixel, layers};
assign collision = layers[0] & (layers[1] | layers[3] | layers[4]);

wire [7:0] flooraddr = haddr+scrolladdr;

always @(posedge clk) begin
    if (sys_rst) begin
        layers <= 0;
        cactus_select <= 0;
    end
    else begin
        layers <= 0;

        if (vaddr < 480 && haddr < 640) begin
            if (haddr > 30 && haddr < 75 && (vaddr + jump_pos) > 155 && (vaddr + jump_pos) < 248 && game_start_blink) begin

                if (game_over) begin
                    layers[0] <= dinospritedead[(vaddr-155+jump_pos) >> 1][(haddr-30) >> 1];
                end
                else begin
                    if (dinosprite_num) begin
                        layers[0] <= dinosprite1[(vaddr-155+jump_pos) >> 1][(haddr-30) >> 1];
                    end
                    else begin
                        layers[0] <= dinosprite2[(vaddr-155+jump_pos) >> 1][(haddr-30) >> 1];
                    end
                end
            end
            if (vaddr > 244 && vaddr < 251) begin
                layers[2] <= floor[vaddr-245][flooraddr];
            end
            if (vaddr > 203 && vaddr < 250) begin
                if (cactus_select[0]) begin
                    if (cactus_type[0]) begin
                        if ((haddr + scrolladdr[9:0]) > 640 && (haddr + scrolladdr[9:0]) < 667) begin
                            layers[1] <= cactussprite1[vaddr-203][haddr-640+scrolladdr[9:0]];
                        end
                    end
                    else begin
                        if ((haddr + scrolladdr[9:0]) > 640 && (haddr + scrolladdr[9:0]) < 667) begin
                            layers[1] <= cactussprite2[vaddr-203][haddr-640+scrolladdr[9:0]];
                        end
                    end
                end
                if (cactus_select[1]) begin
                    if (cactus_type[1]) begin
                        if ((haddr + scrolladdr[9:0]-250) > 640 && (haddr + scrolladdr[9:0]-250) < 667) begin
                            layers[3] <= cactussprite2[vaddr-203][haddr-640+scrolladdr[9:0]-250];
                        end
                    end
                end
                if (cactus_select[2]) begin
                    if (cactus_type[2]) begin
                        if ((haddr + scrolladdr[10:0]-450) > 640 && (haddr + scrolladdr[10:0]-450) < 667) begin
                            layers[4] <= cactussprite1[vaddr-203][haddr-640+scrolladdr[10:0]-450];
                        end
                    end
                    else begin
                        if ((haddr + scrolladdr[10:0]-450) > 640 && (haddr + scrolladdr[10:0]-450) < 667) begin
                            layers[4] <= cactussprite3[vaddr-203][haddr-640+scrolladdr[10:0]-450];
                        end
                    end
                end
            end

            if (scrolladdr[9:0] >= 0 && scrolladdr[9:0] < 10) begin
                cactus_select[0] <= 1;
            end
            else if (scrolladdr[9:0] > 667) begin
                cactus_select[0] <= 0;
            end

            if (scrolladdr[9:0] >= 250 && scrolladdr[9:0] < 260) begin
                cactus_select[1] <= 1;
            end
            else if (scrolladdr[9:0] > 917) begin
                cactus_select[1] <= 0;
            end

            if (scrolladdr[9:0] >= 450 && scrolladdr[9:0] < 460) begin
                cactus_select[2] <= 1;
            end
            else if (scrolladdr[10:0] > 1117) begin
                cactus_select[2] <= 0;
            end

        end
    end
end

initial begin
    dinosprite1[0]  = 22'b0000000000000000000000;
    dinosprite1[1]  = 22'b0000000000000000000000;
    dinosprite1[2]  = 22'b0000000000000000000000;
    dinosprite1[3]  = 22'b0000000000000000000000;
    dinosprite1[4]  = 22'b0000000000000000000000;
    dinosprite1[5]  = 22'b0000000000000000000000;
    dinosprite1[6]  = 22'b0000000000000000000000;
    dinosprite1[7]  = 22'b0000000000000000000000;
    dinosprite1[8]  = 22'b0000000000000000000000;
    dinosprite1[9]  = 22'b0000000000000000000000;
    dinosprite1[10] = 22'b0000000000000000000000;
    dinosprite1[11] = 22'b0000000000000000000000;
    dinosprite1[12] = 22'b0000000000000000000000;
    dinosprite1[13] = 22'b0000000000000000000000;
    dinosprite1[14] = 22'b0000000000000000000000;
    dinosprite1[15] = 22'b0000000000000000000000;
    dinosprite1[16] = 22'b0000000000000000000000;
    dinosprite1[17] = 22'b0000000000000000000000;
    dinosprite1[18] = 22'b0000000000000000000000;
    dinosprite1[19] = 22'b0000000000000000000000;
    dinosprite1[20] = 22'b0000000000000000000000;
    dinosprite1[21] = 22'b0000000000000000000000;
    dinosprite1[22] = 22'b0000000000000000000000;
    dinosprite1[23] = 22'b0011111111000000000000;
    dinosprite1[24] = 22'b0111111111100000000000;
    dinosprite1[25] = 22'b0111111101100000000000;
    dinosprite1[26] = 22'b0111111111100000000000;
    dinosprite1[27] = 22'b0111111111100000000000;
    dinosprite1[28] = 22'b0111111111100000000000;
    dinosprite1[29] = 22'b0000001111100000000000;
    dinosprite1[30] = 22'b0001111111100000000000;
    dinosprite1[31] = 22'b0000000111110000000010;
    dinosprite1[32] = 22'b0000000111111100000010;
    dinosprite1[33] = 22'b0000011111111110000110;
    dinosprite1[34] = 22'b0000010111111111001110;
    dinosprite1[35] = 22'b0000000111111111111110;
    dinosprite1[36] = 22'b0000000111111111111110;
    dinosprite1[37] = 22'b0000000011111111111100;
    dinosprite1[38] = 22'b0000000011111111111000;
    dinosprite1[39] = 22'b0000000001111111110000;
    dinosprite1[40] = 22'b0000000000111111100000;
    dinosprite1[41] = 22'b0000000000110011000000;
    dinosprite1[42] = 22'b0000000000100110000000;
    dinosprite1[43] = 22'b0000000000100000000000;
    dinosprite1[44] = 22'b0000000001100000000000;
    dinosprite1[45] = 22'b0000000000000000000000;
    dinosprite1[46] = 22'b0000000000000000000000;
end

initial begin
    dinosprite2[0]  = 22'b0000000000000000000000;
    dinosprite2[1]  = 22'b0000000000000000000000;
    dinosprite2[2]  = 22'b0000000000000000000000;
    dinosprite2[3]  = 22'b0000000000000000000000;
    dinosprite2[4]  = 22'b0000000000000000000000;
    dinosprite2[5]  = 22'b0000000000000000000000;
    dinosprite2[6]  = 22'b0000000000000000000000;
    dinosprite2[7]  = 22'b0000000000000000000000;
    dinosprite2[8]  = 22'b0000000000000000000000;
    dinosprite2[9]  = 22'b0000000000000000000000;
    dinosprite2[10] = 22'b0000000000000000000000;
    dinosprite2[11] = 22'b0000000000000000000000;
    dinosprite2[12] = 22'b0000000000000000000000;
    dinosprite2[13] = 22'b0000000000000000000000;
    dinosprite2[14] = 22'b0000000000000000000000;
    dinosprite2[15] = 22'b0000000000000000000000;
    dinosprite2[16] = 22'b0000000000000000000000;
    dinosprite2[17] = 22'b0000000000000000000000;
    dinosprite2[18] = 22'b0000000000000000000000;
    dinosprite2[19] = 22'b0000000000000000000000;
    dinosprite2[20] = 22'b0000000000000000000000;
    dinosprite2[21] = 22'b0000000000000000000000;
    dinosprite2[22] = 22'b0000000000000000000000;
    dinosprite2[23] = 22'b0011111111000000000000;
    dinosprite2[24] = 22'b0111111111100000000000;
    dinosprite2[25] = 22'b0111111101100000000000;
    dinosprite2[26] = 22'b0111111111100000000000;
    dinosprite2[27] = 22'b0111111111100000000000;
    dinosprite2[28] = 22'b0111111111100000000000;
    dinosprite2[29] = 22'b0000001111100000000000;
    dinosprite2[30] = 22'b0001111111100000000000;
    dinosprite2[31] = 22'b0000000111110000000010;
    dinosprite2[32] = 22'b0000000111111100000010;
    dinosprite2[33] = 22'b0000011111111110000110;
    dinosprite2[34] = 22'b0000010111111111001110;
    dinosprite2[35] = 22'b0000000111111111111110;
    dinosprite2[36] = 22'b0000000111111111111110;
    dinosprite2[37] = 22'b0000000011111111111100;
    dinosprite2[38] = 22'b0000000011111111111000;
    dinosprite2[39] = 22'b0000000001111111110000;
    dinosprite2[40] = 22'b0000000000111111100000;
    dinosprite2[41] = 22'b0000000001100111000000;
    dinosprite2[42] = 22'b0000000000000011000000;
    dinosprite2[43] = 22'b0000000000000011000000;
    dinosprite2[44] = 22'b0000000000000011000000;
    dinosprite2[45] = 22'b0000000000000000000000;
    dinosprite2[46] = 22'b0000000000000000000000;
end

initial begin
    dinospritedead[0]  = 22'b0000000000000000000000;
    dinospritedead[1]  = 22'b0000000000000000000000;
    dinospritedead[2]  = 22'b0000000000000000000000;
    dinospritedead[3]  = 22'b0000000000000000000000;
    dinospritedead[4]  = 22'b0000000000000000000000;
    dinospritedead[5]  = 22'b0000000000000000000000;
    dinospritedead[6]  = 22'b0000000000000000000000;
    dinospritedead[7]  = 22'b0000000000000000000000;
    dinospritedead[8]  = 22'b0000000000000000000000;
    dinospritedead[9]  = 22'b0000000000000000000000;
    dinospritedead[10] = 22'b0000000000000000000000;
    dinospritedead[11] = 22'b0000000000000000000000;
    dinospritedead[12] = 22'b0000000000000000000000;
    dinospritedead[13] = 22'b0000000000000000000000;
    dinospritedead[14] = 22'b0000000000000000000000;
    dinospritedead[15] = 22'b0000000000000000000000;
    dinospritedead[16] = 22'b0000000000000000000000;
    dinospritedead[17] = 22'b0000000000000000000000;
    dinospritedead[18] = 22'b0000000000000000000000;
    dinospritedead[19] = 22'b0000000000000000000000;
    dinospritedead[20] = 22'b0000000000000000000000;
    dinospritedead[21] = 22'b0000000000000000000000;
    dinospritedead[22] = 22'b0000000000000000000000;
    dinospritedead[23] = 22'b0011111111000000000000;
    dinospritedead[24] = 22'b0111111111100000000000;
    dinospritedead[25] = 22'b0111111101100000000000;
    dinospritedead[26] = 22'b0111111111100000000000;
    dinospritedead[27] = 22'b0111111111100000000000;
    dinospritedead[28] = 22'b0111111111100000000000;
    dinospritedead[29] = 22'b0111111111100000000000;
    dinospritedead[30] = 22'b0001111111100000000000;
    dinospritedead[31] = 22'b0000000111110000000010;
    dinospritedead[32] = 22'b0000000111111100000010;
    dinospritedead[33] = 22'b0000011111111110000110;
    dinospritedead[34] = 22'b0000010111111111001110;
    dinospritedead[35] = 22'b0000000111111111111110;
    dinospritedead[36] = 22'b0000000111111111111110;
    dinospritedead[37] = 22'b0000000011111111111100;
    dinospritedead[38] = 22'b0000000011111111111000;
    dinospritedead[39] = 22'b0000000001111111110000;
    dinospritedead[40] = 22'b0000000000111111100000;
    dinospritedead[41] = 22'b0000000000110111000000;
    dinospritedead[42] = 22'b0000000000100011000000;
    dinospritedead[43] = 22'b0000000000100001000000;
    dinospritedead[44] = 22'b0000000001100011000000;
    dinospritedead[45] = 22'b0000000000000000000000;
    dinospritedead[46] = 22'b0000000000000000000000;
end

initial begin
    cactussprite1[0]  = 26'b00000000000000000011000000;
    cactussprite1[1]  = 26'b00000000000000000011100000;
    cactussprite1[2]  = 26'b00001000000000000011100000;
    cactussprite1[3]  = 26'b00001100000000000011100000;
    cactussprite1[4]  = 26'b00001100000000000011100000;
    cactussprite1[5]  = 26'b00001100000000000011100000;
    cactussprite1[6]  = 26'b00001100000000100011100000;
    cactussprite1[7]  = 26'b00001100000000110011100000;
    cactussprite1[8]  = 26'b00001100100000110011100000;
    cactussprite1[9]  = 26'b00001100100000110011100000;
    cactussprite1[10] = 26'b00001100100000110011100000;
    cactussprite1[11] = 26'b00001100100000110011100100;
    cactussprite1[12] = 26'b00001100100000110011100110;
    cactussprite1[13] = 26'b00001100100000110011100110;
    cactussprite1[14] = 26'b00001100100000110011100110;
    cactussprite1[15] = 26'b00001100100000110011100110;
    cactussprite1[16] = 26'b01001100100000110011100110;
    cactussprite1[17] = 26'b01001111100000110011100110;
    cactussprite1[18] = 26'b01001111000000110011100110;
    cactussprite1[19] = 26'b01001111000000110011100110;
    cactussprite1[20] = 26'b01001100001000111111100110;
    cactussprite1[21] = 26'b01001100001000111111100110;
    cactussprite1[22] = 26'b01001100001000111111100110;
    cactussprite1[23] = 26'b01001100001000011111100110;
    cactussprite1[24] = 26'b01001100001000011111100110;
    cactussprite1[25] = 26'b01001100101001000011100110;
    cactussprite1[26] = 26'b01001100101001000011100100;
    cactussprite1[27] = 26'b01001100101001000011111100;
    cactussprite1[28] = 26'b01001100101001000011111000;
    cactussprite1[29] = 26'b01111100101001000011111000;
    cactussprite1[30] = 26'b01111100101001000011100000;
    cactussprite1[31] = 26'b00111100101001000011100000;
    cactussprite1[32] = 26'b00111100101001000011100000;
    cactussprite1[33] = 26'b00001100101001000011100000;
    cactussprite1[34] = 26'b00001100111110000011100000;
    cactussprite1[35] = 26'b00001100011110000011100000;
    cactussprite1[36] = 26'b00001100011000000011100000;
    cactussprite1[37] = 26'b00001100001000000011100000;
    cactussprite1[38] = 26'b00001100001000000011100000;
    cactussprite1[39] = 26'b00001100001000000011100000;
    cactussprite1[40] = 26'b00001100001000000011100000;
    cactussprite1[41] = 26'b00001100001000000011100000;
    cactussprite1[42] = 26'b00001100001000000011100000;
    cactussprite1[43] = 26'b00001100001000000011100000;
    cactussprite1[44] = 26'b00001100001000000011100000;
    cactussprite1[45] = 26'b00001100001000000011100000;
    cactussprite1[46] = 26'b00001100001000000111100000;
end

initial begin
    cactussprite2[0]  = 13'b0000000000000;
    cactussprite2[1]  = 13'b0000001000000;
    cactussprite2[2]  = 13'b0000011100000;
    cactussprite2[3]  = 13'b0000011100000;
    cactussprite2[4]  = 13'b0000011100000;
    cactussprite2[5]  = 13'b0000011100000;
    cactussprite2[6]  = 13'b0100011100000;
    cactussprite2[7]  = 13'b0110011100000;
    cactussprite2[8]  = 13'b0110011100000;
    cactussprite2[9]  = 13'b0110011100000;
    cactussprite2[10] = 13'b0110011100000;
    cactussprite2[11] = 13'b0110011100100;
    cactussprite2[12] = 13'b0110011100110;
    cactussprite2[13] = 13'b0110011100110;
    cactussprite2[14] = 13'b0110011100110;
    cactussprite2[15] = 13'b0110011100110;
    cactussprite2[16] = 13'b0110011100110;
    cactussprite2[17] = 13'b0110011100110;
    cactussprite2[18] = 13'b0110011100110;
    cactussprite2[19] = 13'b0110011100110;
    cactussprite2[20] = 13'b0110011100110;
    cactussprite2[21] = 13'b0111111100110;
    cactussprite2[22] = 13'b0111111100110;
    cactussprite2[23] = 13'b0011111100110;
    cactussprite2[24] = 13'b0011111100110;
    cactussprite2[25] = 13'b0001111100110;
    cactussprite2[26] = 13'b0000011100110;
    cactussprite2[27] = 13'b0000011111100;
    cactussprite2[28] = 13'b0000011111100;
    cactussprite2[29] = 13'b0000011111000;
    cactussprite2[30] = 13'b0000011111000;
    cactussprite2[31] = 13'b0000011100000;
    cactussprite2[32] = 13'b0000011100000;
    cactussprite2[33] = 13'b0000011100000;
    cactussprite2[34] = 13'b0000011100000;
    cactussprite2[35] = 13'b0000011100000;
    cactussprite2[36] = 13'b0000011100000;
    cactussprite2[37] = 13'b0000011100000;
    cactussprite2[38] = 13'b0000011100000;
    cactussprite2[39] = 13'b0000011100000;
    cactussprite2[40] = 13'b0000011100000;
    cactussprite2[41] = 13'b0000011100000;
    cactussprite2[42] = 13'b0000011100000;
    cactussprite2[43] = 13'b0000011100000;
    cactussprite2[44] = 13'b0000011100000;
    cactussprite2[45] = 13'b0000011100000;
    cactussprite2[46] = 13'b0000111100000;
end

initial begin
    cactussprite3[0]  = 13'b0000000000000;
    cactussprite3[1]  = 13'b0000001100000;
    cactussprite3[2]  = 13'b0000011100000;
    cactussprite3[3]  = 13'b0000011100000;
    cactussprite3[4]  = 13'b0000011100000;
    cactussprite3[5]  = 13'b0000011100000;
    cactussprite3[6]  = 13'b0000011100000;
    cactussprite3[7]  = 13'b0000011100000;
    cactussprite3[8]  = 13'b0000011100000;
    cactussprite3[9]  = 13'b0000011100000;
    cactussprite3[10] = 13'b0000011100000;
    cactussprite3[11] = 13'b0000011100110;
    cactussprite3[12] = 13'b0000011100110;
    cactussprite3[13] = 13'b0110011100110;
    cactussprite3[14] = 13'b0110011100110;
    cactussprite3[15] = 13'b0110011100110;
    cactussprite3[16] = 13'b0110011100110;
    cactussprite3[17] = 13'b0110011100110;
    cactussprite3[18] = 13'b0110011100110;
    cactussprite3[19] = 13'b0110011100110;
    cactussprite3[20] = 13'b0110011100110;
    cactussprite3[21] = 13'b0110011100110;
    cactussprite3[22] = 13'b0110011100110;
    cactussprite3[23] = 13'b0110011100110;
    cactussprite3[24] = 13'b0110011100110;
    cactussprite3[25] = 13'b0110011100110;
    cactussprite3[26] = 13'b0110011100110;
    cactussprite3[27] = 13'b0111111111110;
    cactussprite3[28] = 13'b0111111111100;
    cactussprite3[29] = 13'b0111111111100;
    cactussprite3[30] = 13'b0011111111000;
    cactussprite3[31] = 13'b0011111100000;
    cactussprite3[32] = 13'b0000011100000;
    cactussprite3[33] = 13'b0000011100000;
    cactussprite3[34] = 13'b0000011100000;
    cactussprite3[35] = 13'b0000011100000;
    cactussprite3[36] = 13'b0000011100000;
    cactussprite3[37] = 13'b0000011100000;
    cactussprite3[38] = 13'b0000011100000;
    cactussprite3[39] = 13'b0000011100000;
    cactussprite3[40] = 13'b0000011100000;
    cactussprite3[41] = 13'b0000011100000;
    cactussprite3[42] = 13'b0000011100000;
    cactussprite3[43] = 13'b0000011100000;
    cactussprite3[44] = 13'b0000011100000;
    cactussprite3[45] = 13'b0000011100000;
    cactussprite3[46] = 13'b0000111100000;
    cactussprite3[47] = 13'b0000000000000;
    cactussprite3[48] = 13'b0000000010000;
end

initial begin
    floor[0] = 255'b000000000000000000000000000000000000000000000000000000000000000000000000000000001110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011100000000000000000000000000000000000000000000;
    floor[1] = 255'b111111111111111111111111111111111111111111111111111111111111111111111111111111110011111000111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111100111110001111111111111111111111111111111111111;
    floor[2] = 255'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111000000000000000000000000000000000000;
    floor[3] = 255'b000000001000000000000010000000000000001101100000010000000000010000000000000000000000010000001000000000010000000000000000000000100000000010000000000000100000000000000011011000000100000000000100000000000000000000000100000010000000000100000000000000000000001;
    floor[4] = 255'b010000000000001000000000000100000000000000000000000000000000000001000010000000000100000000000010000000001000000001000100010000000100000000000010000000000001000000000000000000000000000000000000010000100000000001000000000000100000000010000000010001000100000;
    floor[5] = 255'b001100000000000000000000000001000000000000000000100100000001100000000000000000000000000000000000000000000000000000000000000000000011000000000000000000000000010000000000000000001001000000011000000000000000000000000000000000000000000000000000000000000000000;
end

endmodule
