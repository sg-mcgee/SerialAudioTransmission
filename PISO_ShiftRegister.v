//Parallel In Serial Out Shift register, 8 bits
`timescale 1ns/1ps

module PISO_ShiftRegister(
    input CLOCK_50,
    input [7:0] Parallel_Data,
    input Load_Parallel_Data,
    input Shift_Flag,
    input Reset,
    output wire Serial_Out
);

reg [7:0] Shift_Data;
reg [7:0] Load_Data;
assign Serial_Out = Shift_Data[0];

always @(posedge CLOCK_50) begin
    Load_Data <= Parallel_Data;
    casez ({Reset,Load_Parallel_Data,Shift_Flag})
        3'b1zz:
            Shift_Data <= 8'hff; //Reset to 11111111
        3'b01z:
            Shift_Data <= Load_Data; //Set contents of shift register to the Parallel In data
        3'b001:
            Shift_Data <= {1'b1,Shift_Data[7:1]}; //Shift
        default:
            Shift_Data <= Shift_Data;
    endcase
end

endmodule