% numerical computation of the distribution of the charge density along a
% streight wire, using the MoM.

clear

epsilon0=8.8541878e-12;

l=1;    % length
a=1e-3; % wire radius

nl=200;  % number of segments
dl=l/nl;

M=zeros(nl);

y(1:nl)=0;
V(1:nl)=4*pi*epsilon0;

n=1:nl;

y(n)=(n-0.5)*dl;

for(n=1:nl)
    for(m=1:nl)
        if(m==n)
            M(n,n)=2*log(dl/a);
        else
            M(n,m)=dl/abs(y(n)-y(m));
        end
    end
end

rho=M'\V';

plot(y,rho);
