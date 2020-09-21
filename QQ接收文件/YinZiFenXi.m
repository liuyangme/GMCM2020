clc;clear;
A1=xlsread('附件一插值后.xlsx','Sheet1','C4:J324');
A2=xlsread('附件一插值后.xlsx','Sheet1','M4:MN324');
A=[A1,A2];
[Astd,A_mean,A_std]=zscore(A);  %标准化


r=cov(Astd);              %计算特征之间的协方差矩阵
[vec,val,con]=pcacov(r);  %vec为特征向量，val为特征值，con为各主成分贡献率
cum=cumsum(con);

%碎石图  特征变量--特征值
x=1:348';
figure
plot(x,val,'r-','LineWidth',2);hold on

axis([-5,353,-5,120])
ylabel('特征值')
xlabel('主成分')
figure;
plot(x(7:45),val(7:45),'r-','LineWidth',2);hold on
plot(x(7:45),val(7:45),'rx-','LineWidth',1);hold on
plot(x(7:45),ones(39),'--','LineWidth',1);hold on
ylabel('特征值')
xlabel('主成分')


f1=repmat(sign(sum(vec)),size(vec,1),1);
vec=vec.*f1;%
f2=repmat(sqrt(val)',size(vec,1),1);
a=vec.*f2;        %计算全部因子的载荷矩阵
num=26;         %num为因子的个数
a1=a(:,1:num); %提出26因子的载荷矩阵
tcha=diag(r-a1*a1'); %因子的特殊方差?
ccha=r-a1*a1'-diag(tcha);%求残差矩阵?
[b,t]=rotatefactors(a(:,1:num),'method','varimax')%对载荷矩阵进行旋转
%其中b为旋转载荷矩阵，t为变换的正交矩阵?
coef=inv(r)*b;%计算得分函数的系数?
score=B*coef;





