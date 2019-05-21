`timescale 1ns / 1ps

module HiddenNode(
			input wire clk,
			input wire [575:0] weights,
			input wire signed [8:0] bias,
			input wire [63:0] in,
			output wire [15:0] out
    );
	 
	 reg signed [15:0] accum;
	 reg signed [9:0] temp;
	 reg [15:0] outVal;
	 reg [6:0] i;
	 
	assign out = outVal;
	/*
	reg [575:0] reverseWeights;
	integer j;
	integer k;
	always @ (weights)
	begin
		for (j = 0; j < 64; j = j + 1)
		begin
			for (k = 0; k < 9; k = k + 1)
			begin
				reverseWeights[j * 9 + k] = weights[j * 9 + 8 - k];
			end
		end
	end*/
	
	always @*
	begin
		accum = 0;
		for (i = 0; i < 64; i = i + 1) begin
		if(in[i] == 1)
			begin
			temp = $signed(weights[i*9 +: 9]);
			end
		else
			begin
			temp = 0;
			end
		accum = accum + temp;
		end
		outVal = accum + bias <0 ? 0 : accum + bias;
	end

endmodule
