% [Da,data]=xlsread('1.xlsx','Sheel1','A2:L754');
clear;clc;close all;

% 航班到达类型数据存放在PlaneArrivalType.mat文件，数据变量命名为PlaneArrivalType 
% 0：国内出发
% 1：国际出发
load('PlaneArrivalType.mat','PlaneArrivalType');

% 登机口到达类型数据存放在PortArrivalType.mat文件，数据变量命名为PortArrivalType
% 0：国内到达
% 1：国际到达
% 2：国内国际到达
load('PortArrivalType.mat','PortArrivalType');  

% 航班出发类型数据存放在PlaneLeaveType.mat文件，数据变量命名为PlaneLeaveType
% 0：国内出发
% 1：国际出发
load('PlaneLeaveType.mat','PlaneLeaveType');   
    
% 登机口出发类型数据存放在PortLeaveType.mat文件，数据变量命名为PortLeaveType
% 0：国内出发
% 1：国际出发
% 2：国内国际出发
load('PortLeaveType.mat','PortLeaveType');       

% 飞机宽窄类型数据存放在PlaneType.mat文件，数据变量命名为PlaneType
% 0：宽飞机
% 1：窄飞机
load('PlaneType.mat','PlaneType'); 

% 登机口宽窄类型数据存放在PortType.mat文件，数据变量命名为PortType
% 0：宽飞机
% 1：窄飞机
load('PortType.mat','PortType');   % 约定与上面飞机宽窄的约定不一致（20200831刘阳已修正）

% 航班到达时间数据存放在PlaneArrivalTime.mat文件，数据变量命名为PlaneArrivalTime
load('PlaneArrivalTime.mat','PlaneArrivalTime'); 

% 航班出发时间数据存放在PlaneLeaveTime.mat文件，数据变量命名为PlaneLeaveTime
load('PlaneLeaveTime.mat','PlaneLeaveTime');       

I=303;   %飞机数 
J=69;    %登机口数量

w=zeros(I,J);
for i=1:I
    for j=1:J
        if PlaneType(i)==PortType(j)
            if PortArrivalType(j)==2
                if PortLeaveType(j)==2
                    w(i,j)=1;
                elseif PlaneLeaveType(i)==PortLeaveType(j)
                    w(i,j)=1;
                end
            elseif PlaneArrivalType(i)==PortArrivalType(j)
                if PortLeaveType(j)==2
                    w(i,j)=1;
                elseif PlaneLeaveType(i)==PortLeaveType(j)
                    w(i,j)=1;
                end
            end   
        end  
    end
end


% r值应该是到达时间（大）减去离开时间（小）
% r值的判断应该是大于等于
% 赋值逻辑不完整

% for m=1:I
%     for n=1:I
%         if m==n
%             r=0;
%         else
%             r=LeaveTime(m)-ArrivalTime(n);
%         end
%         if   r>45                 
%             tho(m,n)=0;           %第m架飞机和第n架飞机可以停靠在同一登机口
%         else
%             tho(m,n)=1;           %第m架飞机和第n架飞机不可以停靠在同一登机口
%         end
%     end
% end

tho=zeros(I,I);
% 初始化是全零矩阵

% 1：不能停靠在同一登机口
% 0：可以停靠在同一登机口

% 20200831 这里还是有问题

for m=1:I 
    for n=1:I
        if m==n 
            IntervalTime = 0; %同一架航班不做比较
            tho(m,n) = 1;
        else 
            IntervalTime = PlaneArrivalTime(m) - PlaneLeaveTime(n); %计算两架航班的间隔时间
            if IntervalTime >= 45
                tho(m,n) = 0;
            else
                tho(m,n) = 1;
            end
        end
    end
end

save('tho.mat','tho') 
save('w.mat','w')

