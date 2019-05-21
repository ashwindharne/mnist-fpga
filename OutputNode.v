`timescale 1ns / 1ps

module OutputNode(
			input wire clk,
			input wire [899:0] weights,
			input wire [8:0] bias,
			input wire [1599:0] in,
			output wire [21:0] out
    );
	 
	 reg signed [21:0] accum;
	 reg [21:0] outVal;
	 integer i;
	 
	 assign out = outVal;

	always @*
	begin
			accum = 0;
			for (i = 0; i < 100; i = i + 1) 
			begin
				accum = $signed(accum) + $signed(weights[(100 - i) * 9 - 1 -: 9]) * $signed(in[(i+1)*16-1 -: 16]);
			end
			outVal = $signed(accum) + $signed(bias);
	end

endmodule
