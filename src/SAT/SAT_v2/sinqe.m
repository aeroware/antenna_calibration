function y=sinqe(x)

% y=sinqe(x) returns 
% y = (sin(x)/x-exp(ix))/x = sinqc(x)/x-i*sinq(x)


y=-i*ones(size(x));
n=find(x);
y(n)=Sinqc(x(n))./x(n)-i*Sinq(x(n));

