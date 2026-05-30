// ============================================================================
// Copyright (c) 2026 Abhinav Basu (abhi15-bose-max)
// This source code is licensed under the MIT license found in the 
// LICENSE file in the root directory of this source tree.
// ============================================================================

`timescale 1ns/1ps

module tb_vertical;

reg clk;
reg mode;
reg [8:0] se_mask;

wire [63:0] pixels_out;

morpho_grid_8x8 uut (
    .clk(clk),
    .mode(mode),
    .se_mask(se_mask),
    .pixels_out(pixels_out)
);

always #5 clk = ~clk;

integer i;

initial begin

    clk = 0;

    #1;

    // dilation
    mode = 1'b1;

    // full square mask
    se_mask = 9'b010010010;;

    $display("=== VERITCAL TEST ===");

    for (i = 0; i < 10; i = i + 1) begin

        #10;

        $display("Cycle %0d:", i);

        $display("%b", pixels_out[63:56]);
        $display("%b", pixels_out[55:48]);
        $display("%b", pixels_out[47:40]);
        $display("%b", pixels_out[39:32]);
        $display("%b", pixels_out[31:24]);
        $display("%b", pixels_out[23:16]);
        $display("%b", pixels_out[15:8]);
        $display("%b", pixels_out[7:0]);

        $display("-------------------");

    end

    $finish;

end

endmodule
