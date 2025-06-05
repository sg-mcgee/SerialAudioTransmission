`timescale 1ns/1ps

module tb_PISO_ShiftRegister(
    output reg CLOCK_50, Load_Parallel_Data, Shift_Flag, Reset,
    output reg [7:0] Parallel_Data,
    input Serial_Out
);

integer i;
initial begin
    CLOCK_50 = 1'b1;
    Parallel_Data = 8'b01000001;
    Load_Parallel_Data = 1'b0;
    Shift_Flag = 1'b0;
    Reset = 1'b0;
    i = 0;
end

always begin
    #10 CLOCK_50 = ~CLOCK_50;
    i = i + 1;
    if(i==3) begin
        Reset = 1'b1;
    end
    if(i==7) begin
        Reset = 1'b0;
    end
    if(i==9) begin
        Shift_Flag = 1'b1;
    end
    if(i==11) begin
        Shift_Flag = 1'b0;
    end
    if(i==15) begin
        Reset = 1'b1;
    end
    if(i==19) begin
        Reset = 1'b0;
    end
    if(i==21) begin
        Load_Parallel_Data = 1'b1;
    end
    if(i==23) begin
        Load_Parallel_Data = 1'b0;
    end
    if(i==25) begin
        Shift_Flag = 1'b1;
    end
    if(i==27) begin
        Shift_Flag = 1'b0;
    end
    if(i==29) begin
        Shift_Flag = 1'b1;
    end
    if(i==31) begin
        Shift_Flag = 1'b0;
    end
    if(i==33) begin
        Shift_Flag = 1'b1;
    end
    if(i==35) begin
        Shift_Flag = 1'b0;
    end
    if(i==37) begin
        Shift_Flag = 1'b1;
    end
    if(i==39) begin
        Shift_Flag = 1'b0;
    end
    if(i==41) begin
        Shift_Flag = 1'b1;
    end
    if(i==43) begin
        Shift_Flag = 1'b0;
    end
    if(i==45) begin
        Shift_Flag = 1'b1;
    end
    if(i==47) begin
        Shift_Flag = 1'b0;
    end
    if(i==49) begin
        Shift_Flag = 1'b1;
    end
    if(i==51) begin
        Shift_Flag = 1'b0;
    end
end

PISO_ShiftRegister PISO_ShiftRegister(
    .CLOCK_50(CLOCK_50),
    .Parallel_Data(Parallel_Data),
    .Load_Parallel_Data(Load_Parallel_Data),
    .Shift_Flag(Shift_Flag),
    .Reset(Reset),
    .Serial_Out(Serial_Out)
);

endmodule
