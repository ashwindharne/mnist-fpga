`timescale 1ns / 1ps

module clk_divider_debounce(
			input wire clk,
			output wire displayClk,
			output wire segClk
    );
	 
// Assuming 100MHz master clk
// displayClk will be 25MHz
// segClk will be 250Hz (4 segments, 1 per cycle, means the whole seg display will be refreshed at 62.5Hz)

reg displayClkReg = 0;
reg segClkReg = 0;

reg displayCounter = 0;
reg [18:0] segCounter = 0;
reg [18:0] segCounterResetVal = 19'd400000; // 250Hz * 400000 = 100MHz


assign displayClk = displayClkReg;
assign segClk = segClkReg;


always @ (posedge clk)
begin
	if (displayCounter == 1)
		displayClkReg = ~displayClkReg;
		
	if (segCounter == segCounterResetVal)
	begin
		segClkReg = ~segClkReg;
		segCounter = 0;
	end
		
	displayCounter = displayCounter + 1;
	segCounter = segCounter + 1;
	
end

endmodule
