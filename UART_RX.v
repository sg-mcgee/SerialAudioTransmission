`timescale 1ns/1ps

module UART_RX(
    input CLOCK_50,
    input Serial_In,
    input Reset,
    output [7:0] Parallel_Out,
    output reg Finished_Flag
);

//Logic:
//Detect FALLING EDGE on SERIAL_IN with falling edge detector
//wait 1.08us, then SIPO shift 9 times every 2.17us. 9 times to account for the start bit
wire FallingEdge;
FallingEdgeDetector FallingEdgeDetector(
    .CLOCK_50(CLOCK_50),
    .Signal(Serial_In),
    .Edge(FallingEdge)
);

//State machine information
reg [1:0] State;
reg [1:0] Next_State;
parameter sm_Wait = 2'b00;
parameter sm_No_Sample_1 = 2'b01;
parameter sm_No_Sample_2 = 2'b10;
parameter sm_Sample = 2'b11;
//Shift counter
reg [3:0] Sample_Count;
//UART Timer
reg UART_Timer_Reset;
wire sm_Transition_Flag;
Timer_1_08us UART_Timer(
    .CLOCK_50(CLOCK_50),
    .Rollover(sm_Transition_Flag),
    .Reset(UART_Timer_Reset)
);

//SIPO Shift Register
reg Shift_Content_Flag;
SIPO_ShiftRegister UART_RX_Reg(
    .CLOCK_50(CLOCK_50),
    .Serial_Data(Serial_In),
    .Shift_Flag(Shift_Content_Flag),
    .Reset(Reset),
    .Parallel_Out(Parallel_Out)
);

// State transition logic
always @(posedge CLOCK_50) begin
    State <= (Reset) ? sm_Wait : Next_State; //If reset, Stop Bit, else next state
end
//Next State logic
always @(*) begin
    case(State)
        sm_Wait: Next_State = (FallingEdge) ? sm_No_Sample_2 : sm_Wait; //If falling edge: start bit, else stay
        sm_No_Sample_1: Next_State = (sm_Transition_Flag) ? sm_No_Sample_2 : sm_No_Sample_1; //If Transition Flag: No_Sample_1, else stay
        sm_No_Sample_2: Next_State = (sm_Transition_Flag) ? sm_Sample : sm_No_Sample_2; //If Transition Flag: No_Sample_2, else stay
        sm_Sample: Next_State = (Sample_Count <= 4'b0111) ? sm_No_Sample_1 : sm_Wait; //If sampled <9 times: back to wait loop, else wait
        default: Next_State = sm_Wait;
    endcase
end
//Shift Count logic
always @(posedge CLOCK_50) begin
    case(State)
        sm_Sample: Sample_Count <= Sample_Count + 1; //Increment when in shift state
        sm_Wait: Sample_Count <= 4'b0000; //If in stop bit, shift count is zero
        default: Sample_Count <= Sample_Count; //Else keep value
    endcase
end
//Output logic
always @(*) begin
    case(State)
        sm_Wait: begin
            Finished_Flag = 1'b1;
            UART_Timer_Reset = 1'b1;
            Shift_Content_Flag = 1'b0;
        end
        sm_No_Sample_1: begin
            Finished_Flag = 1'b0;
            UART_Timer_Reset = 1'b0;
            Shift_Content_Flag = 1'b0;
        end
        sm_No_Sample_2: begin
            Finished_Flag = 1'b0;
            UART_Timer_Reset = 1'b0;
            Shift_Content_Flag = 1'b0;
        end
        sm_Sample: begin
            Finished_Flag = 1'b0;
            UART_Timer_Reset = 1'b0;
            Shift_Content_Flag = 1'b1;
        end
        default: begin //In the event case gets out of wack (shouldn't), keep timer on incase that fixes it, don't shift
            Finished_Flag = 1'b0;
            UART_Timer_Reset = 1'b0;
            Shift_Content_Flag = 1'b0;
        end
    endcase
end

endmodule
