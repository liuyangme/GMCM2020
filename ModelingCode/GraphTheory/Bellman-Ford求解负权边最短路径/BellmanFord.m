function [flag,dis]=Bellmanford(G,s)
% 输出：是否存在可行解
    %G—图的邻接矩阵表示，元素值为权重
    %s—图的源点
    dis = ones(1,size(G,1))*inf;
    %初始化
    dis = init(G,s,dis);
    %执行松弛操作
    for l=1:size(G,1)-1
        for j=1:size(G,1)
            for k=1:size(G,1)
                dis = relax(G,j,k,dis);
            end
        end
    end
    %判断是否存在权重为负值的环路
    for m=1:size(G,1)
        for n=1:size(G,1)
            %是否存在估计错误的情况，若存在，则代表存在权重为负值的环
            if dis(n)>dis(m) + G(m,n)
                flag = 0;
                return;
            end
        end
    end
    flag = 1;
end

%dis：最短路径估计值数组
%G：图的邻接表表示法，元素代表行数i到列数j之间边的权重
function [dis] = init(G,s,dis)
    for i=1:size(G,1)
        dis(i) = inf;
    end
    dis(s) = 0;%源点的距离为0
end

%dis：最短路径估计值数组
%G：图的邻接表表示法，元素代表行数i到列数j之间边的权重
function [dis] = relax(G,u,v,dis)
    %dis(v):表示G中从源点到点v的距离估计值，若估计值大于前驱节点的距离+u和v的距离，则更新
	if dis(v)>dis(u)+G(u,v)
        dis(v) = dis(u)+G(u,v);
 	end
end