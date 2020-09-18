clc
clear
filename = '附件一插值后.xlsx';
xlRange = 'C4:ML324';
data = xlsread(filename,xlRange);
data = data';

[Xrow, Xcol] = size(data);    % Xrow：样本个数 Xcol：样本属性个数

%%数据预处理
Xmean = mean(data); % 求原始数据的均值
Xstd = std(data); % 求原始数据的方差
X0 = (data-ones(Xrow,1)*Xmean) ./ (ones(Xrow,1)*Xstd); % 标准阵X0,标准化为均值0，方差1;
% c = 20000; %此参数可调
c = 200; %此参数可调

%%求核矩阵
for i = 1 : Xrow
    for j = 1 : Xrow
        %k(i,j)=kernel(data(i,:),data(j,:),2,6);   
        K(i,j) = exp(-(norm(X0(i,:) - X0(j,:)))^2/c);%求核矩阵，采用径向基核函数，参数c
    end
end

%%中心化矩阵
unit = (1/Xrow) * ones(Xrow, Xrow);
Kp = K - unit*K - K*unit + unit*K*unit; % 中心化矩阵

%%特征值分解
[eigenvector, eigenvalue] = eig(Kp); % 求协方差矩阵的特征向量（eigenvector）和特征值（eigenvalue）

%单位化特征向量(标准化)
for m =1 : 348
    for n =1 : 348
        Normvector(n,m) = eigenvector(n,m)/sum(eigenvector(:,m));
    end
end

eigenvalue_vec = real(diag(eigenvalue)); %将特征值矩阵转换为向量
[eigenvalue_sort, index] = sort(eigenvalue_vec, 'descend'); % 特征值按降序排列，eigenvalue_sort是排列后的数组，index是序号
pcIndex = []; % 记录主元所在特征值向量中的序号

pcn = 25; % 特征值个数
for k = 1 : pcn 
    pcIndex(k) = index(k); % 保存主元序号
end
for i = 1 : pcn
    pc_vector(i) = eigenvalue_vec(pcIndex(i)); % 主元向量
    P(:, i) = Normvector(:, pcIndex(i)); % 主元所对应的特征向量（负荷向量）
end
project_invectors = k*P;
pc_vector2 = diag(pc_vector); % 构建主元对角阵 

% [row, col] = size(project_invectors);
% for i = 1 : row
%     project_invectors_mean(i,1)=project_invectors(i,1)/50;
%     for j = 2 : col
%         project_invectors_mean(i,j)=project_invectors(i,j)/25;
%     end
% end

% %绘制三维散点图
% x=project_invectors(:,1);
% y=project_invectors(:,2);
% z=project_invectors(:,3);
% scatter3(x,y,z,'filled')
