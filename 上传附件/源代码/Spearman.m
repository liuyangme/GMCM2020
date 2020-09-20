%Spearman斯皮尔曼相关性分析
clc;
clear;
close;

%加载文件
filename = '5插值完成.xlsx';
xRange = 'C4:MI328';
xdata = xlsread(filename,xRange);

%X为n行P列矩阵，表示有P个特征，每个特征有n个样本点
%coeff为P行P列矩阵，coeff(i,j)表示第i个特征和第j个特征的相关系数
coeff = corr(xdata,'type','Spearman');


