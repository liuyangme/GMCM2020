function [center,U,w,Obj_Fcn,iter]=wfcm(Data,C,plotflag,M,epsm)
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
w=rand(1,S);
w=w./sum(w);
% FCM 的迭代算法
while iter<1000 
    % 迭代计数器
    iter=iter+1; 
    % 第二步
    % 计算或更新聚类中心 center
    Um=U0.^M;
    center=Um*Data./(ones(S,1)*sum(Um'))';   
    
    %第三步
    % 更新划分矩阵 U
    for i=1:C
        for j=1:N
            Dist(i,j)=fuzzydist(center(i,:),Data(j,:),w);
        end
    end  
    
    
    U=1./(Dist.^m.*(ones(C,1)*sum(Dist.^(-m))));  
    
   dxc=zeros(C,N,S); 
   for i=1:C
        for j=1:N
            dxc(i,j,:)=Um(i,j).*(Data(j,:)-center(i,:)).^2;
        end
   end
   for s=1:S
        tempvar1(s)=sum(sum(dxc(:,:,s))).^(-1); 
   end
  
   tempvar2=sum(tempvar1);
   w= tempvar1./ tempvar2;
   
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

end



function D=fuzzydist(A,B,w)
% 模糊聚类分析: 样本间的距离
% D = fuzzydist(A,B)
D=norm((A-B)*diag(w));
end