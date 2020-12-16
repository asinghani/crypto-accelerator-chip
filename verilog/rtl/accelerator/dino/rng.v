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
