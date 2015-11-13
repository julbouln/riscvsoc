// -----------------------------------------------------------------------
//
//   Copyright 2014 Tommy Thorn - All Rights Reserved
//
//   This program is free software; you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
//   Bostom MA 02111-1307, USA; either version 2 of the License, or
//   (at your option) any later version; incorporated herein by reference.
//
// -----------------------------------------------------------------------

`timescale 1ns/10ps

module top_riscvsoc(input CLK50, 
					output TX,
					input RX,
					output [7:0] LEDS
);
wire clk100;
/*
wire              clk50dcm, clk100dcm, clk100;
DCM dcm100 (.CLKIN(CLK50), .RST(1'b0), .CLKFB(clk50dcm), .CLK0(clk50dcm), .CLK2X(clk100dcm));
defparam dcm100.CLKIN_PERIOD = 20.0;
BUFG buf100 (.I(clk100dcm), .O(clk100));
*/
clk_100 clk_100(.CLK_IN1(CLK50),.CLK_OUT1(clk100));
//clk_200 clk_200(.CLK_IN1(CLK50),.CLK_OUT1(clk100));

riscvsoc riscvsoc(.clk(clk100),.serial_out(TX),.serial_in(RX),.gpio_port(LEDS));


assign LEDS=8'h0;
endmodule
