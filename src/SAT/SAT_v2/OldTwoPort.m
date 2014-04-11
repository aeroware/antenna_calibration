
function [A,Z,Y]=TwoPort(Zc,Zb,ChainDim,Method);

% [A,Z,Y]=TwoPort(Zc,Zb) adds impedances Zb and Zc representing
% the following 2-port:
%
%        I'                                                I" 
%    o--->---+----Zb(1)----+----Zb(2)---- ... +----Zb(k)---<---o
%            |             |                  | 
%   V'     Zc(1)         Zc(2)              Zc(k)              V"
%            |             |                  |
%    o--->---+-------------+------------- ... +----------------o
%
% to get the 2-port admittance, impedance and chain matrices Y, Z and A,
% respectively, which determine the relation between the currents and 
% voltages at the 2 ports,
%   
%   [V';V"] = Z * [I';I"]
%   [I';I"] = Y * [V';V"]
%   [V';I'] = A * [V";I"]
%
% Zb and Zc must be of same size, but may have several dimensions.
% The first non-singleton dimension is used to count the network-chain 
% as illustrated above. The other dimensions are treated in 
% parallel. Zc may contain inf-values, Zb may contain zeros.
%
% Zall=AddImped(Zc,Zb,ChainDim) works along the dimension ChainDim 
% instead of the first non-singleton (default) dimension,
% giving output arrays of size [s(1:ChainDim-1),s(ChainDim+1:end)],
% with s=size(Zb)=size(Zc).

if ~isequal(size(Zb),size(Zc)),
  error('Impedance arrays Zb and Zc must be of same size.');
end

if (nargin<3)|isempty(ChainDim),
  ChainDim=find(size(Zb)>1);
  if isempty(ChainDim),
    ChainDim=1;
  else
    ChainDim=ChainDim(1);
  end
end
if ChainDim~=1,
  Zb=permute(Zb,[ChainDim,1:ChainDim-1,ChainDim+1:ndims(Zb)]);
  Zc=permute(Zc,[ChainDim,1:ChainDim-1,ChainDim+1:ndims(Zc)]);
end

if (nargin<4)|~isequal(Method,2),
  Method=1;
end

s=[size(Zb),1,1];
k=s(1);
s=s(2:end);

if Method==1,
  
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
  
else % Method==2; uses less memory but is not so stable for bad matrix-cond
  
  A=reshape([ones([1,prod(s)]);1./Zc(1,:);Zb(1,:);1+Zb(1,:)./Zc(1,:)],[2,2,s]);
  
  for n=2:k,
    for m=1:prod(s),
      A(:,:,m)=A(:,:,m)*[1,Zb(n,m); 1./Zc(n,m),1+Zb(n,m)./Zc(n,m)];
    end
  end
  
  A(:,2,:)=-A(:,2,:);  % account for current direction convention
  
  if nargout>1,
    Z=[A(1,1,:),A(1,2,:).*A(2,1,:)-A(1,1,:).*A(2,2,:);...
        ones(size(A(1,1,:))),-A(2,2,:)]./repmat(A(2,1,:),2,2);
    Z=reshape(Z,size(A));
  end
  
  if nargout>2,
    Y=[A(2,2,:),A(1,2,:).*A(2,1,:)-A(1,1,:).*A(2,2,:);...
        ones(size(A(1,1,:))),-A(1,1,:)]./repmat(A(1,2,:),2,2);
    Y=reshape(Y,size(A));
  end
  
end

