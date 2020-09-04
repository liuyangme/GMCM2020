% 清除工作区
% clear;clc;close all;
% 创建决策变量

load w;
load tho;

load('Da_Dl_Ia_Il.mat')
load('PlaneTracePeopleNumber.mat')

I=303;   %飞机数
J=69;    %登机口数量
Jt=28;

%Trans + 到达类型 + 出发类型 + 到达登机口 + 出发登机口
% D:国内
% I:国际
% T:登机楼
% S:卫星厅
TransDDTT=15;
TransDDTS=20;
TransDDST=20;
TransDDSS=15;

TransDITT=35;
TransDITS=40;
TransDIST=40;
TransDISS=35;

TransIDTT=35;
TransIDTS=40;
TransIDST=40;
TransIDSS=45;

TransIITT=20;
TransIITS=30;
TransIIST=30;
TransIISS=20;


x = binvar(I,J);
y = binvar(1,J);

T= binvar(1,I);
S= binvar(1,I);
%目标函数
% u = 0.005;   %权重（权重设置需要考量）
u = 0.01;
lamda = 100000;
count=0;
for i=1:303
    for j=1:303
       if trace_nop_mat(i,j)~=0;
          count=count+1;
          time(count)=(Da(i)*Dl(j)*T(i)*T(j)*TransDDTT+...
           Da(i)*Dl(j)*T(i)*S(j)*TransDDTS+...
           Da(i)*Dl(j)*S(i)*T(j)*TransDDST+...
           Da(i)*Dl(j)*S(i)*S(j)*TransDDSS+...
           Da(i)*Il(j)*T(i)*T(j)*TransDITT+...
           Da(i)*Il(j)*T(i)*S(j)*TransDITS+...
           Da(i)*Il(j)*S(i)*T(j)*TransDIST+...
           Da(i)*Il(j)*S(i)*S(j)*TransDISS+...
           Ia(i)*Dl(j)*T(i)*T(j)*TransIDTT+...
           Ia(i)*Dl(j)*T(i)*S(j)*TransIDTS+...
           Ia(i)*Dl(j)*S(i)*T(j)*TransIDST+...
           Ia(i)*Dl(j)*S(i)*S(j)*TransIDSS+...
           Ia(i)*Il(j)*T(i)*T(i)*TransIITT+...
           Ia(i)*Il(j)*T(i)*S(i)*TransIITS+...
           Ia(i)*Il(j)*S(i)*T(i)*TransIIST+...
           Ia(i)*Il(j)*S(i)*S(i)*TransIISS)*trace_nop_mat(i,j);
       end
    end  
end

z1=sum(time);   %目标一

z=z1-lamda*sum(x(:))+u*sum(y);  %目标函数






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

%约束条件4---时间间隔大于45分钟
tic
c4=[];
for m=1:I-1
    for n=m+1:I
        t=x(m,:)+x(n,:)<=2-tho(m,n);
        c4=[c4;t'];
    end
end
toc

%约束条件5---是否在航站楼登机口
tic
c5=[];
for i=1:I
    temp=0;
    for j=1:Jt
        temp=temp+x(i,j);
    end
    c5=[c5;temp==T(i)];
end
toc

%约束条件6---是否在卫星厅登机口
tic
c6=[];
for i=1:I
    temp=0;
    for j=Jt+1:J
        temp=temp+x(i,j);
    end
    c6=[c6;temp==S(i)];
end
toc


%约束条件5---是否在航站楼登机口
% tic
% c7=[];
% c8=[];
% for i=1:length(Da)
%     
%     c7=[c5;Ta(i)+Sa(i)<=1];
%     c8=[c6;Tl(i)+Sl(i)<=1];
% end
% toc
C=[c1;c2;c3;c4;c5;c6];

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

x2=value(x);
y2=value(y);
save('x2.mat','x2') 
save('y2.mat','y2')
Ti=value(T);
Si=value(S);
save('Ti.mat','T') 
save('Si.mat','S')





%查看结果用，不重要
% length(find(y1))   
% fenpei=sum(x1,2)
% find(fenpei==0)    
% x_Q1=load('C:\Users\张耹铭\Desktop\18F最终版\x.mat','x1');
% find(abs(x2-x_Q1.x1))






