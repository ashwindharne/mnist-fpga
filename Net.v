`timescale 1ns / 1ps

module Net(
		input wire clk,
		input wire [63:0] in,
		output wire [3:0] digit,
		output wire [15:0] confidence
    );
	 
	 reg [575:0] weightsToHidden [99:0];
	 reg [8:0] biasToHidden [99:0];
	 wire [1599:0] outputFromHidden;
	 reg [15:0] confidence_reg;
	 
	 reg [899:0] weightsToOutput [9:0];
	 reg [8:0] biasToOutput [9:0];
	 
	 wire [21:0] outputs [9:0];

	 initial
	 begin
		$readmemb("C:/Users/152/Downloads/input2hidden_b", weightsToHidden);
		$readmemb("C:/Users/152/Downloads/input2hidden_bias_b", biasToHidden);
		$readmemb("C:/Users/152/Downloads/hidden2output_b", weightsToOutput);
		$readmemb("C:/Users/152/Downloads/hidden2output_bias_b", biasToOutput);
	 end
	 
	 generate
		genvar i;
		for(i=0; i<100; i = i+1) begin : HiddenNode
			HiddenNode i_custom(
				.clk(clk),
				.weights(weightsToHidden[i]),
				.bias(biasToHidden[i]),
				.in(in),
				.out(outputFromHidden[(i+1)*16-1 -: 16]));
		end
	 endgenerate
	 
	 generate
		genvar j;
		for(j=0; j<10; j = j+1) begin : OutputNode
			OutputNode i_custom(
				.clk(clk),
				.weights(weightsToOutput[j]),
				.bias(biasToOutput[j]),
				.in(outputFromHidden),
				.out(outputs[j]));
		end
	 endgenerate
	 
	 
	assign confidence = confidence_reg;
	assign digit=max;
	
		reg [3:0] max;
		reg [4:0] k;
			
		always @ (outputs)
		begin
			max = 0;
			
			for (k = 0; k < 10; k = k + 1)
			begin
				max = $signed(outputs[max]) > $signed(outputs[k]) ? max : k;
			end
			confidence_reg = outputs[max][21:5];
		end
endmodule
