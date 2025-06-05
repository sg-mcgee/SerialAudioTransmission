module UART_TX(
    input CLOCK_50,
    input Start_Flag,
    input Baud,
    input [7:0] Input_Data,
    output Serial_Data
)

reg [1:0] State;
reg [1:0] Next_State;
parameter sm_Stop_Bit = 2'b00;
parameter sm_Start_bit = 2'b01;
parameter sm_No_Shift = 2'b10;
parameter sm_Yes_Shift = 2'b11;

//State transition logic
always @(posedge CLOCK_50) begin
    State <= Next_State; //Always transition to Next State
end

//Next State logic
always @(posedge CLOCK_50) begin
    case(State)
        sm_Stop_Bit: Next_State <= (Start_Flag) ? sm_Start_bit : sm_Stop_Bit; //If start flag, start bit, else stay
        sm_Start_bit: Next
end