function [yc0]= huiseguanlian(x0,r)
global x0
global x1
global r
% 数据均值化处理
x=x1';          % x是一个m*n维矩阵，每一列代表一个比较变量的原始数据，一共有n个比较变量
y=x0';          % y时一个m*1维矩阵，是参考变量的原始数据
m_x=x(1,:);                              % m_x为各个比较变量原始数列的平均数
m_y=y(1,:);                              % m_y为参考变量原始数列的平均数  

temp=size(x);                       % size得出的temp变量是一个1*2矩阵，其中第一个数为x的行数，第二个数为x的列数
b=repmat(m_x,[temp(1) 1]);          % 构造一个与x同维数的矩阵b，且此矩阵的列向量为对应x变量列向量的平均数,  
                                    % repmat（A,m,n）函数的功能是将矩阵A复制m×n块，即B由m×n块A平铺而成
x_initial=x./b;
y_initial=y./m_y;

% %数据初值化处理 
% x0_initial=x0./x0(1); 
% temp=size(x1); 
% b=repmat(x1(:,1),[1 temp(2)]); 
% x1_initial=x1./b; 

% 计算关联系数
K=0.5;                                % 分辨系数选择                

y_ext=repmat(y_initial,[1 temp(2)]);  % x_initial是一个m*1维矩阵，y_ext是x_initial被复制1*n块后得到的m*n维矩阵
contrast_mat=abs(y_ext-x_initial);    % contrast_mat是一个m*n维矩阵，矩阵中第i行j列表示第i个时刻第j个比较数列与参考数列对应期的差值的绝对值

delta_min=min(min(contrast_mat));     % delta_min为最小值中的最小值，在数据初值化后实际为零（小中取小） 
delta_max=max(max(contrast_mat));     % delta_max为最大值中的最大值，在数据初值化后实际为零（大中取大）
a=delta_min+K*delta_max;              % a为关联系数计算公式的分子，对于不同比较变量，分子是个定值
b=contrast_mat+K*delta_max;           % b为关联系数计算公式的分母
incidence_coefficient=a./b;           % 由关联系数计算公式得到关联系数incidence_coefficient，它是一个m*n维矩阵，矩阵中第i行第j列表示第i个时刻第j个比较变量与参考变量的关联性 

% 计算关联度
r=sum(incidence_coefficient)/temp(1);  % 计算关联度r，r是一个1*n维矩阵    
