`default_nettype none

// Processes jump physics
module jumping (
	input wire jump,
	input wire halt,
    
    input wire [23:0] speed,
	output reg [6:0] jump_pos,

	input wire game_rst,
	input wire clk,
	input wire sys_rst
);

reg [23:0] ctr;
reg [8:0] frame;
reg in_air;

reg [6:0] y_table[50:0];

always @(posedge clk) begin
	if (game_rst || sys_rst) begin
		ctr <= 0;
		frame <= 0;
		in_air <= 0;
	end
    else begin
        jump_pos <= y_table[frame];

        if (!halt) begin
            if (in_air) begin
                ctr <= ctr + 1;
                if (ctr == speed) begin
                    ctr <= 0;
                    frame <= frame + 1;

                    if (frame + 1 >= 50) begin
                        frame <= 0;
                        in_air <= 0;
                    end
                end
            end
            else if (jump) begin
                in_air <= 1;
            end
        end
    end
end

// Load precomputed jump heights
initial begin
    y_table[0]  = 7'b0000000;
    y_table[1]  = 7'b0000110;
    y_table[2]  = 7'b0001100;
    y_table[3]  = 7'b0010010;
    y_table[4]  = 7'b0010111;
    y_table[5]  = 7'b0011100;
    y_table[6]  = 7'b0100001;
    y_table[7]  = 7'b0100110;
    y_table[8]  = 7'b0101011;
    y_table[9]  = 7'b0101111;
    y_table[10] = 7'b0110011;
    y_table[11] = 7'b0110110;
    y_table[12] = 7'b0111010;
    y_table[13] = 7'b0111101;
    y_table[14] = 7'b1000000;
    y_table[15] = 7'b1000011;
    y_table[16] = 7'b1000101;
    y_table[17] = 7'b1000111;
    y_table[18] = 7'b1001001;
    y_table[19] = 7'b1001011;
    y_table[20] = 7'b1001100;
    y_table[21] = 7'b1001101;
    y_table[22] = 7'b1001110;
    y_table[23] = 7'b1001111;
    y_table[24] = 7'b1001111;
    y_table[25] = 7'b1010000;
    y_table[26] = 7'b1001111;
    y_table[27] = 7'b1001111;
    y_table[28] = 7'b1001110;
    y_table[29] = 7'b1001101;
    y_table[30] = 7'b1001100;
    y_table[31] = 7'b1001011;
    y_table[32] = 7'b1001001;
    y_table[33] = 7'b1000111;
    y_table[34] = 7'b1000101;
    y_table[35] = 7'b1000011;
    y_table[36] = 7'b1000000;
    y_table[37] = 7'b0111101;
    y_table[38] = 7'b0111010;
    y_table[39] = 7'b0110110;
    y_table[40] = 7'b0110011;
    y_table[41] = 7'b0101111;
    y_table[42] = 7'b0101011;
    y_table[43] = 7'b0100110;
    y_table[44] = 7'b0100001;
    y_table[45] = 7'b0011100;
    y_table[46] = 7'b0010111;
    y_table[47] = 7'b0010010;
    y_table[48] = 7'b0001100;
    y_table[49] = 7'b0000110;
    y_table[50] = 7'b0000000;
end


endmodule
