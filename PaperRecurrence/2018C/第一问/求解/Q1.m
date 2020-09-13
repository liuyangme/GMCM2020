clear;clc;close all;

file='input.xlsx';
range='B2:K18474';
[data,TXT,RAW]=xlsread(file,1,range);
data=zscore(data);

[center,U,w,obj_fcn] =wfcm(data,5);
[Umax,m]=max(U);
clu=[U;m];
clu1=find(m==1);
clu2=find(m==2);
clu3=find(m==3);
clu4=find(m==4);
clu5=find(m==5);
sum(center,2)

%近二十年十大恐怖事件
P=sum(data,2)

[temp,n]=sort(P(clu3),'descend')
temp(1:10);
top10=clu3(n(1:10))



%近三年
m_=m(11050:end)
clu1_=find(m_==1);
clu2_=find(m_==2);
clu3_=find(m_==3);
clu4_=find(m_==4);
clu5_=find(m_==5);




