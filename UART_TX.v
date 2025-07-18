//UART TX with baud rate of 460800
`timescale 1ns/1ps

module UART_TX(
    input CLOCK_50,
    input Start_Flag,
    input [7:0] Input_Data,
    // input Load_Data,
    input Reset,
    output reg Serial_Data
);

//State information
reg [1:0] State;
reg [1:0] Next_State;
parameter sm_Stop_Bit = 2'b00;
parameter sm_Start_Bit = 2'b01;
parameter sm_No_Shift = 2'b10;
parameter sm_Yes_Shift = 2'b11;
//Shift counter
reg [3:0] Shift_Count;
//UART Timer
reg UART_Timer_Reset;
wire sm_Transition_Flag;
Timer_2_17us UART_Timer( //This is new organization for me
    .CLOCK_50(CLOCK_50),
    .Reset(UART_Timer_Reset),
    .Rollover(sm_Transition_Flag)
);
//PISO Shift Register
wire Load_Parallel_Data;
reg Shift_Content_Flag;
wire [7:0] Shift_Register_Out;
reg Load_Data;
PISO_ShiftRegister TX_Shift_Register(
    .CLOCK_50(CLOCK_50),
    .Parallel_Data(Input_Data),
    .Load_Parallel_Data(Load_Data),
    .Shift_Flag(Shift_Content_Flag),
    .Reset(Reset),
    .Serial_Out(Shift_Register_Out)
);

// State transition logic
always @(posedge CLOCK_50) begin
    State <= (Reset) ? sm_Stop_Bit : Next_State; //If reset, Stop Bit, else next state
end
//Next State logic
always @(*) begin
    case(State)
        sm_Stop_Bit: Next_State = (Start_Flag) ? sm_Start_Bit : sm_Stop_Bit; //If start flag, start bit, else stay
        sm_Start_Bit: Next_State = (sm_Transition_Flag) ? sm_No_Shift : sm_Start_Bit; //If Transition Flag, No_Shift, else stay
        sm_No_Shift: Next_State = (sm_Transition_Flag) ? sm_Yes_Shift : sm_No_Shift; //If Transition Flag, Yes_Shift, else stay
        sm_Yes_Shift: Next_State = (Shift_Count <= 4'b1000) ? sm_No_Shift : sm_Stop_Bit; //If shifted <8 times, no shift, else stop bit
        default: Next_State = sm_Stop_Bit;
    endcase
end
//Shift Count logic
always @(posedge CLOCK_50) begin
    case(State)
        sm_Yes_Shift: Shift_Count <= Shift_Count + 1; //Increment when in shift state
        sm_Stop_Bit: Shift_Count <= 4'b0000; //If in stop bit, shift count is zero
        default: Shift_Count <= Shift_Count; //Else keep value
    endcase
end
//Output logic
always @(*) begin
    case(State)
        sm_Stop_Bit: begin
            Serial_Data = 1'b1;
            UART_Timer_Reset = 1'b1;
            Shift_Content_Flag = 1'b0;
            Load_Data = 1'b0;
        end
        sm_Start_Bit: begin
            Serial_Data = 1'b0;
            UART_Timer_Reset = 1'b0;
            Shift_Content_Flag = 1'b0;
            Load_Data = 1'b1;
        end
        sm_Yes_Shift: begin
            Serial_Data = Shift_Register_Out[0];
            UART_Timer_Reset = 1'b0;
            Shift_Content_Flag = 1'b1;
            Load_Data = 1'b0;
        end
        sm_No_Shift: begin
            Serial_Data = Shift_Register_Out[0];
            UART_Timer_Reset = 1'b0;
            Shift_Content_Flag = 1'b0;
            Load_Data = 1'b0;
        end
        default: begin //In the event case gets out of wack (shouldn't), pull data high, keep timer on incase that fixes it, don't shift
            Serial_Data = 1'b1;
            UART_Timer_Reset = 1'b0;
            Shift_Content_Flag = 1'b0;
            Load_Data = 1'b0;
        end
    endcase
end

endmodule
