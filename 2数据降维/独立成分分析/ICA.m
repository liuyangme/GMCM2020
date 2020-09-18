
%求数据的独立成分
%输入参数：Z建模数据（矩阵 n*m维，m为样本个数，n为变量个数）
%         perica提取信息含量（一个百分数）
%输出参数：W分解矩阵（矩阵 n*q维，n为变量个数，q为独立成分个数）
%         SL独立成分（矩阵 m*q维，m为样本个数，q为独立成分个数）
%         XS为X的估计值（矩阵 m*n维，m为样本个数，n为变量个数）
%         E残差信息（矩阵 m*n维，m为样本个数，n为变量个数）

clc
clear
filename = '附件一插值后.xlsx';
xlRange = 'C4:ML324';
Z = xlsread(filename,xlRange);
Z = Z';

perica=0.8;

[VariableNum,SampleNum]=size(Z);
numofIC=VariableNum;% 在此应用中，独立元个数等于变量个数
W=[];
B=zeros(numofIC,VariableNum);              % 初始化列向量w的寄存矩阵,B=[b1  b2  ...   bd]
for r=1:numofIC                            % 迭代求取每一个独立元
    i=1;maxIterationsNum=1000;j=1;              % 设置最大迭代次数（即对于每个独立分量而言迭代均不超过此次数）
    IterationsNum=0;
    b=rand(numofIC,1)-.5;                  % 随机设置b初值
    b=b/norm(b);                           % 对b标准化
    while i<=maxIterationsNum+1
        if i == maxIterationsNum           % 循环结束处理
            fprintf('\n第%d分量在%d次迭代内并不收敛。', r,maxIterationsNum);
            break;
        end
        bOld=b;                      
        a2=1;
        u=1;
        t=Z'*b;
        g=(exp(2.*t)-1)./(exp(2.*t)+1);
        dg=4*exp(2.*t)./(exp(2.*t)+1).^2;
        b=(Z*g)-mean(dg)*b;
                                            % 核心公式，参见理论部分公式2.52
        b=b-B*B'*b;                         % 对b正交化
        b=b/norm(b); 
        if abs(abs(b'*bOld)-1)<1e-9         % 如果收敛，则保存b
               B(:,r)=b; 
               W=B(:,1:r);
             break;
        end
        i=i+1;        
    end 
    SL=Z'*W;
    XS=(SL*W');
    E=Z'-XS;
    e=Message(E)/Message(Z');
    if e<(1-perica)
        fprintf('\n前%d独立成分信息量在百分之八十以上，停止提取.',r);
        break;
    end
end