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

   reg           reset = 1;

   wire [29:0] imem_addr_o;
   wire [31:0] imem_data_o;
   wire [31:0] imem_data_i;
   wire imem_we_o;
   wire imem_stb_o;
   wire imem_cyc_o;
   wire imem_ack_i;
   wire [3:0] imem_sel_o;

   wire [29:0] dmem_addr_o;
   wire [31:0] dmem_data_o;
   wire [31:0] dmem_data_i;
   wire dmem_we_o;
   wire dmem_stb_o;
   wire dmem_cyc_o;
   wire dmem_ack_i;
   wire [3:0] dmem_sel_o;

   wire [31:0] ram_data_i;
   wire ram_we_o;
   wire ram_stb_o;
   wire ram_cyc_o;
   wire ram_ack_i;

   wire [31:0] uart_data_i;
   wire uart_we_o;
   wire uart_stb_o;
   wire uart_cyc_o;
   wire uart_ack_i;

`define ROM_WIDTH 12
`define RAM_WIDTH 12

   wire [29:0] rom_addr_o = dmem_addr_o`memmap == `ROM ? dmem_addr_o : 30'hZ;
   wire rom_stb_i = dmem_addr_o`memmap == `ROM ? 1'b1 : 1'b0;
   wire rom_cyc_i = rom_stb_i;
   wire [31:0] rom_data_i;


defparam rom.rom_file = "out.txt";
defparam rom.addr_width = `ROM_WIDTH;
defparam rom.data_width = 32;
defparam rom.mem_size = 2**`ROM_WIDTH;

dual_ram_wb rom(
    .clk_i(clk),
    .addr_i(imem_addr_o),
    .data_i(imem_data_o),
    .data_o(imem_data_i),
    .we_i(1'b0),
    .cyc_i(imem_cyc_o),
    .stb_i(imem_stb_o),
    .ack_o(imem_ack_i),
    .sel_i(imem_sel_o),

    .addr2_i(rom_addr_o),
    .data2_o(rom_data_i),
    .stb2_i(rom_stb_i),
    .cyc2_i(rom_cyc_i)


);

defparam ram.addr_width = `RAM_WIDTH;
defparam ram.data_width = 32;
defparam ram.mem_size = 2**`RAM_WIDTH;

ram_wb ram(
    .clk_i(clk),
    .addr_i(dmem_addr_o),
    .data_i(dmem_data_o),
    .data_o(ram_data_i),
    .we_i(ram_we_o),
    .cyc_i(ram_cyc_o),
    .stb_i(ram_stb_o),
    .ack_o(ram_ack_i),
    .sel_i(dmem_sel_o)
);

uart_wb uart(
    .clk(clk),
    .rst(rst),
    .serial_in(serial_in),
    .serial_out(serial_out),
    .addr_i(dmem_addr_o),
    .data_i(dmem_data_o),
    .data_o(uart_data_i),
    .we_i(uart_we_o),
    .cyc_i(uart_cyc_o),
    .stb_i(uart_stb_o),
    .ack_o(uart_ack_i)
);

assign dmem_data_i = dmem_addr_o`memmap == `ROM ? rom_data_i : 
                    dmem_addr_o`memmap == `RAM ? ram_data_i :
                    dmem_addr_o`memmap == `UART ? uart_data_i : 32'hZZ;


assign ram_we_o = dmem_addr_o`memmap == `RAM ? dmem_we_o : 1'b0;
assign uart_we_o = dmem_addr_o`memmap == `UART ? dmem_we_o : 1'b0;

assign ram_cyc_o = dmem_addr_o`memmap == `RAM ? dmem_cyc_o : 1'b0;
assign uart_cyc_o = dmem_addr_o`memmap == `UART ? dmem_cyc_o : 1'b0;

assign ram_stb_o = dmem_addr_o`memmap == `RAM ? dmem_stb_o : 1'b0;
assign uart_stb_o = dmem_addr_o`memmap == `UART ? dmem_stb_o : 1'b0;


   always @(posedge clk)
      reset <= 1'd0;

   yarvi yarvi
     ( .clk             (clk)
     , .reset           (reset)
     , .imem_addr_o(imem_addr_o)
     , .imem_data_o(imem_data_o)
     , .imem_data_i(imem_data_i)
     , .imem_we_o(imem_we_o)
     , .imem_stb_o(imem_stb_o)
     , .imem_cyc_o(imem_cyc_o)
     , .imem_ack_i(imem_ack_i)
     , .imem_sel_o(imem_sel_o)

     , .dmem_addr_o(dmem_addr_o)
     , .dmem_data_o(dmem_data_o)
     , .dmem_data_i(dmem_data_i)
     , .dmem_we_o(dmem_we_o)
     , .dmem_stb_o(dmem_stb_o)
     , .dmem_cyc_o(dmem_cyc_o)
     , .dmem_ack_i(dmem_ack_i)
     , .dmem_sel_o(dmem_sel_o)
     );

/*

gpio_controller gpio_controller (
       .clk(clk),
       .ioport(gpio_port),
       .writeenable(address`memmap == `GPIO & writeenable),
       .readenable(address`memmap == `GPIO & readenable),
       .rw(address[0]),
       .writedata(writedata),
       .readdata(gpio_readdata)
       );
*/
//`define SIMULATION 1
`ifdef SIMULATION
   always @(posedge clk) begin
      if (uart_we_o /* && address[29] */)
      	$display("IO write %8x -> [%8x]", dmem_data_o, dmem_addr_o);

      if (uart_stb_o /* && address[29] */)
      	$display("IO read %8x from [%8x]", dmem_data_i, dmem_addr_o);
  end
`endif
endmodule
