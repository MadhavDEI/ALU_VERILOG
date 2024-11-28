`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2024 09:42:11 PM
// Design Name: 
// Module Name: ALU_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU_test;
    reg ldA, ldB, clk;
    reg [3:0] din;
    reg [2:0] control;
    wire [3:0] out;
    wire cout, Zero, Overflow;
    ALU dut(out, cout, Zero, Overflow, ldA, ldB, din, clk, control);
    initial clk = 0;
    always #5 clk = ~clk;
    initial begin
        // Initialize inputs
        ldA = 0; ldB = 0; din = 0; control = 0;
        #10; din = 4'b0000; ldA = 1; ldB = 1;
        #10; ldA = 0; ldB = 0;
 
        #10; din = 4'b0101; ldA = 1;   
        #10; din = 4'b0011; ldB = 1;ldA = 0; 
        #10; control = 3'b000;
        #20;
        #10; control = 3'b001; 
        #20;
        #10; control = 3'b010; 
        #20;
        #10; control = 3'b011;
        #20;
        #10; control = 3'b100; 
        #20;
        #10; control = 3'b101; 
        #20;
        #10; control = 3'b110; 
        #20;
        #10; control = 3'b111; 
        #20;
        #10 din = 4'b1111; ldA = 1; ldB = 0; 
        #10 ldA = 0;
        #10 din = 4'b1111; ldB = 1; 
        #10 ldB = 0;
        #10 control = 3'b000;
        #20
        $finish;
    end
    initial begin
        $monitor("Time = %0t | ldA = %b | ldB = %b | din = %b | control = %b | out = %b | cout = %b | Zero = %b | Overflow = %b",
                 $time, ldA, ldB, din, control, out, cout, Zero, Overflow);
        end

endmodule
