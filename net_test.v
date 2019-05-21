`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:14:12 12/06/2018
// Design Name:   Net
// Module Name:   C:/Users/152/Desktop/Final_Project/net_test.v
// Project Name:  Final_Project
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Net
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module net_test;

	// Inputs
	reg clk;
	reg [63:0] in;
	//ret [575:0] weightsToHidden [99:0];

	// Outputs
	wire [3:0] digit;
	wire [15:0] confidence;

	// Instantiate the Unit Under Test (UUT)
	Net uut (
		.clk(clk), 
		.in(in), 
		.digit(digit), 
		.confidence(confidence)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		in = 64'b0000000000011000001001000010010000100100001001000001100000000000;
		//$readmemb("C:/Users/152/Downloads/input2hidden_b", weightsToHidden);
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

