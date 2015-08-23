`define memmap [29:22]
`define ROM 'h00
`define RAM 'h10
`define UART 'h80
`define GPIO 'h81
`define SPI 'h82

module riscvsoc

  (input         clk,
   output        serial_out,
   input         serial_in, 
   inout [7:0] gpio_port);

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

uart_controller uart_controller
     ( .clk             (clk)
      , .reset(reset)
     , .serial_out      (serial_out)
     , .serial_in       (serial_in)

     , .rw         (address[0])
     , .writeenable     (address`memmap == `UART & writeenable)
     , .writedata       (writedata)
     , .readenable      (address`memmap == `UART & readenable)
     , .readdata        (readdata)
//     , .dbg             (dbg)

     );

gpio_controller gpio_controller (
       .clk(clk),
       .ioport(gpio_port),
       .writeenable(address`memmap == `GPIO & writeenable),
       .readenable(address`memmap == `GPIO & readenable),
       .rw(address[0]),
       .writedata(writedata),
       .readdata(gpio_readdata)
       );

/*
   rs232 rs232
     ( .clk             (clk)
     , .serial_out      (serial_out)
     , .serial_in       (serial_in)

     , .address         (address[0])
     , .writeenable     (writeenable & address[29])
     , .writedata       (writedata)
     , .readenable      (readenable  & address[29])
     , .readdata        (readdata));
*/


//`define SIMULATION 1
`ifdef SIMULATION
   always @(posedge clk)
      if (writeenable /* && address[29] */)
	$display("IO write %8x/%d -> [%8x]", writedata, byteena, address * 4);

   always @(posedge clk)
      if (readenable /* && address[29] */)
	$display("IO read from [%8x]", writedata, byteena, address * 4);
`endif
endmodule
