`timescale 1ns/1ps

module RisingEdgeDetector(
	input Signal,
	input CLOCK_50,
	output reg Edge
	);

	reg CurrentInput, OneClockDelay;

	always @(posedge CLOCK_50) begin
		CurrentInput <= Signal;
		OneClockDelay <= CurrentInput;
		Edge <= ((CurrentInput == 1'b1) && (OneClockDelay == 1'b0));
	end
endmodule