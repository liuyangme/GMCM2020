% 回归 用于预测内部数据
% 一元线性回归：描述特征和因变量之间的线性关系
% 二元线性回归：描述多个特征和因变量之间的线性关系
% [b,bint,r,rint,s]=regress(y,[ones(length(X),1),X]) 取显著性水平默认为0.05
% 线性回归不标准化
clear ;clc;
B=xlsread('因子分析0919结果.xlsx','得分矩阵','D8:AC11');
X1=xlsread('样本数据处理后.xlsx','Sheet1','C4:J328');
X2=xlsread('样本数据处理后.xlsx','Sheet1','M4:MI328');
X=[X1,X2];
[Xstd,X_mean,X_std]=zscore(X);  %标准化
F=Xstd*B;
y=xlsread('样本数据处理后.xlsx','Sheet1','L4:L328');
n=length(F);      %n表示样本个数


[b,bint,r,rint,s]=regress(y(1:300,:),[ones(300,1),F(1:300,:)]);     %取显著性水平默认为0.05
                                                        %b 系数 bint b的置信区间
                                                        %r 残差 rint r的置信区间
rcoplot(r,rint)   %残差及其执行区间作图



mask=find(rint(:,1).*rint(:,2)<0);
newy=y(mask);
newF=F(mask,:);
[a,aint,r,rint,s]=regress(newy,[ones(length(newF(:,1)),1),newF]);     %取显著性水平默认为0.05
                                                     %b 系数 bint b的置信区间
                                                     %r 残差 rint r的置信区间
rcoplot(r,rint)   %残差及其执行区间作图



%step 2 计算预测值 
y_=[ones(325,1),F]*b;

figure;
plot(275:325,y(275:325));
hold on
plot(275:325,y_(275:325));
xlabel('样本')
ylabel('辛烷损失值')
legend('实际损失值','预测损失值')






%step 3 模型检验
epsilon=y_-y;   %残差
delta=abs(epsilon./y);      %相对误差   <0.2 达到一般要求，<0.1 达到较高要求

figure;
plot(301:325,epsilon(301:325),'o');hold on
plot(295:330,zeros(1,36),'--');
axis([295 330 -1 1])
xlabel('样本')
ylabel('残差')


