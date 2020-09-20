% 清除工作区
clear;clc;close all;
load a;
load b;
c=a(2:end)'*b;
c0=a(1);
Xmin=xlsread('筛选后331个操作变量信息.xlsx', 'Sheet1','F2:F332');
Xmax=xlsread('筛选后331个操作变量信息.xlsx', 'Sheet1','G2:G332');
delta=xlsread('筛选后331个操作变量信息.xlsx', 'Sheet1','J2:J332');

X1=xlsread('样本数据处理后.xlsx','Sheet1','C4:J4');
X2=xlsread('样本数据处理后.xlsx','Sheet1','Q4:MI4')';
% Xp=[X1,X2];

A=zeros(662,331);
j=0;
b=zeros(662,1);
for i=1:2:662
    j=j+1;
    A(i,j)=1;
    A(i+1,j)=-1;
    b(i)=Xmax(j); 
    b(i+1)=-Xmin(j); 
end

Aeq=[];
beq=[];

[x,fval]=linprog(c(13:end),A,b,Aeq,beq)