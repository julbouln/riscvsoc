module uart_wb(input  clk,
    input  wire        rst,
    output         serial_out,
    input          serial_in,

    input [29:0] addr_i,
    input [31:0] data_i,
    output [31:0] data_o,
    input we_i,
    input stb_i,
    input cyc_i,
    output ack_o

    );

wire [7:0] rx_byte;
wire tx_busy;

wire [7:0] tx_byte = data_i[7:0];
wire transmit = stb_i & we_i;

assign data_o = addr_i[0] ? {15'd0, !tx_busy, 16'd0} : {15'd0, is_receiving, is_receiving, 7'd0, rx_byte};
assign ack_o = !tx_busy & !is_receiving;

wire is_receiving;

wire received;
wire recv_error;

  uart uart(
    .clk(clk),
    .rst(rst),
    .rx(serial_in),
    .tx(serial_out),
    .transmit(transmit),
    .tx_byte(tx_byte),
    .received(received),
    .rx_byte(rx_byte),
    .is_receiving(is_receiving),
    .is_transmitting(tx_busy),
    .recv_error(recv_error)
    );

always @(posedge clk) begin
      if (we_i)
//         $display("UART WROTE %x (%c)", writedata[7:0], writedata[7:0]);
        $write("%c",data_i[7:0]);
      end

endmodule
