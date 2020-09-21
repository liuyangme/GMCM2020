% 2.2.2 将二进制编码转化为十进制数(2)
% decodechrom.m函数的功能是将染色体(或二进制编码)转换为十进制.
% spoint=cumsom([0 L])表示待解码的二进制串的起始位置,L(i)表示第i个变量的长度
% 例如有三个变量，长度分别为L=[10 5 6]，cumsom([0 L])=[0 10 15 21];因此第i个
% 变量的起始位置就是starpoint=spoint(i)+1;终止位置endpoint=spoint(j+1).
% varnum变量个数
% real(i,j) 第i个个体第j个变量的实际十进制值
%遗传算法子程序
%Name: decodechrom.m
%将二进制编码转换成十进制
function real=decodechrom(spoint,varnum,pop,Xmax,Xmin)
[px,py]=size(pop);
real=zeros(px,varnum);%真实的十进制值
    for i=1:px
        for j=1:varnum
            starpoint=spoint(j)+1;
            endpoint=spoint(j+1);
            real(i,j)=decodebinary(pop(i,starpoint:endpoint),Xmax(j),Xmin(j));
        end
    end
