function [U,center,Dist,Cluster_Res,Obj_Fcn,iter]=fuzzycm(Data,C,plotflag,M,epsm)
% 模糊 C 均值聚类 FCM: 从随机初始化划分矩阵开始迭代
% [U,P,Dist,Cluster_Res,Obj_Fcn,iter] = fuzzycm(Data,C,plotflag,M,epsm)
% 输入:
%     Data: N×S 型矩阵,聚类的原始数据,即一组有限的观测样本集,
%           Data 的每一行为一个观测样本的特征矢量,S 为特征矢量
%           的维数,N 为样本点的个数
%     C:    聚类数,1<C<N
%     plotflag: 聚类结果 2D/3D 绘图标记,0 表示不绘图,为缺省值        
%     M:    加权指数,缺省值为 2
%     epsm: FCM 算法的迭代停止阈值,缺省值为 1.0e-6
% 输出:
%     U:     C×N 型矩阵,FCM 的划分矩阵
%     center:C×S 型矩阵,FCM 的聚类中心,每一行对应一个聚类原型
%     Dist:  C×N 型矩阵,FCM 各聚类中心到各样本点的距离,聚类中
%            心 i 到样本点 j 的距离为 Dist(i,j)
%     Cluster_Res: 聚类结果,共 C 行,每一行对应一类
%     Obj_Fcn: 目标函数值
%     iter: FCM 算法迭代次数
% See also: fuzzydist maxrowf fcmplot
if nargin<5             %默认阈值1.0e-6
    epsm=1.0e-6; 
end
if nargin<4             %默认M=2
    M=2;
end
if nargin<3            %绘图标记
    plotflag=0;
end

[N,S]=size(Data);      %数据N个样本，S个特征
m=2/(M-1);
iter=0;
Dist(C,N)=0; 
U(C,N)=0; 
center(C,S)=0;

% 步骤一
% 随机初始化划分矩阵
U0 = rand(C,N); 
U0=U0./(ones(C,1)*sum(U0));

% FCM 的迭代算法
while true 
    % 迭代计数器
    iter=iter+1; 
    % 第二步
    % 计算或更新聚类中心 center
    Um=U0.^M;
    center=Um*Data./(ones(S,1)*sum(Um'))';   
    
    % 更新划分矩阵 U
    for i=1:C
        for j=1:N
            Dist(i,j)=fuzzydist(center(i,:),Data(j,:));
        end
    end  
    
    U=1./(Dist.^m.*(ones(C,1)*sum(Dist.^(-m))));  
    
    % 目标函数值: 类内加权平方误差和
    if nargout>4 | plotflag
        Obj_Fcn(iter)=sum(sum(Um.*Dist.^2));
    end
    
    % FCM 算法迭代停止条件
    if norm(U-U0,Inf)<epsm
        break
    end
    U0=U;   
end



% 聚类结果
if nargout > 3
    res = maxrowf(U);
    for c = 1:C
        v = find(res==c);
        Cluster_Res(c,1:length(v))=v;
    end
end
% 绘图
if plotflag
    fcmplot(Data,U,center,Obj_Fcn);
end



function D=fuzzydist(A,B)
% 模糊聚类分析: 样本间的距离
% D = fuzzydist(A,B)
D=norm(A-B);







% 
function fcmplot(Data,U,P,Obj_Fcn)
% FCM 结果绘图函数
% See also: fuzzycm maxrowf ellipse
[C,S] = size(P); res = maxrowf(U);
str = 'po*x+d^v><.h'; 
% 目标函数绘图
figure(1),plot(Obj_Fcn)
title('目标函数值变化曲线','fontsize',8)
% 2D 绘图
if S==2 
    figure(2),plot(P(:,1),P(:,2),'rs'),hold on
    for i=1:C
        v=Data(find(res==i),:); 
        plot(v(:,1),v(:,2),str(rem(i,12)+1))      
        ellipse(max(v(:,1))-min(v(:,1)), ...
                max(v(:,2))-min(v(:,2)), ...
                [max(v(:,1))+min(v(:,1)), ...
                max(v(:,2))+min(v(:,2))]/2,'r:')    
    end
    grid on,title('2D 聚类结果图','fontsize',8),hold off
end
% 3D 绘图
if S>2 
    figure(2),plot3(P(:,1),P(:,2),P(:,3),'rs'),hold on
    for i=1:C
        v=Data(find(res==i),:);
        plot3(v(:,1),v(:,2),v(:,3),str(rem(i,12)+1))      
        ellipse(max(v(:,1))-min(v(:,1)), ...
                max(v(:,2))-min(v(:,2)), ...
                [max(v(:,1))+min(v(:,1)), ...
                max(v(:,2))+min(v(:,2))]/2, ...
                'r:',(max(v(:,3))+min(v(:,3)))/2)   
    end
    grid on,title('3D 聚类结果图','fontsize',8),hold off
end
% 




% 
function mr=maxrowf(U,c)
% 求矩阵 U 每列第 c 大元素所在行,c 的缺省值为 1
% 调用格式: mr = maxrowf(U,c)
% See also: addr
if nargin<2
    c=1;
end
N=size(U,2);mr(1,N)=0;
for j=1:N
    aj=addr(U(:,j),'descend');
    mr(j)=aj(c);
end
% 

function ellipse(a,b,center,style,c_3d)
% 绘制一个椭圆
% 调用: ellipse(a,b,center,style,c_3d)
% 输入:
%     a: 椭圆的轴长(平行于 x 轴)
%     b: 椭圆的轴长(平行于 y 轴)
%     center: 椭圆的中心 [x0,y0],缺省值为 [0,0]
%     style: 绘制的线型和颜色,缺省值为实线蓝色
%     c_3d:   椭圆的中心在 3D 空间中的 z 轴坐标,可缺省
if nargin<4
    style='b';
end
if nargin<3 | isempty(center)
    center=[0,0];
end
t=1:360;
x=a/2*cosd(t)+center(1);
y=b/2*sind(t)+center(2);
if nargin>4
    plot3(x,y,ones(1,360)*c_3d,style)
else
    plot(x,y,style)
end

function f = addr(a,strsort)
% 返回向量升序或降序排列后各分量在原始向量中的索引
% 函数调用:f = addr(a,strsort)
% strsort: 'ascend' or 'descend'
%          default is 'ascend'
% -------- example --------
% addr([ 4 5 1 2 ]) returns ans:
%       [ 3   4   1   2 ]
if nargin==1
    strsort='ascend';
end
sa=sort(a); ca=a;
la=length(a);f(la)=0;
for i=1:la
    f(i)=find(ca==sa(i),1);
    ca(f(i))=NaN;
end
if strcmp(strsort,'descend')
    f=fliplr(f);
end