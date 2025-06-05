`timescale 1ns/1ps

module tb_UART_TX(
    output reg CLOCK_50,
    output reg Start_Flag,
    output reg [7:0] Input_Data,
    output reg Load_Data,
    output reg Reset,
    input Serial_Data,
    input [1:0] State,
    input [1:0] Next_State,
    input sm_Transition_Flag
);
integer i;
initial begin
    Reset = 1'b0;
    Start_Flag = 1'b0;
    CLOCK_50 = 1'b1;
    Input_Data = 8'b01000001;
    Load_Data = 1'b0;
    i = 0;
end

always begin
    #10 CLOCK_50 = ~CLOCK_50;
    i = i + 1;
    if(i==3) begin
        Reset = 1'b1;
    end
    if(i==5) begin
        Reset = 1'b0;
    end
    if(i==7) begin
        Load_Data = 1'b1;
    end
    if(i==9) begin
        Load_Data = 1'b0;
    end
    if(i==15) begin
        Start_Flag = 1'b1;
    end
    if(i==17) begin
        Start_Flag = 1'b0;
    end
end

UART_TX UART_TX(
    .CLOCK_50(CLOCK_50),
    .Start_Flag(Start_Flag),
    .Input_Data(Input_Data),
    .Load_Data(Load_Data),
    .Reset(Reset),
    .Serial_Data(Serial_Data),
    .State(State),
    .Next_State(Next_State),
    .sm_Transition_Flag(sm_Transition_Flag)
    );
endmodule