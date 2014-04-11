
function y=sinq(x)

% y=sinq(x) returns
%   y(i) = sin(x(i))/x(i)  if x(i) ~= 0
%        = 1               if x(i) == 0
% where x(i) is an element of the input matrix and 
% y(i) is the resultant output element.  


y=ones(size(x));
i=find(x);
y(i)=sin(x(i))./x(i);

