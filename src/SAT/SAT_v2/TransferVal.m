
function T=TransferVal(Tc,e,jk,np);

% T=TransferVal(Tc,e,jk) calculates Transfer matrix 
% using the expansion coefficients given in Tc, which is a
% cell array of size (n+1)x2, n being the order of the expansion.
% T is represented by the expansion
%  
%   T = Tc{1,1} +   sum  ( Tc{m,1}.e...e.e + Tc{m,2}.e...e ) jk^(m-1)
%                m=2..n+1
%
% where Tc{m,2}.e...e denotes the dot products of the tensor Tc{m,2} 
% with m-2 vectors e, where the summation goes over the right-most
% m-2 indices of Tc; similarly, Tc{m,1}.e...e.e denotes the dot products 
% of the tensor Tc{m,1} with m-1 vectors e, where the summation goes 
% over the right-most m-1 indices of Tc. 
% jk is j times the wave number k=w*sqrt(eps*mu), e is the direction 
% into which the wave is transmitted. e may be a matrix of size nd x 3 
% containing nd different directions, then jk may be a column vector of
% length nd representing corresponding jk-values. The result is a 
% transfer array T of size [size(Tc{1,1}),nd], the last dimension of 
% T counting the (frequency,direction) instances. If jk is a row vector
% then all nd x length(jk) combinations of directions and jk-values are
% considered, giving a T of size [size(Tc{1,1}),nd,length(jk)].
%
% T=TransferVal(Tc,e,jk,np) evaluates only the powers of jk given in np, 
% for instance np=0:nmax adds all terms of powers of jk from the constant 
% term up to jk^nmax, np=3 calculates only the jk^3-term.
 
if nargin<3,
  error('Too few input parameters.');
end

if size(e,2)~=3,
  error('Invalid dimension of third input parameter (radiation direction).');
end
nd=size(e,1);
ndt=nd;

if length(jk)==1,
  jk=repmat(jk,nd,1);
elseif (size(jk,2)==1)&(length(jk)~=nd),
  error('Inconsistent dimension of input parameters.');
elseif size(jk,2)~=1,
  e=repmat(e,length(jk),1);
  ndt=nd*length(jk);
  jk=reshape(repmat(jk,nd,1),ndt,1);
end

ke=e.*repmat(jk./Mag(e,2),[1,3]);  % wave vectors

n=size(Tc,1)-1;   % order of expansion

z=ones(n+1,1);    % multiplication factor to remove non-requested terms
if nargin>3,
  z(setdiff(0:n,np)+1)=0;
end

s=size(Tc{1,1});  % transfer matrix size for single direction 

T=zeros([ndt,s]);  % array of transfer matrices for ndt 
                   % (direction,frequency) instances
for d=1:ndt,
  ked=ke(d,:).';
  jkd=jk(d);
  Td=Tc{end,1}(:)*z(end);
  pd=length(Td);
  for m=n+1:-1:2,
    pd=pd/3;
    Td = reshape(Td,[pd,3])*ked + jkd*Tc{m,2}(:)*z(m) + Tc{m-1,1}(:)*z(m-1);
  end
  T(d,:)=Td.';
end

T=reshape(shiftdim(T,1),[s,nd,ndt/nd]);

