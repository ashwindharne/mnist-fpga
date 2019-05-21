`timescale 1ns / 1ps

module clk_divider(
			input wire clk,
			output wire displayClk,
			output wire segClk,
			output wire debouncerClk,
			output wire debouncerClk_delayed
    );
	 
// Assuming 100MHz master clk
// displayClk will be 25MHz
// segClk will be 250Hz (4 segments, 1 per cycle, means the whole seg display will be refreshed at 62.5Hz)
// debouncerClk will be ~391 kHz (100MHz / 2^8 for simplicity) (unlike the above clocks, this will only be on for 1 master clk cycle
// debouncerClk_delayed will also be ~391 kHz, active for the master clk cycle right after debouncerClk is active

reg [1:0] displayCounter = 0;

reg [8:0] debouncerCounter = 0;
reg debouncerClkReg = 0;
reg debouncerClkDelReg = 0;

reg segClkReg = 0;
reg [18:0] segCounter = 0;
reg [18:0] segCounterResetVal = 19'd400000; // 250Hz * 400000 = 100MHz


assign displayClk = displayCounter[1];
assign segClk = segClkReg;
assign debouncerClk = debouncerClkReg;
assign debouncerClk_delayed = debouncerClkDelReg;


always @ (posedge clk)
begin	
	if (segCounter == segCounterResetVal)
	begin
		segClkReg = ~segClkReg;
		segCounter = 0;
	end
	
	if (debouncerCounter == 0)
		debouncerClkReg = 1;
	else
		debouncerClkReg = 0;
		
	if (debouncerCounter == 1)
		debouncerClkDelReg = 1;
	else
		debouncerClkDelReg = 0;
		
		
	displayCounter = displayCounter + 1;
	segCounter = segCounter + 1;
	debouncerCounter = debouncerCounter + 1;
	
end

endmodule
