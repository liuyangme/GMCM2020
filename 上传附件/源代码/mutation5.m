% 遗传算法子程序:变异mutation.m
% 基因的突变普遍存在于生物的进化过程中.在二进制编码中,变异是指父代中的每个
% 个体的每一位都以概率 pm 翻转，即由“1”变为“0”，或由“0”变为“1”
% 优点：遗传算法的变异特性可以使求解过程随机地搜索到解可能存在的整个空间，
% 因此可以在一定程度上求得全局最优解。
% 调用格式：
% newpop=mutation(pop,pm,option)
% newpop=mutation(pop,pm)
% 说明：
% newpop表示交叉后的新种群，pop-初始种群，pm变异概率，
% option表示选择方式：
% 适用于二进制的变异方式：binary--二进制变异，
% 适用于整数编码的交叉方式：convert--倒置变异（旅行商问题）
% 备注：
% 变异率一般可取0.001~0.1
%--------------------------------------------------------------------
function newpop=mutation(pop,pm,option)
if  nargin==3
    switch lower(option)
        case 'binary'        %二进制变异---适用于二进制编码    
            [newpop]=binary(pop,pm);   
        case 'convert'           %倒置变异---适用于整数编码（旅行商问题）
            [newpop]=convert(pop,pm);
        otherwise
            error('Unkonwn distribution type')
    end

elseif  nargin==2 %默认二进制变异法
    	[newpop]=binary(pop,pm);
else
    error('Number of input parameters error');
end

end



%------二进制变异---适用于二进制编码-----------------------------------------
function [newpop]=binary(pop,pm)
[px,py]=size(pop);
newpop=pop;      
for i=1:px
    if(rand<pm)
        mpoint=ceil(rand*py);
        if any(newpop(i,mpoint))==0
           newpop(i,mpoint)=1;
        else
           newpop(i,mpoint)=0;
        end
    end
end

end
%-------------------------------------------------------------------------

%-------倒置变异---适用于整数编码（旅行商问题）------------------------------
function [newpop]=convert(pop,pm)
[px,py]=size(pop);
newpop=pop;
for i=1:px
    if(rand<pm)
        mpoint=sort(randperm(py,2));
        newpop(i,mpoint(1):mpoint(2))=fliplr(pop(i,mpoint(1):mpoint(2)));
    end
end

end

