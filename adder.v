`timescale 1ns/1ps
//浮動小数点+浮動小数点
module adder(
    input [31:0]a,
    input [31:0]b,
    output [31:0]c
);
    assign c = add(a, b);
    integer i, a_, b_;
    function [31:0]add(input [31:0]a, input [31:0]b);
    /*begin
        if($signed(a[30:23])>=$signed(b[30:23]))begin
            //b[22:0] >>> ($signed(a) - $signed(b));
            //integer i;
            i = ($signed(a) - $signed(b));
            add[30:23] = a[30:23];
            if(a[31] == 0 && b[31] == 0) begin
                add[22:0] = $unsigned(a[22:0]) + $unsigned(b[22:0]>>>i);
                add[31] = 0;
            end
            else if(a[31] == 1 && b[31] == 0) begin
                add[22:0] = ($unsigned(b[22:0]>>>i)>$unsigned(a[22:0])) ? (b[22:0]>>>i)-a[22:0]:a[22:0]-(b[22:0]>>>i);
                add[31] = ($unsigned(b)>$unsigned(a)) ? 0:1;
            end
            else if(a[31] == 0 && b[31] == 1) begin
                add[22:0] = ($unsigned(a[22:0])>$unsigned(b[22:0]>>>i)) ? a[22:0]-(b[22:0]>>>i):(b[22:0]>>>i)-a[22:0];
                add[31] = ($unsigned(a[22:0])>$unsigned(b)) ? 0:1;
            end
            else begin
            add[22:0] = $unsigned(b) + $unsigned(a);
            add[31] = 1;
            end
        end
        else begin
            //a[22:0] >>> ($signed(b) - $signed(a));
            add[30:23] = b[30:23];

            if(a[31] == 0 && b[31] == 0) begin
                add[22:0] = $unsigned(a) + $unsigned(b);
                add[31] = 0;
            end
            else if(a[31] == 1 && b[31] == 0) begin
                add[22:0] = ($unsigned(b)>$unsigned(a)) ? b-a:a-b;
                add[31] = ($unsigned(b)>$unsigned(a)) ? 0:1;
            end
            else if(a[31] == 0 && b[31] == 1) begin
                add[22:0] = ($unsigned(a)>$unsigned(b)) ? a-b:b-a;
                add[31] = ($unsigned(a)>$unsigned(b)) ? 0:1;
            end
            else begin
            add[22:0] = $unsigned(b) + $unsigned(a);
            add[31] = 1;
            end
        end
    end*/
    begin
        if($signed(a[30:23])>$signed(b[30:23])) 
        begin
            i = ($signed(a[30:23])-$signed(b[30:23]));
            b_ = b[22:0] >>> i;
            a_ = a[22:0];
            add[30:23] = a[30:23];
            if(a[31]==0&&b[31]==0) begin
                add[22:0] = b_ + a[22:0];
                add[31] = 0;
            end
            else if(a[31]==0&&b[31]==1) begin
                add[22:0] = (a_>b_) ? a_ - b_ :b_ - a_;
                add[31] = (a_>b_)?0:1;
            end
            else if(a[31]==1&&b[31]==0) begin
                add[22:0] = (a_<b_) ? b_ - a_ :a_ - b_;
                add[31] = (b_>a_)?0:1;
            end
            else begin
                add[22:0] = b_ + a_;
                add[31] = 1;
            end
        end
        else begin
            i = ($signed(b[30:23])-$signed(b[30:23]));
            a_ = a[22:0] >>> i;
            b_ = b[22:0];
            add[30:23] = b[30:23];
            if(a[31]==0&&b[31]==0) begin
                add[22:0] = a_ + b[22:0];
                add[31] = 0;
            end
            else if(a[31]==0&&b[31]==1) begin
                add[22:0] = (a_>b_) ? a_ - b_ :b_ - a_;
                add[31] = (a_>b_)?0:1;
            end
            else if(a[31]==1&&b[31]==0) begin
                add[22:0] = (a_<b_) ? b_ - a_ :a_ - b_;
                add[31] = (b_>a_)?0:1;
            end
            else begin
                add[22:0] = b_ + a_;
                add[31] = 1;
            end
        end

    end
    endfunction

endmodule