%[Da,data]=xlsread('1.xlsx','Sheel1','A2:L754');
clear;clc;close all;
load('ArrivalType.mat','ArrivalType');    %航班到达类型数据存放在ArrivalType.mat文件，数据变量命名为ArrivalType 
load('ArrivalType1.mat','ArrivalType1');  %登机口到达类型数据存放在ArrivalType1.mat文件，数据变量命名为ArrivalType1 
load('LeaveType.mat','LeaveType');        %航班出发类型数据存放在LeaveType.mat文件，数据变量命名为LeaveType 
load('LeaveType1.mat','LeaveType');       %登机口出发类型数据存放在LeaveType1.mat文件，数据变量命名为LeaveType1 
load('PlaneType.mat','PlaneType');        %飞机宽窄类型数据存放在PlaneType.mat文件，数据变量命名为PlaneType
load('PlaneType1.mat','PlaneType');       %登机口宽窄类型数据存放在PlaneType1.mat文件，数据变量命名为PlaneType1
load('ArrivalTime.mat','ArrivalTime');    %航班到达时间数据存放在ArrivalTime.mat文件，数据变量命名为ArrivalTime
load('LeaveTime.mat','LeaveTime');        %航班出发时间数据存放在LeaveTime.mat文件，数据变量命名为LeaveTime
I=303;   %飞机数 
J=69;    %登机口数量
w=zeros(I,J);
for i=1:I
    for j=1:J
        if PlaneType(i)==PlaneType1(j)
            if ArrivalType1(j)==2
                if LeaveType1(j)==2
                    w(i,j)=1;
                elseif LeaveType(i)==LeaveType1(j)
                     w(i,j)=1;
                end
            elseif ArrivalType(i)==ArrivalType1(j)
                if LeaveType1(j)==2
                    w(i,j)=1;
                elseif LeaveType(i)==LeaveType1(j)
                     w(i,j)=1;
                end
            end  
        end
    end
end

tho=zeros(I,I);   %高危程序
for m=1:I
    for n=1:I
        if m==n
            r=0;
        else
            r=LeaveTime(m)-ArrivalTime(n);
        end
        if   r>45                 %大于等于？
            tho(m,n)=0;           %第m架飞机和第n架飞机可以停靠在同一登机口
        else
             tho(m,n)=1;          %第m架飞机和第n架飞机不可以停靠在同一登机口
        end
    end
end

save('tho.mat','tho') 
save('w.mat','w')

                    
        
