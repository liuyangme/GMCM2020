% 清除工作区
% clear;clc;close all;
% 创建决策变量

load w;
load tho;
I=303;   %飞机数
J=69;    %登机口数量
x = binvar(I,J);
y = binvar(1,J);

%目标函数 
u = 0.01;  %权重（权重设置需要考量）
z = sum(x(:))-u*sum(y);  %目标函数
z=-z;   %默认求解最小值，取反求最大

tic
%约束条件1---每架飞机最多停靠在一个登机口（可以不停靠在登机口，停靠在临时停靠区）
c1=[];
for i=1:I
    temp=0;
    for j=1:J
        temp=temp+x(i,j);
    end
    c1=[c1;temp<=1];
end
toc

tic
%约束条件2---每架飞机只能停靠在与自己属性相同的登机口
c2=[];
for i=1:I
    for j=1:J
        c2=[c2;x(i,j)<=w(i,j)];
    end
end
toc

tic
%约束条件3---对于第j个登机口只要有一架飞机占用，yj=1；
c3=[];
for i=1:I
    for j=1:J
        c3=[c3;x(i,j)<=y(j)];
    end
end
toc

% %约束条件4---时间间隔大于45分钟
tic
c4=[];
for m=1:I
    for n=1:I
        if m~=n
            t=x(m,:)+x(n,:)<=2-tho(m,n);
            c4=[c4;t'];
        end
    end
end
toc

C=[c1;c2;c3;c4];

% 配置
ops = sdpsettings('solver','cplex');
tic
% 求解
reuslt = optimize(C,z,ops);
toc

if reuslt.problem == 0  % problem=0:求解成功
    value(x)
    -value(z)   % 反转
else
    disp('求解出错');
end

x1=value(x);
y1=value(y);
save('x.mat','x1') 
save('y.mat','y1')

%查看结果用，不重要
% length(find(y1))   
% fenpei=sum(x1,2)
% find(fenpei==0)    
