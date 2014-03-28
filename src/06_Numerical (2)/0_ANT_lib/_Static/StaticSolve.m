
function [PhysGrid,K]=StaticSolve(PhysGrid,K)

% PhysGrid=StaticSolve(PhysGrid) solves for the capacitance matrix
% of a many body problem. The parameters PhysGrid.Desc_.Body and 
% PhysGrid.Desc2d_.Body define to which Body the respective 
% segments and patches belong.
% Returned parameters are:
%   PhysGrid.Static.Ct:
%       grand capacitance matrix for the total system
%   PhysGrid.Static.Qt:
%       charge system: Qt(n,m)=charge on element m when the n-th body is
%       set to unit voltage and the others are short-circuited
%   PhysGrid.Static.CA:
%       antenna capacitance matrix for the case that the body 
%       PhysGrid.Static.GroundBody serves as ground
%   PhysGrid.Static.To:
%       open ports antenna transfer matrix for the antenna system
%       obtained when each body (except ground) is regarded as antenna 
%       element driven versus the ground body PhysGrid.Static.GroundBody.
%
% If PhysGrid.Static.GroundBody is not defined, CA and To are not calculated.
% It is assumed that all physical elements (segments and patches)
% belong to a body. Elements are segments and patches, where the segments
% are counted first, e.g. Qt(n,m) refers to the charge on the m-th element
% which is a segment if m is less than the number of elements but a patch
% otherwise. Accordingly Qt has size NBodies x (Nsegs+Npats), where NBodies,
% Nsegs and Npats are the number of bodies, segments and patches, 
% respectively.  
%
% PhysGrid=StaticSolve(PhysGrid,K)
% assumed that the kernel K has already been determined and used the
% passed argument K without calculating it anew. This enables one, e.g.
% to calculate results for various arrangements of elements (segments and
% patches) into bodies, as long as the composing elements stay the same.
%
% [PhysGrid,K]=StaticSolve(...) also returns the kernel K.

Nsegs=size(PhysGrid.Desc,1);
Npats=numel(PhysGrid.Desc2d);
BodyNumbers=union(PhysGrid.Desc_.Body,PhysGrid.Desc2d_.Body);
NBodies=max(BodyNumbers);
if ~isequal(1:NBodies,BodyNumbers(:).'),
  error('Bodies do not have correct consecutive numbers');
end

if ~exist('K','var')||isempty(K),
  K=StaticKernel(PhysGrid);
end

Nelems=size(K,1);

PhysGrid.Static.Qt=zeros(NBodies,Nelems);
PhysGrid.Static.Ct=zeros(NBodies,NBodies);

V=zeros(Nelems,1);

BodyElems=cell(NBodies,1);

for n=1:NBodies,
  BodyElems{n}=union(find(PhysGrid.Desc_.Body==n),...
    Nsegs+find(PhysGrid.Desc2d_.Body==n));
  V(:)=0;
  V(BodyElems{n})=1;
  PhysGrid.Static.Qt(n,:)=PhysGrid.Exterior.epsr*(K\V).';
end

for n=1:NBodies,
  for m=1:NBodies,
    PhysGrid.Static.Ct(m,n)=sum(PhysGrid.Static.Qt(n,BodyElems{m}));
  end
end

%--------------------------------------------------------------
% calculate antenna capacitance and tranfer matrix (CA and To), 
% taking one body as common ground (PhysGrid.Static.GroundBody):

try
  Ground=PhysGrid.Static.GroundBody;        % ground body
catch
  Ground=[];
end
if isempty(Ground)||~isnumeric(Ground),
  PhysGrid.Static.GroundBody=[];
  return
end
if (Ground>NBodies)||(Ground<1),
  error('Defined ground body does not exist (number=%d).',Ground);
end

As=setdiff(1:NBodies,Ground);      % antenna bodies

PhysGrid.Static.CA=PhysGrid.Static.Ct(As,As)-...
  sum(PhysGrid.Static.Ct(As,:),2)*sum(PhysGrid.Static.Ct(:,As),1)/...
  sum(PhysGrid.Static.Ct(:));

% calculate quasistatic transfer matrices:

% for that purpose first determine charges Qo on elements in case 
% one antenna is charged with Q=1 against Ground:

Q=eye(NBodies);
Q(:,Ground)=-1;
Q=Q([1:Ground-1,Ground+1:end],:);

V=Q/PhysGrid.Static.Ct.';

Qo=V*PhysGrid.Static.Qt;  

% center of segments and patches:

rm=zeros(Nelems,3);
rm(1:Nsegs,:)=...
  (PhysGrid.Geom(PhysGrid.Desc(:,1),:)+PhysGrid.Geom(PhysGrid.Desc(:,2),:))/2;
for p=1:Npats,
  d=PhysGrid.Desc2d{p};
  if numel(d)==4,
    g=PhysGrid.Geom(d(:),:);
    F=[Mag(cross(g(2,:)-g(1,:),g(3,:)-g(1,:),2),2),...
       Mag(cross(g(3,:)-g(1,:),g(4,:)-g(1,:),2),2)];
    F=F/sum(F);
    rm(Nsegs+p,:)=F(1)*mean(PhysGrid.Geom(d(1:3),:),1)+...
                  F(2)*mean(PhysGrid.Geom(d([3,4,1]),:),1);
  else
    rm(Nsegs+p,:)=mean(PhysGrid.Geom(d,:),1);
  end
end

% Open port transfer matrix:

PhysGrid.Static.To=Qo*rm;


