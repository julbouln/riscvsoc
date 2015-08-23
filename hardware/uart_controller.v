module uart_controller(input  clk,
    output         serial_out,
    input          serial_in,
    input  wire        reset,

    input  wire        rw,
    input  wire        writeenable,
    input  wire [31:0] writedata,
    input  wire        readenable,
    output reg  [31:0] readdata = 32 'h eeee_eeee
//    ,output [7:0] dbg
    );


wire tx_busy;

 reg received;
reg recv_error;

  uart uart(
    .clk(clk),
    .rst(reset),
    .rx(serial_in),
    .tx(serial_out),
    .transmit(writeenable),
    .tx_byte(writedata[7:0]),
//    .received(received),
//    .rx_byte(readdata[7:0]),
    .is_receiving(readenable),
    .is_transmitting(tx_busy)
//    .recv_error(recv_error)
    );

  always @(posedge clk)
//      if (readenable)
         case (rw)
//         0: readdata <= {15'd0, pending_avail, pending_avail, 7'd0, pending_data};
         1: readdata <= {15'd0, !tx_busy, 16'd0};
         endcase
  //    else
    //     readdata <= 32 'h 6666_6666;
/*assign dbg[0]=writeenable;
assign dbg[1]=serial_out;
assign dbg[2]=tx_busy;
assign dbg[3]=reset;
assign dbg[4]=address;
assign dbg[5]=writedata[0];
assign dbg[6]=writedata[1];
assign dbg[7]=1;
*/
endmodule
