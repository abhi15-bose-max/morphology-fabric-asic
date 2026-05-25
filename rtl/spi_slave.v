module spi_slave (

    input clk,
    input rst,

    input sck,
    input mosi,
    input cs,

    output reg [63:0] data_out,
    output reg data_valid

);

reg [5:0] bit_count;

always @(posedge sck or posedge rst) begin

    if (rst) begin
        bit_count <= 0;
        data_out <= 0;
        data_valid <= 0;
    end

    else if (!cs) begin

        data_out <= {data_out[62:0], mosi};

        if (bit_count == 63) begin
            bit_count <= 0;
            data_valid <= 1;
        end

        else begin
            bit_count <= bit_count + 1;
            data_valid <= 0;
        end

    end

end

endmodule
