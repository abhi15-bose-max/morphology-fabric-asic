// ============================================================================
// Copyright (c) 2026 Abhinav Basu (abhi15-bose-max)
// This source code is licensed under the MIT license found in the 
// LICENSE file in the root directory of this source tree.
// ============================================================================


module morpho_grid_8x8 (
    input clk,
    input mode,
    input [8:0] se_mask,
    output [63:0] pixels_out
);

reg [63:0] pixels;
wire [63:0] next_pixels;

initial begin
    pixels = 64'h8040201008040201;;
end

genvar r, c;

generate
    for (r = 0; r < 8; r = r + 1) begin : rows
        for (c = 0; c < 8; c = c + 1) begin : cols

            localparam idx = r*8 + c;

            wire self = pixels[idx];

            wire north = (r == 0) ? 1'b0 :
                         pixels[(r-1)*8 + c];

            wire south = (r == 7) ? 1'b0 :
                         pixels[(r+1)*8 + c];

            wire west = (c == 0) ? 1'b0 :
                        pixels[r*8 + (c-1)];

            wire east = (c == 7) ? 1'b0 :
                        pixels[r*8 + (c+1)];

            wire nw = (r == 0 || c == 0) ? 1'b0 :
                      pixels[(r-1)*8 + (c-1)];

            wire ne = (r == 0 || c == 7) ? 1'b0 :
                      pixels[(r-1)*8 + (c+1)];

            wire sw = (r == 7 || c == 0) ? 1'b0 :
                      pixels[(r+1)*8 + (c-1)];

            wire se = (r == 7 || c == 7) ? 1'b0 :
                      pixels[(r+1)*8 + (c+1)];

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
