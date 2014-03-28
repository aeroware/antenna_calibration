
function y=Bound(x,x1,x2);

% y=Bound(x,x1,x2) sets y=x if x is in the interval 
% [x1,x2], otherwise sets y to the closer interval bound.

[x1,x2]=deal(min(x1,x2),max(x1,x2));

y=max(min(x,x2),x1);

