% 遗传算法子程序:交叉crossover.m
% 
% 调用格式：
% newpop=crossover(pop,pc,option)
% newpop=crossover(pop,pc)
% 说明：
% newpop表示交叉后的新种群，pop-初始种群，pc交叉概率，
% option表示选择方式：
% 适用于二进制的交叉方式：singlepoint--单点交叉，
% 适用于整数编码的交叉方式：order--顺序交叉OX
% 
% 备注：
% 
%--------------------------------------------------------------------
function newpop=crossover(pop,pc,option)
if  nargin==3
    switch lower(option)
        case 'singlepoint'        %单点交叉---适用于二进制编码    
            [newpop]=singlepoint(pop,pc);   
        case 'order'           %顺序交叉Order Crosser---适用于整数编码
            [newpop]=order(pop,pc);
        case 'mapped'
            [newpop]= mapped(pop,pc);
        otherwise
            error('Unkonwn distribution type')
    end

elseif  nargin==2 %默认单点交叉
    	[newpop]=singlepoint(pop,pc);
else
    error('Number of input parameters error');
end

end






%------单点交叉---适用于二进制编码-----------------------------------------
function [newpop]=singlepoint(pop,pc)
[px,py]=size(pop);
      %用pop对newpop初始化,执行交叉的个体会被替换,若没有执行交叉操作的个体,则可以直接保留
newpop=pop;
for i=1:2:px-1     %种群数为双数：个体1和个体2进行交叉，个体3和个体4进行交叉...
    if(rand<pc)    %种群数为单数：最后一个个体不执行交叉.
        cpoint=ceil(rand*py); %ceil向上取整.生成一个[1,py]内的随机整数作为交叉位置
      
       
        newpop(i,:)=[pop(i,1:cpoint),pop(i+1,cpoint+1:py)];
        newpop(i+1,:)=[pop(i+1,1:cpoint),pop(i,cpoint+1:py)];
        
    end            %如果生成的随机数<交叉概率，则进行交叉，否则不进行交叉
end                %由于初始化newpop时用pop对newpop初始化，故不需要写
                   %else 
                   %    newpop(i,:)=pop(i,：);newpop(i+1,:)=pop(i+1,：);

end    
%-------------------------------------------------------------------------

%-------顺序交叉Order Crosser---适用于整数编码------------------------------        
function [newpop]=order(pop,pc)
[px,py]=size(pop);
newpop=pop;
for i=1:2:px-1 
    if(rand<pc)     %如果生成的随机数<交叉概率，则进行交叉，否则不进行交叉
       cpoint=sort(randperm(py,2)); %找到两个随机位置，并从大到小排序
       rlength=length(cpoint(1):cpoint(2)); %两个位置中间部分为保留部分,计算其长度,在第二个循环外计算,避免重复计算带来的计算量
       if  cpoint(1)~=cpoint(2)
           a=[];
           b=[];
           for j=1:py     %这里两层for循环是为了在父代2（或父代1）中找出与
               count1=0;  %父代1（或父代2）保留部分不相同的基因编号，并按顺序
               count2=0;  %保存在变量a(或b)中.
               for k=cpoint(1):cpoint(2)
                   if newpop(i+1,j)~=newpop(i,k)
                      count1=count1+1;
                   end
                   if newpop(i,j)~=newpop(i+1,k)
                      count2=count2+1;
                   end
               end
               if count1==rlength
                  a=[a,newpop(i+1,j)]; 
               end
               if count2==rlength
                  b=[b,newpop(i,j)];
               end  
           end
           newpop(i,1:cpoint(1)-1)=a(1:cpoint(1)-1);
           newpop(i,cpoint(2)+1:py)=a(cpoint(1):end);
           newpop(i+1,1:cpoint(1)-1)=b(1:cpoint(1)-1);
           newpop(i+1,cpoint(2)+1:py)=b(cpoint(1):end);
       end
    end  
end




end          
           
    
%-------------------------------------------------------------------------

%-------Mapped Crossover (PMX)---适用于整数编码------------------------------         
function children = mapped(parents,~)
% CROSSOVER
% children = CROSSOVER(parents) Replicate the mating process by crossing 
% over randomly selected parents. 
%
% Mapped Crossover (PMX) example:     
%           _                          _                          _
%    [1 2 3|4 5 6 7|8 9]  |-> [4 2 3|1 5 6 7|8 9]  |-> [4 2 3|1 8 6 7|5 9]
%    [3 5 4|1 8 7 6|9 2]  |   [3 5 1|4 8 7 6|9 2]  |   [3 8 1|4 5 7 6|9 2]
%           |             |            |           |              |            
%           V             |            V           |              |  
%    [* 2 3|1 5 6 7|8 9] _|   [4 2 3|1 8 6 7|* 9] _|              V
%    [3 5 *|4 8 7 6|9 2]      [3 * 1|4 5 7 6|9 2]           ... ... ...
%

[popSize, numberofcities] = size(parents);    
children = parents; % childrens

for i = 1:2:popSize % pairs counting
    parent1 = parents(i+0,:);  child1 = parent1;
    parent2 = parents(i+1,:);  child2 = parent2;
    % chose two random points of cross-section
    InsertPoints = sort(ceil(numberofcities*rand(1,2)));
    for j = InsertPoints(1):InsertPoints(2)
        if parent1(j)~=parent2(j)
            child1(child1==parent2(j)) = child1(j);
            child1(j) = parent2(j);
            
            child2(child2==parent1(j)) = child2(j);
            child2(j) = parent1(j);
        end
    end
    % two childrens:
    children(i+0,:)=child1;     children(i+1,:)=child2;
end

       
       
       
       
      

end
       
       
       
       
       
       
       
       
       
       
       
       