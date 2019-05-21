`timescale 1ns / 1ps

module image(
			input wire btnReset,
			input wire btnUpdate,
			input wire [7:0] sw,
			output reg [63:0] imOut
    );

// register storing the line count - wraps around to 0 if incremented above 7
reg [2:0] line =0;

initial
begin
	imOut = 0;
end

always @ (posedge btnReset or posedge btnUpdate)
begin
	if (btnReset)
	begin
		line = 0;
		imOut = 0;
	end
	
	else 
	begin
		case(line)
			0: imOut[7:0] = sw;
			1: imOut[15:8] = sw;
			2: imOut[23:16] = sw;
			3: imOut[31:24] = sw;
			4: imOut[39:32] = sw;
			5: imOut[47:40] = sw;
			6: imOut[55:48] = sw;
			7: imOut[63:56] = sw;
		endcase
		
		line = line + 1;
	end
end

endmodule
