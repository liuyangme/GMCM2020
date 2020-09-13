close all;
clc;clear;

global data scale;

%读取Excel数据
if numel(data)==0
    file='input.xlsx';
    range='B2:N18474';
    [data,TXT,RAW]=xlsread(file,1,range);
end 

n=size(data,2);
%特征处理
feature=data;

%特征赋权
w=[1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,1.00,0.0001,0.0001];
global ceshi_index;
ceshi_index=1;
w=0.001*ones(1,13);
w(ceshi_index)=1;

%归一化
scale=(max(feature)-min(feature));
scale=max(1e-3,scale./w);
feature_scale=feature./(ones(1,1)*scale);

%聚类分析
dis=pdist(feature_scale,'euclidean');
link=linkage(dis);
figure;dendrogram(link);xlabel('序号');ylabel('综合聚类距离尺度')
c=cluster(link,'maxclust',5);
li=feature;%li=feature_scale;
figure;scatter3(li(:,1),li(:,2),li(:,3),200,c,'filled');%hold on;for i=1:numel(c);annotation('textbox',[li(i,:)],);end
name={'max(V)','mean(V)','std(V)'};title('聚类结果');xlabel(name{1});ylabel(name{2});zlabel(name{3});

if 1
    %从cluster聚类结果中得出聚类
    mode={};
    uc=unique(c);
    for i=1:numel(uc);
        mode{i}=find(c==uc(i));
    end
end


