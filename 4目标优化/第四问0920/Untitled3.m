% 清除工作区
clear;clc;close all;
load a;
load b;
c=a(2:end)'*b;

Xmin=xlsread('筛选后331个操作变量信息.xlsx', 'Sheet1','F2:F332');
Xmax=xlsread('筛选后331个操作变量信息.xlsx', 'Sheet1','G2:G332');
delta=xlsread('筛选后331个操作变量信息.xlsx', 'Sheet1','J2:J332');
Xp=xlsread('样本数据处理后.xlsx','Sheet1','Q4:MI4')';


% 创建决策变量
x=sdpvar(13,1);
n=intvar(1,1);

% 目标函数
% Rl=c(1:end)*x;
Rl=c(1:13)*x;

% 约束条件1 产品硫含量x8<=5
c1=x(8)==5;

% 约束条件2 操作数以外的变量不变
c2=[];
for i=[1:7,9:12]
   c2=[c2;x(i)==Xp(i)];
end

% 约束3
c3=[];
for i=13:13
    c3=[c3;x(i)<=Xmax(i-12)];
end

c4=[];
for i=13:13
    c4=[c4;Xmin(i-12)<=x(i)];
end

% 约束4
% c4=[];
% for i=1:331
%     if i~=124&&i~=128
%     c4=[c4;x(i)==Xp(i)+n(i)*delta(i)]; 
%     end
% end

% 添加约束条件
% C = [c1;c2;c3;c4];
C = [c3;c4];
% 配置
ops = sdpsettings('solver','cplex');

% 求解
reuslt = optimize(C,Rl);

if reuslt.problem == 0 % problem =0 代表求解成功
    value(x)
    -value(z)   % 反转
else
    disp('求解出错');
    display('错了亲');
	reuslt.info
	yalmiperror(reuslt.problem)
end
