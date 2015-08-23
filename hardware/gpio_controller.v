module gpio_controller(
	    input 	  clk,
	    inout [7:0] ioport,
	    input 	  writeenable,
	    input 	  readenable,
	    input rw,
	    input [31:0]  writedata,
	    output reg [31:0] readdata = 0
	    );

   reg [7:0] 		  ioctrl = 0;
   reg [7:0] 		  outp = 0;
      
   genvar 		  gi;

   for(gi = 0; gi < 8; gi=gi+1)
     begin
      	assign ioport[gi] = ioctrl[gi] ? outp[gi] : ioport[gi];	
     end
	 
   integer i;
   
   always @(*)
     begin
     if(rw)
       readdata[7:0] = ioctrl;
     else
       for(i = 0; i < 8; i=i+1)
      	 readdata[i] = ioctrl[i] ? outp[i] : ioport[i];
     end
   
   always @ (posedge clk)
     if(writeenable) begin
    	if(rw)
	      ioctrl <= writedata[7:0];
    	else
	       for(i = 0; i < 8; i=i+1)
	         if(ioctrl[i])
	           outp[i] <= writedata[i];
      end

endmodule