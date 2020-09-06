function [yc0]=gm11cancha(x0)
n=max(size(x0));    %数组大小..
[yc0]=gm11(x0);%调用GM(1,1)模型进行预测
wucha=x0-yc0(1:n);%求出残差值
i=n;
%求后面同号的残差的数目.
while(wucha(i)*wucha(i-1)>0 & i>=2)
    i=i-1;
end
start=i;
start
length=n-i+1;
new=wucha(start:n);

if length>=4
    pwucha=gm12(new);
    n=max(size(x0));
    yc0=gm12(x0);%对可建模残差调用GM(1,1)模型对残差值进行预测
yc0(start:n+N)=yc0(start:n+N)+pwucha %yc0为残差补回后的预测数列
clear wucha;
wucha=yc0(1:n)-x0;
wucha=wucha./x0;    %相对误差
wucha=abs(wucha)*100;
rel=sum(wucha)/n;
end