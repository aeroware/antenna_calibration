
function [Desc2d,NewPats,SubDiv]=SubdivPatches(Geom,Desc2d0,c,SymAxis)

% Desc2d=SubdivPatches(Geom,Desc2d0,c)
% subdivides patches whith more than c corners into 
% patches of max c corners. 
%
% Desc2d=SubdivPatches(Geom,Desc2d0,c,SymAxis)
% tries to respect/preserve symmetry with regards to axis SymAxis. 
% The variable SymAxis is a cell array of two vectors, the 
% first giving a point on the axis, the second 
% defining its direction.
%
% [Desc2d,NewPats,SubDiv]=SubdivPatches(...)
% SubDiv gives the number of subdivisions into which the
% patches are split, and NewPats returns a vector of indices 
% defining the first of the new patch numbers.
% E.g. NewPats(5)=10, SubDiv(5)=4 means that 
% patch 5 (namely Ant0.Desc2d{5}) has been split 
% into 4 patches which have now the numbers 10,11,12,13
% (namely Ant.Desc2d{10:13}). 
%
% Ant=SubdivPatches(Ant0,Pats,c) and
% Ant=SubdivPatches(Ant0,Pats,c,SymAxis) 
% do the same, using the Geom and Desc2d fields of the Ant0 
% and Ant structure. Only the patches given in Pats are split. 
% The new patch subdivisions are added to the Objects 
% containing the respective original patches.

% Written June 2007.

if nargin<4,
  SymAxis={};
end

if (nargin<3)||isempty(c),
  c=3;
end
c=max(3,round(c));


% Ant=SubdivPatches(Ant0,Pats,...)
% ------------------------------------

if isstruct(Geom),
  
  Pats=Desc2d0;
  if ischar(Pats),
    Pats=1:length(Geom.Desc2d);
  end
  Pats=unique(Pats);
  N0=length(Geom.Desc2d);
  NewPats=(1:N0).';
  SubDiv=ones(N0,1);
  Desc2d=Geom;
  
  if isempty(Pats),
    return
  end
  
  [d,np,sd]=SubdivPatches(Geom.Geom,Geom.Desc2d(Pats(:)),c,SymAxis);
  shp=[0;cumsum(sd-1)];  % shift in patch-numbering
  NewPats=zeros(length(Geom.Desc2d),1);
  SubDiv=NewPats;
  Desc2d.Desc2d=cell(N0+shp(end),1);
  q=0;  
  k=0;
  for p=1:length(Pats),
    NewPats(k+1:Pats(p))=(q+1:q+Pats(p)-k).';
    SubDiv(k+1:Pats(p)-1)=1;
    SubDiv(Pats(p))=sd(p);
    Desc2d.Desc2d(NewPats(k+1:Pats(p)-1))=Geom.Desc2d(k+1:Pats(p)-1);
    Desc2d.Desc2d(NewPats(Pats(p))+(0:sd(p)-1))=...
      d(p+shp(p)+(0:sd(p)-1));
    k=Pats(p);
    q=k+shp(p)+sd(p)-1;    
  end
  NewPats(k+1:end)=(q+1:length(Desc2d.Desc2d)).';
  Desc2d.Desc2d(NewPats(k+1:end))=Geom.Desc2d(k+1:end);
  SubDiv(k+1:end)=1;

  % update objects:
  
  [Points,Wires,Surfs]=GridFindObj(Desc2d);
  for s=1:length(Surfs),
    eo=Desc2d.Obj(s);
    en=[];
    for e=eo(:).';
      en=[en,NewPats(e)+(0:SubDiv(e)-1)];
    end
    Desc2d.Obj(s)=en;
  end
  
  return
  
end
  

% Desc2d=SubdivPatches(Geom,Desc2d0,..)
% -----------------------------------------

Desc2d=Desc2d0;
NewPats=zeros(size(Desc2d0,1),1);
SubDiv=NewPats;

Sym=~isempty(SymAxis);
if Sym,
  ez=SymAxis{2}(:)'./Mag(SymAxis{2});
  g=Geom-repmat(SymAxis{1}(:).',size(Geom,1),1);
  z=g*ez';
  g=g-z*ez;
  rho=Mag(g,2);
  [m,n]=max(rho);
  ex=g(n,:)/Mag(g(n,:));
  ey=cross(ez,ex,2);
  phi=atan2(g*ey',g*ex');
  Zyl=[rho,phi,z]; 
else
  Zyl=zeros(size(Geom));
end

k=0;
for p=1:length(Desc2d0),
  d=Desc2d0{p};
  dd=HalfPatchRecurs(Geom(d,:),d,c,Zyl(d,:),Sym);
  Desc2d(k+1:k+length(dd))=dd;
  NewPats(p)=k+1;
  SubDiv(p)=length(dd);
  k=k+length(dd);
end

return



function dd=HalfPatchRecurs(g,d,c,Zyl,Sym)

% divides single patch d with node geometry g into a list dd of 
% patches so that no patch has more than c corners

if length(d)<=c,
  if isempty(d),
    dd={};
  else
    dd={d(:).'};
  end
  return
end

[num1,num2,num3]=HalfPatchNum(g,Zyl,Sym);
d1=HalfPatchRecurs(g(num1,:),d(num1),c,Zyl(num1,:),Sym);
d2=HalfPatchRecurs(g(num2,:),d(num2),c,Zyl(num1,:),Sym);
d3=HalfPatchRecurs(g(num3,:),d(num3),c,Zyl(num1,:),Sym);
dd=[d1;d2;d3];



function [num1,num2,num3]=HalfPatchNum(g,Zyl,Sym)

nc=size(g,1);

if Sym&&~isequal(nc,4),
  
  if std(Zyl(:,1))>std(Zyl(:,3)),
    q=Zyl(:,1);
  else
    q=Zyl(:,3);
  end
  mq=mean(q);
  if q(1)<mq,
    m=1;
    while (m<nc)&&(q(m+1)<mq),
      m=m+1;
    end
    n=nc+1;
    while (n>1)&&(q(n-1)<mq),
      n=n-1;
    end
  else
    m=1;
    while (m<nc)&&(q(m+1)>=mq),
      m=m+1;
    end
    n=nc+1;
    while (n>1)&&(q(n-1)>=mq),
      n=n-1;
    end
  end
  if n>1, 
    n=n-nc; 
  end
  n1=(n+m)/2;
  n2=(m+n+nc)/2;
  min1=floor(n1);
  max1=ceil(n1);
  min2=floor(n2);
  max2=ceil(n2);
  num1=mod([n:min1,max2:n+nc-1]-1,nc)+1;
  num2=mod([min1:max1,min2:max2]-1,nc)+1;
  if length(num2)<3, 
    num2=[]; 
  end
  num3=mod([max1:min2]-1,nc)+1;
  
else

  co=PatchCosines(g);

  n1=1:ceil(nc/2);
  n2=ceil((nc+1)/2):nc;

  [du,m]=max(co(n1).^2+co(n2).^2);  % split at node m

  num1=n1(m):n2(m);
  num2=[n2(m):nc,1:n1(m)];
  num3=[];

end



function cosi=PatchCosines(g)

e=g([2:end,1],:)-g;
e=e./repmat(sqrt(sum(abs(e).^2,2)),1,3);
cosi=-dot(e,e([end,1:end-1],:),2);


