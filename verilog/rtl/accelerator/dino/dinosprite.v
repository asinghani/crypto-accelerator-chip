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
