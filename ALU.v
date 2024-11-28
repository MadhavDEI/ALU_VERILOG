`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2024 06:59:50 PM
// Design Name: 
// Module Name: ALU
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


module ALU(out, cout, Zero, Overflow, ldA, ldB, din, clk, control);
    input ldA, ldB, clk;
    input [3:0] din;
    input [2:0] control;
    output reg [3:0] out;
    output reg cout, Zero, Overflow;
    wire [3:0] x, Y, sum_add, sum_sub, and_out, or_out, xor_out, nor_out, lls_out, lrs_out;
    wire sum_carry_add, sum_carry_sub;

    parameter ADD = 3'b000, SUB = 3'b001, AND = 3'b010, OR = 3'b011, 
              XOR = 3'b100, NOR = 3'b101, LLS = 3'b110, LRS = 3'b111;
              
    wire [3:0] bus;
    assign bus = din;
    PIPO A (x, ldA, bus, clk);
    PIPO B (Y, ldB, bus, clk);

    adder_4_bit ADDER (x, Y, sum_add, sum_carry_add, 0); 
    adder_4_bit SUBTRACTOR (x, ~Y, sum_sub, sum_carry_sub, 1); 
    AND_4_bit AND_GATE (x, Y, and_out);
    OR_4_bit OR_GATE (x, Y, or_out);
    XOR_4_bit XOR_GATE (x, Y, xor_out);
    NOR_4_bit NOR_GATE (x, Y, nor_out);
    SHIFT_LEFT_4_bit LLS_SHIFT (x, Y, lls_out);
    SHIFT_RIGHT_4_bit LRS_SHIFT (x, Y, lrs_out);

    always @(*) begin
        cout = 0;
        Overflow = 0;

        case(control)
            ADD : begin
                out = sum_add;
                cout = sum_carry_add;
                Overflow = (x[3] & Y[3] & ~out[3]) | (~x[3] & ~Y[3] & out[3]);
            end
            SUB : begin
                out = sum_sub; 
                cout = sum_carry_sub;
            end
            AND : out = and_out;
            OR  : out = or_out;
            XOR : out = xor_out;
            NOR : out = nor_out;
            LLS : out = lls_out;
            LRS : out = lrs_out;
            default : out = 4'b0000;
        endcase

        Zero = (out == 4'b0000) ? 1 : 0;
    end
endmodule

module PIPO(out, ld, din, clk);
    output reg [3:0] out;
    input ld;
    input [3:0] din;
    input clk;

    always @(posedge clk) begin
        if (ld)
            out <= din;
    end
endmodule

module adder_4_bit(x, y, z, carry, cin);
    input [3:0] x, y;
    output [3:0] z;
    input cin;
    output carry;
    wire c1, c2, c3;

    full_adder F0 (x[0], y[0], cin, z[0], c1);
    full_adder F1 (x[1], y[1], c1, z[1], c2);
    full_adder F2 (x[2], y[2], c2, z[2], c3);
    full_adder F3 (x[3], y[3], c3, z[3], carry);
endmodule

module full_adder (
    input x, 
    input y, 
    input cin, 
    output z, 
    output carry
);
    wire z1, c1, c2;

    xor G1(z1, x, y);
    and G2(c1, x, y);
    and G3(c2, z1, cin);
    xor G4(z, z1, cin);
    or G5(carry, c1, c2);  
endmodule

module AND_4_bit(x, Y, out);
    input [3:0] x, Y;
    output [3:0] out;

    and G0(out[0], x[0], Y[0]);
    and G1(out[1], x[1], Y[1]);
    and G2(out[2], x[2], Y[2]);
    and G3(out[3], x[3], Y[3]);
endmodule

module OR_4_bit(x, Y, out);
    input [3:0] x, Y;
    output [3:0] out;

    or G0(out[0], x[0], Y[0]);
    or G1(out[1], x[1], Y[1]);
    or G2(out[2], x[2], Y[2]);
    or G3(out[3], x[3], Y[3]);
endmodule

module XOR_4_bit(x, Y, out);
    input [3:0] x, Y;
    output [3:0] out;

    xor G0(out[0], x[0], Y[0]);
    xor G1(out[1], x[1], Y[1]);
    xor G2(out[2], x[2], Y[2]);
    xor G3(out[3], x[3], Y[3]);
endmodule

module NOR_4_bit(x, Y, out);
    input [3:0] x, Y;
    output [3:0] out;

    nor G0(out[0], x[0], Y[0]);
    nor G1(out[1], x[1], Y[1]);
    nor G2(out[2], x[2], Y[2]);
    nor G3(out[3], x[3], Y[3]);
endmodule

module SHIFT_LEFT_4_bit(x, Y, out);
    input [3:0] x, Y;
    output [3:0] out;

    assign out = x << Y[1:0]; 
endmodule

module SHIFT_RIGHT_4_bit(x, Y, out);
    input [3:0] x, Y;
    output [3:0] out;

    assign out = x >> Y[1:0]; 
endmodule
