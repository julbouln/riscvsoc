module riscvsoc

  (input         clk,
   output        serial_out,
   input         serial_in);

   wire          tx_busy;

   wire   [ 7:0] rx_q;
   wire          rx_valid;

   wire   [29:0] address;
   wire   [31:0] writedata;
   wire          writeenable;
   wire   [31:0] readdata;
   wire          readenable;
   wire   [ 3:0] byteena;

   reg           reset = 1;

   always @(posedge clk)
      reset <= 1'd0;

   yarvi yarvi
     ( .clk             (clk)
     , .reset           (reset)
     , .address         (address)
     , .writeenable     (writeenable)
     , .writedata       (writedata)
     , .byteena         (byteena)
     , .readenable      (readenable)
     , .readdata        (readdata)
     );

   rs232 rs232
     ( .clk             (clk)
     , .serial_out      (serial_out)
     , .serial_in       (serial_in)

     , .address         (address[0])
     , .writeenable     (writeenable & address[29])
     , .writedata       (writedata)
     , .readenable      (readenable  & address[29])
     , .readdata        (readdata));

`ifdef SIMULATION
   always @(posedge clk)
      if (writeenable /* && address[29] */)
	$display("IO write %8x/%d -> [%8x]", writedata, byteena, address * 4);

   always @(posedge clk)
      if (readenable /* && address[29] */)
	$display("IO read from [%8x]", writedata, byteena, address * 4);
`endif
endmodule
