module ram_wb (
                input clk_i,
                input [addr_width-1:0] addr_i,
                input [data_width-1:0] data_i,
                output reg [data_width-1:0] data_o,
                input we_i, 
                input cyc_i,
                input stb_i,
                output ack_o,
                output stall_o,
                input [3:0] sel_i
                );

   parameter data_width = 8;
   parameter addr_width = 16;
   parameter mem_size  = 4096;
   parameter rom_file = 0;
   
   reg [data_width-1:0] ram [mem_size - 1:0] /* synthesis ram_style = no_rw_check */;
   
    integer i;
   initial begin
    for(i=0;i<mem_size;i=i+1) begin
      ram[i]=32'h0;
    end
   end

initial begin
  if(rom_file)
    $readmemh(rom_file, ram) ;
end

   always @ (posedge clk_i)
     begin
     if(stb_i) begin
        data_o<=ram[addr_i];
        if(sel_i[0])
          data_o[7:0] <= ram[addr_i][7:0];
        if(sel_i[1])
          data_o[15:8] <= ram[addr_i][15:8];
        if(sel_i[2])
          data_o[23:16] <= ram[addr_i][23:16];
        if(sel_i[3])
          data_o[31:24] <= ram[addr_i][31:24];
        
        if(we_i) begin
          if(sel_i[0])
            ram[addr_i][7:0] <= data_i[7:0];
          if(sel_i[1])
            ram[addr_i][15:8] <= data_i[15:8];
          if(sel_i[2])
            ram[addr_i][23:16] <= data_i[23:16];
          if(sel_i[3])
            ram[addr_i][31:24] <= data_i[31:24];
        end
     end 
  end

  assign stall_o = 1'b0;
  assign ack_o = cyc_i & stb_i;

endmodule 

module dual_ram_wb (
                input clk_i,
                input [addr_width-1:0] addr_i,
                input [data_width-1:0] data_i,
                output reg [data_width-1:0] data_o,
                input we_i, 
                input cyc_i,
                input stb_i,
                output ack_o,
                output stall_o,
                input [3:0] sel_i,

                input [addr_width-1:0] addr2_i,
                output reg [data_width-1:0] data2_o = 0,
                input cyc2_i,
                input stb2_i,
                output ack2_o,
                output stall2_o,
                input [3:0] sel2_i

                );

   parameter data_width = 8;
   parameter addr_width = 16;
   parameter mem_size  = 4096;
   parameter rom_file = 0;
   
   reg [data_width-1:0] ram [mem_size - 1:0] /* synthesis ram_style = no_rw_check */;
   
    integer i;
   initial begin
    for(i=0;i<mem_size;i=i+1) begin
      ram[i]=32'h0;
    end
   end

initial begin
  if(rom_file)
    $readmemh(rom_file, ram) ;
end

   always @ (posedge clk_i)
     begin
      if(stb2_i)
        data2_o <= ram[addr2_i];
     end

   always @ (posedge clk_i)
     begin
     if(stb_i) begin
        data_o<=ram[addr_i];
        if(sel_i[0])
        	data_o[7:0] <= ram[addr_i][7:0];
        if(sel_i[1])
          data_o[15:8] <= ram[addr_i][15:8];
        if(sel_i[2])
          data_o[23:16] <= ram[addr_i][23:16];
        if(sel_i[3])
          data_o[31:24] <= ram[addr_i][31:24];

        if (we_i) begin
          if(sel_i[0])
            ram[addr_i][7:0] <= data_i[7:0];
          if(sel_i[1])
            ram[addr_i][15:8] <= data_i[15:8];
          if(sel_i[2])
            ram[addr_i][23:16] <= data_i[23:16];
          if(sel_i[3])
            ram[addr_i][31:24] <= data_i[31:24];
          end
      end
    end 

  assign stall_o = 1'b0;
  assign ack_o = cyc_i & stb_i;

  assign stall2_o = 1'b0;
  assign ack2_o = cyc2_i & stb2_i;

endmodule 