% 回归

clear ;clc;

%加载文件
B=xlsread('因子分析0919结果.xlsx','得分矩阵','D8:AC11');
X1=xlsread('样本数据处理后.xlsx','Sheet1','C4:J328');
X2=xlsread('样本数据处理后.xlsx','Sheet1','M4:MI328');
X=[X1,X2];

[Xstd,X_mean,X_std]=zscore(X);  
F=Xstd*B;
y=xlsread('样本数据处理后.xlsx','Sheet1','L4:L328');
n=length(F); %n表示样本个数

[b,bint,r,rint,s]=regress(y(1:300,:),[ones(300,1),F(1:300,:)]); 
rcoplot(r,rint)   %残差及其执行区间作图

mask=find(rint(:,1).*rint(:,2)<0);
newy=y(mask);
newF=F(mask,:);
[a,aint,r,rint,s]=regress(newy,[ones(length(newF(:,1)),1),newF]);     
rcoplot(r,rint)  %残差及其执行区间作图

%计算预测值 
y_=[ones(325,1),F]*b;

figure;
plot(275:325,y(275:325));
hold on
plot(275:325,y_(275:325));
xlabel('样本')
ylabel('辛烷损失值')
legend('实际损失值','预测损失值')

%模型检验
epsilon=y_-y;           %残差
delta=abs(epsilon./y);  %相对误差

figure;
plot(301:325,epsilon(301:325),'o');hold on
plot(295:330,zeros(1,36),'--');
axis([295 330 -1 1])
xlabel('样本')
ylabel('残差')


