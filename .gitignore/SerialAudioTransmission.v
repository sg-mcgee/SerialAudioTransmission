`timescale 1ns/1ps

module SerialAudioTransmission(
    input CLOCK_50,
    inout [19:0] GPIO,
    input [1:0] KEY
);

parameter Test_Data = 8'b10000010;

reg CurrentInput, CurrentInput2, OneClockDelay, OneClockDelay2, Edge, Edge2;
assign Signal = KEY[0];
assign Signal2 = KEY[1];

always @(posedge CLOCK_50) begin
    CurrentInput <= Signal;
    OneClockDelay <= CurrentInput;
    CurrentInput2 <= Signal2;
    OneClockDelay2 <= CurrentInput2;
    Edge <= (CurrentInput & ~OneClockDelay) ? 1'b1 : 1'b0;
    Edge2 <= (CurrentInput2 & ~OneClockDelay2) ? 1'b1 : 1'b0;
end

UART_TX UART_TX(
    .CLOCK_50(CLOCK_50),
    .Start_Flag(Edge),
    .Input_Data(Test_Data),
    .Load_Data(Edge2),
    .Reset(1'b0),
    .Serial_Data(GPIO[0])
);



endmodule