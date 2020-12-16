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
