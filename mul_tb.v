`timescale 1ns / 1ps
module mul_tb;

    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] out;
    reg sysclk;

    parameter CYCLE = 100;

    always #(CYCLE/2) sysclk = ~sysclk;
    multiplier multiplier(.a(a), .b(b), .c(out));
    
initial begin
sysclk = 0; a = 0; b=0;
#10 a = 32'b1_00000000_00000000000000000000001; b = 32'b1_00000000_00000000000000000000001;
#10 a = 32'b1_11001100_00100000000000000001011; b = 32'b0_00000011_00100000000000000011000;
#10 $finish;
end
    
initial $monitor("a = %b, b = %b, out = %b\n", a, b, out);
endmodule