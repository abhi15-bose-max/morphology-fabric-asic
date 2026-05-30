// ============================================================================
// Copyright (c) 2026 Abhinav Basu (abhi15-bose-max)
// This source code is licensed under the MIT license found in the 
// LICENSE file in the root directory of this source tree.
// ============================================================================

module morpho_cell (
    input clk,

    input self,
    input north,
    input south,
    input east,
    input west,
    input ne,
    input nw,
    input se,
    input sw,

    input [8:0] se_mask,

    input mode,

    output reg pixel_out
);

wire m_nw = se_mask[8] ? nw : (mode ? 1'b0 : 1'b1);
wire m_n  = se_mask[7] ? north : (mode ? 1'b0 : 1'b1);
wire m_ne = se_mask[6] ? ne : (mode ? 1'b0 : 1'b1);

wire m_w  = se_mask[5] ? west : (mode ? 1'b0 : 1'b1);
wire m_c  = se_mask[4] ? self : (mode ? 1'b0 : 1'b1);
wire m_e  = se_mask[3] ? east : (mode ? 1'b0 : 1'b1);

wire m_sw = se_mask[2] ? sw : (mode ? 1'b0 : 1'b1);
wire m_s  = se_mask[1] ? south : (mode ? 1'b0 : 1'b1);
wire m_se = se_mask[0] ? se : (mode ? 1'b0 : 1'b1);

wire erosion_result =
    m_nw & m_n & m_ne &
    m_w  & m_c & m_e &
    m_sw & m_s & m_se;

wire dilation_result =
    m_nw | m_n | m_ne |
    m_w  | m_c | m_e |
    m_sw | m_s | m_se;

always @(posedge clk) begin
    pixel_out <= mode ? dilation_result : erosion_result;
end

endmodule
