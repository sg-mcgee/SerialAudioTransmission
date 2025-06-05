`timescale 1ns/1ps

module Timer_2_17us(
    input CLOCK_50;
    input Reset;
    output Rollover;
)

reg [8:0] Count;

always @(posedge CLOCK_50) begin
		Rollover <= 1'b0;
		if (Reset) begin
			Count <= 9'b0;
			Rollover <= 1'b0;
		end else
			Count <= Count + 9'b1;
		
		if (Count >= 109) begin //Counter >= 50 million
			Rollover <= 1'b1;
			Count <= 9'b0;
		end
	end
endmodule