// ============================================================================
// Copyright (c) 2026 Abhinav Basu (abhi15-bose-max)
// This source code is licensed under the MIT license found in the 
// LICENSE file in the root directory of this source tree.
// ============================================================================


module morpho_grid_4x4 (
    input clk,
    input mode,
    input [8:0] se_mask,
    output [15:0] pixels_out
);

reg [15:0] pixels;

wire [15:0] next_pixels;

initial begin
    // Simple test pattern
    pixels = 16'b0000_0110_0110_0000;
end

// Generate 16 cells
genvar r, c;

generate
    for (r = 0; r < 4; r = r + 1) begin : rows
        for (c = 0; c < 4; c = c + 1) begin : cols

            localparam idx = r*4 + c;

            wire self  = pixels[idx];

            wire north = (r == 0) ? 1'b0 : pixels[(r-1)*4 + c];
            wire south = (r == 3) ? 1'b0 : pixels[(r+1)*4 + c];

            wire west  = (c == 0) ? 1'b0 : pixels[r*4 + (c-1)];
            wire east  = (c == 3) ? 1'b0 : pixels[r*4 + (c+1)];

            wire nw = (r == 0 || c == 0) ? 1'b0 :
                      pixels[(r-1)*4 + (c-1)];

            wire ne = (r == 0 || c == 3) ? 1'b0 :
                      pixels[(r-1)*4 + (c+1)];

            wire sw = (r == 3 || c == 0) ? 1'b0 :
                      pixels[(r+1)*4 + (c-1)];

            wire se = (r == 3 || c == 3) ? 1'b0 :
                      pixels[(r+1)*4 + (c+1)];

            morpho_cell u_cell (
                .clk(clk),

                .self(self),
                .north(north),
                .south(south),
                .east(east),
                .west(west),

                .ne(ne),
                .nw(nw),
                .se(se),
                .sw(sw),

                .se_mask(se_mask),

                .mode(mode),

                .pixel_out(next_pixels[idx])
            );

        end
    end
endgenerate

always @(posedge clk) begin
    pixels <= next_pixels;
end

assign pixels_out = pixels;

endmodule
