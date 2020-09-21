% 遗传算法子程序:选择selection.m
% 
% 调用格式：
% [newpop]=selection(pop,fitvalue,option,q)
% [newpop]=selection(pop,fitvalue,option)
% 说明：
% newpop表示选择的新种群，pop-初始种群，fitvalue-由pop所计算出的适应度值，
% option表示选择方式：roulette-轮盘赌选择，sortslection-排序选择，
% competition-锦标赛选择. 可省略，默认为轮盘赌选择
% q-排序选择时,表示最好的个体选择的概率;
% q-竞争选择时，表示参与竞争的个体数(可以设置为2)
% 备注：
% 
%--------------------------------------------------------------------
function newpop=selection(pop,fitvalue,option,q)
if  nargin>=3
    switch lower(option)
        case 'roulette'        %roulette轮盘赌选择    
            newpop=Rselection(pop,fitvalue);   
        case 'sortslection'    %sort排序选择
            newpop=Sortselection(pop,fitvalue,q);%q为最好的个体选择的概率
        case 'competition'     %锦标赛选择
            newpop=Cselection(pop,fitvalue,q); %q为参与竞争的个体数
        otherwise
            error('Unkonwn distribution type')
    end

elseif  nargin==2 %默认轮盘赌选择
    [newpop]=Rselection(pop,fitvalue);
else
    error('Number of input parameters error');
end

end
        

%--------轮盘赌选择-----------------------------------------------------
function [newpop]=Rselection(pop,fitvalue)
    totalfit=sum(fitvalue);     %求适应值之和
    fitvalue=fitvalue/totalfit; %单个个体被选择的概率
    fitvalue=cumsum(fitvalue);  %计算累计概率. cumsum计算累加和，
    [px,py]=size(pop);          %如x=[1 2 3 4]，则 cumsum(x)=[1 3 6 10] 
    ms=sort(rand(px,1)); %从小到大排列  产生px个0-1均匀分布的随机数
    fitin=1;
    newin=1;
    newpop=ones(px,py);
    while newin<=px 
          if(ms(newin))<fitvalue(fitin)
              newpop(newin,:)=pop(fitin,:);
              newin=newin+1;
          else
              fitin=fitin+1;
          end
    end
end
%-------------------------------------------------------------------------

%-------排序选择----------------------------------------------------------
function [newpop]=Sortselection(pop,fitvalue,q) 
    [px,py]=size(pop);
    [~,Sindex]=sort(fitvalue,'descend');%将适应度值降序，返回其在种群中的索引 
    pop=pop(Sindex,:);%将个体根据适应度从大到小排序      
    P=q*(1-q).^((1:px)-1)/(1-(1-q)^px);%根据公式计算第i个个体选择的概率
    PP=cumsum(P); %计算累计概率
    newpop=ones(px,py);
    for i=1:px
        r=rand;         %和轮盘赌一样，生成px个随机数，
        for j=1:px      %每个随机数依次和累计概率比较，选中第一个大于r的值             
            if r<=PP(j) %前面采用while循环 这里使用两层for循环
               newpop(i,:)=pop(j,:);
               break;
            end
        end 
    end
end
%-------------------------------------------------------------------------

%-------锦标赛选择----------------------------------------------------------
function [newpop]=Cselection(pop,fitvalue,sn)
    [px,py]=size(pop);
    newpop=ones(px,py);
    for i=1:px
        r=randi([1 px],sn,1);          %生成[1,px]内Sn行一列的随机整数向量，
        [~,bestindex]=max(fitvalue(r));%即任意选择Sn个个体参与竞争 
        newpop(i,:)=pop(r(bestindex),:);%再Sn个个体中选择最优适应值个体保留
    end
end








%轮盘赌选择方法误差比较大，有时连适应度较高的个体也选择不上