module morpho_chip_top (

    input clk,
    input rst,

    input sck,
    input mosi,
    input cs,

    input mode,
    input [8:0] se_mask,

    output [63:0] pixel_data_out

);

wire [63:0] spi_data;
wire spi_valid;

spi_slave spi0 (

    .clk(clk),
    .rst(rst),

    .sck(sck),
    .mosi(mosi),
    .cs(cs),

    .data_out(spi_data),
    .data_valid(spi_valid)

);

wire [63:0] morpho_result;

morpho_grid_8x8 morpho_core (

    .clk(clk),
    .mode(mode),
    .se_mask(se_mask),
    .pixels_out(morpho_result)

);

assign pixel_data_out = morpho_result;

endmodule
