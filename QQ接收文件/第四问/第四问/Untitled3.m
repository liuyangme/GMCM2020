% 清除工作区
clear;clc;close all;
load a;
load b;
c=a(2:end)'*b;

delta=xlsread('附件四：354个操作变量信息.xlsx', 'Sheet1','I2:I337');
[~,range]=xlsread('附件四：354个操作变量信息.xlsx', 'Sheet1','G2:G337');
range=string(range);
for i=1:336
    max_min=strsplit(range(i),'_');
    Ximin(i)=str2double(max_min(:,1));
    Ximax(i)=str2double(max_min(:,2));
end



X1=xlsread('附件一插值后.xlsx','Sheet1','C4:J4');
X2=xlsread('附件一插值后.xlsx','Sheet1','M4:MN4');
Xp=[X1,X2];



% 创建决策变量
x=sdpvar(348,1);
n=intvar(336,1);


% 目标函数
Rl= a(1)+c*x; % 



% 约束条件1 产品硫含量x8<=5
c1=x(8)<=5;

% 约束条件2 操作数以外的变量不变
c2=[];
for i=[1:7,9:12]
   c2=[c2;x(i)==Xp(i)];
end

% 约束3
c3=[];
for i=1:336
    j=i+12;
    if i~=44&&i~=101
    c3=[c3;Ximin(i)<=x(j)<=Ximax(i)];
    end
    if i~=97&&i~=129&&i~=133
    c3=[c3;x(j)==Xp(j)+n(i)*delta(i)]; 
    end
end







% 添加约束条件
C = [c1;c2;c3];
% 配置
ops = sdpsettings('verbose',0,'solver','cplex');

% 求解
reuslt = optimize(C,Rl,ops);

value(x)
value(n)


if reuslt.problem == 0 % problem =0 代表求解成功
    value(x)
    -value(z)   % 反转
else
    disp('求解出错');
end
