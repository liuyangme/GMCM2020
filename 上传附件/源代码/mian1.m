clc;clear;
load Xmean;
load Xstd;
load c;
c8=c(8);
c13_343=c(13:end)';
c1_7_8_12=c([1:7,8:12])';
load delta 
% delta=(delta-X_mean(13:end)')./X_std(13:end)';

load Xmin                                         %上限，行向量，修改
load Xmax    %下限，行向量，修改
% Xmin=(Xmin-X_mean(13:end)')./X_std(13:end)';
% Xmax=(Xmax-X_mean(13:end)')./X_std(13:end)';

xij=xlsread('数据.xlsx','Sheet2','B2:LT2')';      %样本不同改这里
% xij=(xij-X_mean(13:end)')./X_std(13:end)';
xp=xlsread('数据.xlsx','Sheet3','B3:M3')';       %样本不同改这里

m=zeros(343,1);
m([5 6 23 33 80 86 118 125 141 145 168 182 235 247 336])=[-0.0744286 0.0178557 -0.0082684 -4.63709 0.0462119 -0.0192759 -0.059552 1.22517 -0.0079627 -0.0120777 -0.0515196 0.0045955 -0.0611329 0.0303882 -9.05489e-5];
m0=39.0248;


L1=(Xmin-xij)./delta;
L2=(Xmax-xij)./delta;
Nmax=L2;
Nmin=L1;
Nmax=ceil(Nmax);
Nmin=floor(Nmin);
postion=find(L1>L2);
Nmax(postion)=L1(postion);
Nmin(postion)=L2(postion);



global Cmin;
varnum=331;%变量个数
eps=1e-1;
popsize=20; %群体大小，修改
Gene=50;     %迭代次数
pc=0.95; %交叉概率
pm=0.05; %变异概率



%计算每个变量编码所需要的的长度
for i=1:varnum
    L(i)=ceil(log2((Nmax(58)-Nmin(58))/eps));
end
L=real(L);
chromlength=sum(L);%每个个体所需总位长


count=0;
spoint=cumsum([0 L]);
pop=round(rand(popsize,chromlength));
while 1
      tempn=round(rand(1,chromlength)); %随机产生初始群体 %rand随机产生0-1内的均匀分布的随机数矩阵，popsize行，chromlength列
      n=decodechrom(spoint,varnum,tempn,Nmax,Nmin);%真实的十进制值
      n=round(n);
      ndelat=(n'.*delta);
      S=m0+m(5)*xp(5)+m(6)*xp(6)+sum(m(13:end).*(xij+ndelat));
      if S<=5&&S>=3
         count=count+1;
         pop(count,:)=tempn;
      end
       if count>=popsize
          break;
      end
      
end





for i=1:Gene %Gene为迭代次数
    
    %将二进制转化为十进制
    real10=decodechrom(spoint,varnum,pop,Xmax,Xmin);%真实的十进制值
    real10=round(real10);
    [objvalue]=calobjvalue(real10,c13_343,m,c8,delta); %计算目标函数
    fitvalue=calfitvalue(objvalue); %计算群体中每个个体的适应度
    [newpop]=selection(pop,fitvalue,'roulette'); %选择
    [newpop]=crossover(newpop,pc,'singlepoint'); %交叉
    
    count=0;
    for j=1:2*popsize
        tempn=newpop(j,:);
        n=decodechrom(spoint,varnum,tempn,Xmax,Xmin);%真实的十进制值
        n=round(n);
        ndelat=(n'.*delta);
        S=m0+m(5)*xp(5)+m(6)*xp(6)+sum(m(13:end).*(xij+ndelat));
        if S<=5&&S>=2
            count=count+1;
            newpop(count,:)=tempn;
        end
        if count>popsize
            newpop=newpop(1:20,:);
        else
            newpop=[newpop(1:count,:),count(1:popsize-count,:)];
        end
        [newpop]=mutation(newpop,pm,'binary'); %变异
    end
    
    
    [bestindividual,bestfit]=best(pop,fitvalue); %求出群体中适应值最大的个体及其适应值
    bestindividual10(i,:)=decodechrom(spoint,varnum,bestindividual,Xmax,Xmin); %最佳个体解码
    y(i)=bestfit+Cmin; %最佳个体适应度
    y_mean(i)=mean(fitvalue+Cmin); %第i代平均适应度
    plot(i,y(i),'r.');
    hold on
    plot(i,y_mean(i),'b.');
    pop=newpop;  



end

bestn=bestindividual10(50,:);
bestx=xij+bestn'.*delta





















% function fitvalue=calfitvalue1(objvalue)
% global Cmin;
% Cmin=0;
% [px,py]=size(objvalue);
% for i=1:px
%     if objvalue(i)+Cmin>0
%         temp=Cmin+objvalue(i);
%     else
%         temp=0.0;
%     end
%     fitvalue(i)=temp;
% end
% fitvalue=fitvalue';




