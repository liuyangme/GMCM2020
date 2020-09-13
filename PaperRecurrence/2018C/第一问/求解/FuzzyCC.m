clear;clc;close all;

mu1=[2,0];
sigma1=[1 0;0 1];
mu2=[-2,0];
sigma2=[1 0;0 1];
data=mvnrnd(mu1,sigma1,50)
dlabel=ones(50,1);
data=[data;mvnrnd(mu2,sigma2,50)];
dlabel=[dlabel;ones(50,1)*2];
gscatter(data(:,1),data(:,2),dlabel);
axis equal;

if numel(data)==0
    file='input.xlsx';
    range='B2:K18474';
    [data,TXT,RAW]=xlsread(file,1,range);
end
data=zscore(data);

[center,U,obj_fcn] = fcm(data, 5)
[~,m]=max(U)
clu=[U;m]
clu1=find(m==1);
clu2=find(m==2);
clu3=find(m==3);
clu4=find(m==4);
clu5=find(m==5);
[U1,center1,Dist,Cluster_Res1,Obj_Fcn1,iter]= fuzzycm(data, 2,1)
sum(center,2)



