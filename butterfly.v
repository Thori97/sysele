`timescale 1ns / 1ps
`include "define.vh"
module butterfly(
    input clk,
    input inp,
    input [31:0]signal,
    output oup,
    output [31:0]spector
);
reg [31:0]record[`N-1:0];
reg [31:0]nodes_re[`N-1:0];
reg [31:0]nodes_im[`N-1:0];
reg [3:0]times;
reg [3:0]count;
integer i, j, k, a_, b_, s;
initial begin
    i = 0;
    j = 0;
    k = 0;
end
always @ (posedge clk) begin
    record[i%`N] = signal;  //常に
    i=i+1;                  //clkごとに順にデータ格納
    
    if(i %`N ==0) begin     //clk=0でバタフライ用のノード初期化
        for(j=0;j<`N;j=j+1) begin
            nodes_re[j] <= record[j];
            nodes_im[j] <= 0;
        end
        if(i%`N == `N-1) i = 0;
    end
    else if((1 <= i%`N) &&(i%`N <= `logN ) )begin//データ格納と並行してFFT(logN回でできる)
        for(j=0;j<2**(3-i);j=j+1)begin      //回す回数
            for(k=0;k<2**(i-1);k=k+1)begin  //回す回数
                  nodes_re[j+k] <= add(add(nodes_re[j+k], mul(nodes_re[2*j+k], W(k, 2**i, 0))), mul(nodes_im[2*j+k], W(k,2**i,1)));//バタフライ演算
                  nodes_im[j+k] <= add(add(nodes_im[j+k], mul(nodes_re[2*j+k], W(k, 2**i, 1))), mul(nodes_im[2*j+k], W(k,2**i,0)));
                  nodes_re[2*j+k] <= add(nodes_re[2*j+k], mul(nodes_re[j+k], W(1, 255, 0)));
                  nodes_im[2*j+k] <= add(nodes_im[2*j+k], mul(nodes_re[j+k], W(1, 255, 0)));
            end
        end
    end
end

function [31:0]mul(input[31:0] a, input[31:0] b);
    begin
        mul[31] = a[31]^b[31];
        mul[30:23] =  $signed(a[30:23]) + $signed(b[30:23]);
        mul[22:0] = a[22:0]*b[22:0];
    end
endfunction

function [31:0]add(input [31:0]a, input [31:0]b);
    begin
        if($signed(a[30:23])>$signed(b[30:23])) 
        begin
            s = ($signed(a[30:23])-$signed(b[30:23]));
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

function [31:0]W(input[8:0] N, input [8:0] i, input ri);//theta = i/N*pi, ri = 1 実部　i = 0虚部
    begin
        i = i * 128 / N;
        if(ri == 0 && i>=32) i = i-32;
        else if(ri == 0 && i<32) begin i = 32-i; i[8] =1; end//すごく怪しい
        case (i%32)//cosを返す
            0:W = 32'b00111111100000000000000000000000;//1.0
            1:W = 32'b00111111011111101100010001101101;//0.9987954562051724
            2:W = 32'b00111111011111101100010001101101;//0.9951847266721969
            3:W = 32'b00111111011111010011101010101011;//0.989176509964781
            4:W = 32'h3F7B14BE;//0.9807852804032304
            5:W = 32'h3F7853F7;//0.970031253194544
            6:W = 32'h3F74FA0A;//0.9569403357322088
            7:W = 32'h3F710908;//0.9415440651830208
            8:W = 32'h3F6C835E;//0.9238795325112867
            9:W = 32'h3F676BD7;//0.9039892931234433
            10:W = 32'h3F61C597;//0.881921264348355
            11:W = 32'h3F5B941A;//0.8577286100002721
            12:W = 32'h3F54DB31;//0.8314696123025452
            13:W = 32'h3F4D9F02;//0.8032075314806449
            14:W = 32'h3F45E403;//0.773010453362737
            15:W = 32'h3F3DAEF9;//0.7409511253549591
            16:W = 32'h3F3504F3;//0.7071067811865476
            17:W = 32'h3F2BEB49;//0.6715589548470183
            18:W = 32'h3F226799;//0.6343932841636455
            19:W = 32'h3F187FBF;//0.5956993044924335
            20:W = 32'h3F0E39D9;//0.5555702330196023
            21:W = 32'h3F039C3C;//0.5141027441932217
            22:W = 32'h3EF15AE9;//0.4713967368259978
            23:W = 32'h3EDAE880;//0.4275550934302822
            24:W = 32'h3EC3EF15;//0.38268343236508984
            25:W = 32'h3EAC7CD3;//0.33688985339222005
            26:W = 32'h3E94A031;//0.29028467725446233
            27:W = 32'h3E78CFCB;//0.24298017990326398
            28:W = 32'h3E47C5C1;//0.19509032201612833
            29:W = 32'h3E164083;//0.14673047445536175
            30:W = 32'h3DC8BD35;//0.09801714032956077
            31:W = 32'h3D48FB2F;//0.049067674327418126
            32:W = 32'h00000000;//0.0
            default: W = 32'h00000000;
        endcase
        if(i==32 || i==96) W = 32'h00000000;//3/2pi, 1/2pi
        if((i%128 == 2 || i%128==3 ) && (ri == 1)) W[31] = 1;//偏角1/2pi~3/2piなら符号反転
        if(ri == 0)begin
            if(i/32 == 1 || i/32 == 0) W[31] = 1;
            if(i[8] == 0) W[31] = 0;
        end
        if(i==255) W = 32'b10111111100000000000000000000000;//i=255なら-1
    end
endfunction

endmodule