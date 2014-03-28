
function [Zall,Q,Z,Y]=AddImped(Zc,Zb,AddDim);

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

Zall=reshape(Zb(1,:)+Zc(1,:),s(2:end));

if nargout>1,
  Q=reshape([ones([1,prod(s(2:end))]);1./Zc(1,:);Zb(1,:);1+Zb(1,:)./Zc(1,:)],...
    [2,2,s(2:end)]);
end

for k=2:s(1),
  
  for m=1:prod(s(2:end)),
    
    if (Zc(k,m)==0)|(Zall(m)==0),
      Zall(m)=0;
    elseif isinf(Zall(m)),
      Zall(m)=Zc(k,m);
    else
      Zall(m)=1/(1/Zall(m)+1/Zc(k,m));
    end
    if ~isinf(Zall(m)),
      Zall(m)=Zall(m)+Zb(k,m);
    end

    if nargout>1,
      Q(:,:,m)=Q(:,:,m)*[1,Zb(k,m);1./Zc(k,m),1+Zb(k,m)./Zc(k,m)];
    end

  end
  
end

if nargout>1,
  Q(:,2,:)=-Q(:,2,:);  % account for current direction convention
end

if nargout>2,
  Z=[Q(1,1,:),Q(1,2,:).*Q(2,1,:)-Q(1,1,:).*Q(2,2,:);...
      ones(size(Q(1,1,:))),-Q(2,2,:)]./repmat(Q(2,1,:),2,2);
  Z=reshape(Z,size(Q));
end

if nargout>3,
  Y=[Q(2,2,:),Q(1,2,:).*Q(2,1,:)-Q(1,1,:).*Q(2,2,:);...
      ones(size(Q(1,1,:))),-Q(1,1,:)]./repmat(Q(1,2,:),2,2);
  Y=reshape(Y,size(Q));
end

