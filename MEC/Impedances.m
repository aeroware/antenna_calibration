function Z=Impedances(ant, f_low, f_high, n)

%   function Z=Impedances(ant,f_low, f_high, n)
%   computes the impedances of n frequencies between f_low and f_high

Z=zeros(n,1);
f=linspace(f_low,f_high,n);

for q=1:n;
    fprintf('\n\nComputing current %i of %i\n',q,n)
    [cs,Z(q)]=mc_GetCurrent(ant, f(q),1);
end %for i

plot(Z);
