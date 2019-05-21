`timescale 1ns / 1ps

module nexys3(
			input wire clk, 
			input wire btnu, 
			input wire btnr, 
			input wire btnc, 
			input wire [7:0] sw, 
			
			output wire [6:0] seg, 
			output wire [3:0] an, 
			output wire [2:0] red, 
			output wire [2:0] green, 
			output wire [1:0] blue, 
			output wire hsync, 
			output wire vsync
    );
	 
	 
// Debounced buttons
wire reset; // btnc
wire update; // btnr
wire displayMode; // btnu
	 
// intermodule clk wires
wire displayClk;
wire segClk;
wire debouncerClk;
wire debouncerClk_d;

// intermodule wire storing 8x8 image array as a 64 bit vector
// [0:7] is first row
// [56:63] is last row
wire [63:0] im;



image imHolder(
			.btnReset(reset),
			.btnUpdate(update),
			.sw(sw),
			.imOut(im)
			);

// TEMPORARY



	

clk_divider clkDivide(
			.clk(clk),
			.displayClk(displayClk),
			.segClk(segClk),
			.debouncerClk(debouncerClk),
			.debouncerClk_delayed(debouncerClk_d)	
			);	
			
debouncer deb(
			.clk(clk),
			.clk_en(debouncerClk),
			.clk_en_d(debouncerClk_d),
			.btnu_in(btnu),
			.btnc_in(btnc),
			.btnr_in(btnr),
			.btnu_out(displayMode),
			.btnc_out(reset),
			.btnr_out(update)
			);

//TEMP
reg [63:0] im_temp = 64'b1010101011001101;

vga640x480 vga(
			.dclk(displayClk),
			.clr(reset), // temporary - asynchronous screen reset probably isn't necessary for this project
			.im(im),
			.hsync(hsync),
			.vsync(vsync),
			.red(red),
			.green(green),
			.blue(blue)
			);
			
wire [3:0] digit;
wire [15:0] confidence;

// To run this on a board, comment the net module out
Net net(
			.clk(clk),
			.in(im),
			.digit(digit),
			.confidence(confidence)
			);
/*			
always @ (digit)
begin
	case(digit)
			0: seg_reg = 7'b1000000;
			1: seg_reg = 7'b1111001;
			2: seg_reg = 7'b0100100;
			3: seg_reg = 7'b0110000;
			4: seg_reg = 7'b0011001;
			5: seg_reg = 7'b0010010;
			6: seg_reg = 7'b0000010;
			7: seg_reg = 7'b1111000;
			8: seg_reg = 7'b0000000;
			9: seg_reg = 7'b0011000;				
	  endcase
end*/
assign digit = 2;
assign confidence = 16'b0000000100100011;
	
segDisplay sevenseg(
            .clk(segClk),
            .btn(displayMode),
            .digit(digit),
            .confidence(confidence),
            .seg(seg),
            .an(an)
				);


endmodule
