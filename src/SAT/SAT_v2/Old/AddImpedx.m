
function [Z,Y,A]=AddImpedx(Zc,Zb,AddDim);

% [Zall,Q,Z,Y]=AddImped(Zc,Zb,AddDim) adds impedances Zb and Zc representing
% the following circuit:
%                                                  I 
%    +----Zb(1)----+----Zb(2)---- ... +----Zb(k)---<---o
%    |             |                  | 
%  Zc(1)         Zc(2)              Zc(k)              V
%    |             |                  |
%    +-------------+------------- ... +----------------o
%
% to get the total impedance Zall which relates V to I:
%   
%   V = Zall * I
%
% Zb and Zc must be of same size, but may have several dimensions.
% The dimensions from the 2nd non-singleton upwards are treated in 
% parallel giving an array Zall of size  s(2:end), s=size(Zb)=size(Za).
%
% Zall=AddImped(Zc,Zb,AddDim) works along the dimension AddDim 
% instead of the first non-singleton (default) dimension.

if ~isequal(size(Zb),size(Zc)),
  error('Impedance arrays Zb and Zc must be of same size.');
end

if isempty(Zb),
  Zall=[];
  return
end

if (nargin<3)|isempty(AddDim),
  AddDim=find(size(Zb)>1);
  if isempty(AddDim),
    AddDim=1;
  else
    AddDim=AddDim(1);
  end
end
if AddDim~=1,
  Zb=permute(Zb,[AddDim,1:AddDim-1,AddDim+1:ndims(Zb)]);
  Zc=permute(Zc,[AddDim,1:AddDim-1,AddDim+1:ndims(Zc)]);
end

s=[size(Zb),1,1];
k=s(1);
s=s(2:end);

B=zeros([2*k,2*k+2,s]);

for q=1:k,
  B(q,q,:)=-1;
  B(q,q+1,:)=1;
  B(q,k+2+q,:)=shiftdim(Zb(q,:),-1);
  B(k+q,q,:)=shiftdim(1./Zc(q,:),-1);
  B(k+q,k+1+q,:)=-1;
  B(k+q,k+1+q+1,:)=1;
end

if k>1,
  A=zeros([2,4,s]);
  for m=1:prod(s),
    [qq,r]=qr(B(:,[2:k,k+3:2*k+1],m));
    A(:,:,m)=qq(:,2*k-1:2*k)'*B(:,[1,k+1,k+2,2*k+2],m);
  end
  B=A;
end

B(:,4,:)=-B(:,4,:);  % account for current direction convention

Y=zeros([2,2,s]);
Z=zeros([2,2,s]);
A=zeros([2,2,s]);
for m=1:prod(s),
  Y(:,:,m)=-B(:,3:4,m)\B(:,1:2,m);
  Z(:,:,m)=-B(:,1:2,m)\B(:,3:4,m);
  A(:,:,m)=-B(:,[1,3],m)\B(:,[2,4],m);
end

