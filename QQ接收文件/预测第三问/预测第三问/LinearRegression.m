% 回归 用于预测内部数据
% 一元线性回归：描述特征和因变量之间的线性关系
% 二元线性回归：描述多个特征和因变量之间的线性关系
% [b,bint,r,rint,s]=regress(y,[ones(length(X),1),X]) 取显著性水平默认为0.05
% 线性回归不标准化
clear ;clc;
B=xlsread('因子分析分组.xlsx','Sheet2','B4:AB351');

X1=xlsread('附件一插值后.xlsx','Sheet1','C4:J324');
X2=xlsread('附件一插值后.xlsx','Sheet1','M4:MN324');
X=[X1,X2];
[Xstd,X_mean,X_std]=zscore(X);  %标准化

F=X*B;
[Fstd,F_mean,F_std]=zscore(F);
y=xlsread('附件一插值后.xlsx','Sheet1','L4:L324');
[ystd,y_mean,y_std]=zscore(y);




[b,bint,r,rint,s]=regress(ystd,[ones(321,1),Fstd]);     %取显著性水平默认为0.05
                                                     %b 系数 bint b的置信区间
                                                     %r 残差 rint r的置信区间
rcoplot(r,rint)   %残差及其执行区间作图



mask=find(rint(:,1).*rint(:,2)<0)
[b,bint,r,rint,s]=regress(ystd(mask),[ones(length(mask),1),Fstd(mask,:)]);     %取显著性水平默认为0.05
                                                     %b 系数 bint b的置信区间
                                                     %r 残差 rint r的置信区间
rcoplot(r,rint)   %残差及其执行区间作图




% mask=find(rint(:,1).*rint(:,2)<0)
% newy=newy(mask);
% newF=newF(mask,:);
% [b,bint,r,rint,s]=regress(newy,[ones(length(newF(:,1)),1),newF]);     %取显著性水平默认为0.05
%                                                      %b 系数 bint b的置信区间
%                                                      %r 残差 rint r的置信区间
% rcoplot(r,rint)   %残差及其执行区间作图
% 
% 
% mask=find(rint(:,1).*rint(:,2)<0)
% newy=newy(mask);
% newF=newF(mask,:);
% [b,bint,r,rint,s]=regress(newy,[ones(length(newF(:,1)),1),newF]);     %取显著性水平默认为0.05
%                                                      %b 系数 bint b的置信区间
%                                                      %r 残差 rint r的置信区间
% rcoplot(r,rint)   %残差及其执行区间作图
% 
% 
% mask=find(rint(:,1).*rint(:,2)<0)
% newy=newy(mask);
% newF=newF(mask,:);
% [b,bint,r,rint,s]=regress(newy,[ones(length(newF(:,1)),1),newF]);     %取显著性水平默认为0.05
%                                                      %b 系数 bint b的置信区间
%                                                      %r 残差 rint r的置信区间
% rcoplot(r,rint)   %残差及其执行区间作图

 


%step 2 计算预测值



y_=[ones(321,1),Fstd]*b
y1=y_.*y_std+y_mean
%step 3 模型检验
epsilon=y1-y   %残差
delta=abs(epsilon./y)      %相对误差   <0.2 达到一般要求，<0.1 达到较高要求

figure;
plot(1:321,epsilon,'o');hold on
plot(-5:330,zeros(1,336),'--');
axis([-5 330 -1 1.5])
xlabel('样本')
ylabel('残差')