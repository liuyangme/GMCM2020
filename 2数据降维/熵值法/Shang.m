clc
clear
filename = '附件一插值后.xlsx';
xlRange = 'C4:ML324';
R = xlsread(filename,xlRange);
% R = R';

[rows,cols]=size(R);   % 输入矩阵的大小,rows为对象个数，cols为指标个数
k=1/log(rows);         % 求k
Rmin = min(R);
Rmax = max(R);
A = max(R) - min(R);
y = R - repmat(Rmin,321,1);
%y(i,j) = (R - repmat(Rmin,51,1))/(repmat(A,51,1));
for j = 1 : size(y,2)
     y(:,j) = y(:,j)/A(j)
end
%2 求Y（i,j）
S = sum(y,1)
Y = zeros(rows,cols); 
for i = 1 : size(Y,2)
    Y(:,i) = y(:,i)/S(i)
end
%3
lnYij=zeros(rows,cols);  % 初始化lnYij
% 计算lnYij
for i=1:rows
    for j=1:cols
        if Y(i,j)==0
            lnYij(i,j)=0;
        else
            lnYij(i,j)=log(Y(i,j));
        end
    end
end
ej=-k*(sum(Y.*lnYij,1)); % 计算熵值Hj
ej1=ej';
%4
weights=(1-ej)/(cols-sum(ej));
%5
F = zeros(rows,cols);
for k = 1 : size(R,2)
     F(:,k) = weights(k)*y(:,k)
end
format long
F = sum(F,2)  %F即为对6个变量进行熵权法客观赋权后，计算获得的51年来的综合评分