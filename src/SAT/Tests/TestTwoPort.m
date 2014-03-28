
% TestTwoPort.m

switch 2,
  
case 1,

Z1=100
Z2=70
Zc=10+6*i

[Q,Z]=TwoPort(Z1,Zc,Z2,2)
[QQ,ZZ]=TwoPort(Z1,Zc,Z2);

d=Q./QQ-1;
ld=log10(max(eps,abs(d(:))));
mean(ld)
std(ld)
max(abs(d(:)))

d=Z./ZZ-1;
ld=log10(max(eps,abs(d(:))));
mean(ld)
std(ld)
max(abs(d(:)))

case 2,
  
s=[5,3,15,60];

Z1=rand(s)+i*rand(s);
Zc=rand(s)+i*rand(s);
Z2=rand(s)+i*rand(s);

ChainDim=3;

[Q,Z]=TwoPort(Z1,Zc,Z2,ChainDim);
size(Q)

d=Z./LinRel(Q,1,1)-1;
ld=log10(max(eps,abs(d(:))));
mean(ld)
std(ld)
max(abs(d(:)))

hist(ld)

% [QQ,ZZ]=TwoPort(Z1,Zc,Z2);
% 
% d=Q./QQ-1;
% ld=log10(max(eps,abs(d(:))));
% mean(ld)
% std(ld)
% max(abs(d(:)))
% 
% d=Z./ZZ-1;
% ld=log10(max(eps,abs(d(:))));
% mean(ld)
% std(ld)
% max(abs(d(:)))

Zb=permute(Z1,[ChainDim,1:ChainDim-1,ChainDim+1:ndims(Z1)]);
Zb(1:end-1,:)=Zb(2:end,:);
Zb(end,:)=0;
Zb=permute(Zb,[2:ChainDim,1,ChainDim+1:ndims(Zb)]);
Zb=Zb+Z2;

Zadd=AddImped(Zc,Zb,ChainDim);

d=shiftdim(Z(2,2,:),2)./Zadd(:)-1;
ld=log10(max(eps,abs(d(:))));
mean(ld)
std(ld)
max(abs(d(:)))

end