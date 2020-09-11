%Michael Nguyen, NYU School of Medicine

%adapted from:
%https://www.mathworks.com/matlabcentral/answers/
%96572-how-can-i-perform-a-chi-square-test-to-determine-how-
%statistically-different-two-proportions-are-in

function chiSquare22(a,b,c,d)
x1 = [repmat('a',b,1); repmat('b',d,1)];
x2 = [repmat(1,a,1); repmat(2,b-a,1); repmat(1,c,1); repmat(2,d-c,1)];
[tbl,chi2stat,pval] = crosstab(x1,x2)
end 
