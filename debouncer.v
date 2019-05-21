`timescale 1ns / 1ps

module debouncer(
			input wire clk,
			input wire clk_en,
			input wire clk_en_d,
			input wire btnu_in,
			input wire btnc_in,
			input wire btnr_in,
			
			output reg btnu_out,
			output reg btnc_out,
			output reg btnr_out
    );
	 
	reg [1:0] btnuRecord = 0;
	reg [1:0] btncRecord = 0;
	reg [1:0] btnrRecord = 0;
	
	always @ (posedge clk_en)
   begin
      btncRecord[1:0] <= {btnc_in, btncRecord[1:1]};
		btnrRecord[1:0] <= {btnr_in, btnrRecord[1:1]};
		btnuRecord[1:0] <= {btnu_in, btnuRecord[1:1]};
   end
	   
	// Detecting posedge of buttons
   wire is_btnr_posedge, is_btnc_posedge, is_btnu_posedge;
	assign is_btnu_posedge = ~ btnuRecord[0] & btnuRecord[1];
   assign is_btnr_posedge = ~ btnrRecord[0] & btnrRecord[1];
	assign is_btnc_posedge = ~ btncRecord[0] & btncRecord[1];
	
   always @ (posedge clk)
     if (clk_en_d)
	  begin
	    btnr_out <= is_btnr_posedge;
		 btnc_out <= is_btnc_posedge;
		 btnu_out <= is_btnu_posedge;
	  end
	  else
	  begin
		 btnr_out <= 0;
		 btnc_out <= 0;
		 btnu_out <= 0;
	  end
	 


endmodule
