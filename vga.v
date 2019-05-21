`timescale 1ns / 1ps

module vga640x480(
	input wire dclk,			//pixel clock: 25MHz
	input wire clr,			//asynchronous reset
   input wire [63:0] im,		//current image array (stored as 64 bit vector)
	
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	output reg [2:0] red,	//red vga output
	output reg [2:0] green, //green vga output
	output reg [1:0] blue	//blue vga output
	);

// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480


// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;


// Horizontal & vertical counters --
// this is how we keep track of where we are on the screen.
always @(posedge dclk or posedge clr)
begin
	// reset condition
	if (clr == 1)
	begin
		hc <= 0;
		vc <= 0;
	end
	else
	begin
		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end
		
	end
end

// generate sync pulses (active low)
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;



// wire for holding the section of the screen that we're in
// 0,0 is top left corner
// range: (0,0) to (7,7)
wire [5:0] index;
wire [2:0] xCoord_s;
wire [2:0] yCoord_s;
assign xCoord_s = (hc - hbp) / 80;
assign yCoord_s = (vc - vbp) / 60;
assign index = (xCoord_s + 8 * yCoord_s);

// display black/white pixel vals
always @(*)
begin
	// first check if we're within vertical active video range, horizontal range
	if (vc >= vbp && vc < vfp && hc >= hbp && hc < hfp)
	begin
			red = im[index] ? 3'b111 : 3'b000;
			green = im[index] ? 3'b111 : 3'b000;
			blue = im[index] ? 2'b11 : 2'b00;
	end
		// we're outside active  range so display black
		else
		begin
			red = 0;
			green = 0;
			blue = 0;
		end
end

endmodule