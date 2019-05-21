`timescale 1ns / 1ps

module segDisplay(
            input wire clk,
            input wire btn,
            input wire [3:0] digit,
            input wire [15:0] confidence,
            output wire [6:0] seg,
            output wire [3:0] an
    );

    reg displayToggle = 0;
    reg [3:0] digitSel = 1; // 1 refers to a digit being on, and 0 refers to a digit being off (this gets switched before being sent to the 'an' signal
    reg [3:0] digitVal;
    reg [6:0] segReg;
    
    assign seg = segReg;
    assign an = ~digitSel;
    
    always @ (posedge btn)
    begin
        displayToggle = ~displayToggle;
    end
    
    always @ (posedge clk)
    begin
        if (displayToggle)
        begin
            digitSel = 1;
            
            digitVal = digit;
        end
        
        else
        begin
            digitSel = {digitSel[2:0], digitSel[3]};
            
            case(digitSel)
                4'b0001: digitVal = confidence[3:0];
                4'b0010: digitVal = confidence[7:4];
                4'b0100: digitVal = confidence[11:8];
                4'b1000: digitVal = confidence[15:12];
            endcase
        end
    end
    
    always @ (digitVal)
    begin
        case(digitVal)
		    0: segReg = 7'b1000000;
            1: segReg = 7'b1111001;
            2: segReg = 7'b0100100;
            3: segReg = 7'b0110000;
            4: segReg = 7'b0011001;
            5: segReg = 7'b0010010;
            6: segReg = 7'b0000010;
            7: segReg = 7'b1111000;
            8: segReg = 7'b0000000;
            9: segReg = 7'b0011000;
            default: segReg = 7'b0011000;
        endcase
    
    end
    


endmodule
