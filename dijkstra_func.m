function [mydistance,path]=dijkstra_func(a,sb,db)
%输入：a--邻接矩阵a(ij)是指i到j之间的距离，可以是有向的
%sb--起点的符号  db--终点的符号
%输出：distance--最短路的距离  path--最短路的路径

    n=size(a,1);
    visited(1:n)=0;
    distance(1:n)=inf;  %保存起点到各顶点之间的距离
    distance(sb)=0;
    parent(1:n)=0;

    for i=1:n-1
        temp=distance;
        id1=find(visited==1);  %查找已经标号的点

        temp(id1)=inf;  %已标号的点距离换成无穷
        [t,u]=min(temp);  %找标号值最小的点
        visited(u)=1;  %标记已经标号的顶点
        id2=find(visited==0);  %查找未标号的顶点

        for v=id2
            if a(u,v)+distance(u)<distance(v)
                distance(v)=a(u,v)+distance(u);  %修改标号值
                parent(v)=u;
            end
        end
    end

    path=[];

    if parent(db) ~= 0  %如果存在路
        t=db;
        path=[db];
        while t ~= sb
            p = parent(t);
            path=[p path];
            t=p;
        end
    end

    mydistance=distance(db);
    return 