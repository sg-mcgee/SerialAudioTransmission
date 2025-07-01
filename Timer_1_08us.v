`timescale 1ns/1ps

module Timer_1_08us(
    input CLOCK_50,
    input Reset,
    output reg Rollover
);

reg [10:0] Count;

always @(posedge CLOCK_50) begin
		Rollover <= 1'b0;
		if (Reset) begin
			Count <= 11'b0;
			Rollover <= 1'b0;
		end else if (Count >=54) begin
			Rollover <= 1'b1;
			Count <= 11'b0;
		end else
			Count <= Count + 11'b1;
end
endmodule