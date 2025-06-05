//Serial In Parallel Out Shift register, 8 bits
`timescale 1ns/1ps

module SIPO_ShiftRegister(
    input CLOCK_50,
    input Serial_Data,
    input Shift_Flag,
    input Reset,
    output reg [7:0] Parallel_Out
);

always @(posedge CLOCK_50) begin
    casez ({Reset,Shift_Flag})
        2'b1z:
            Parallel_Out <= 8'hff; //Reset to FF
        2'b01:
            Parallel_Out <= {Serial_Data, Parallel_Out[7:1]}; //Shift
        default:
            Parallel_Out <= Parallel_Out; //Do nothing, hold value
    endcase
end

endmodule