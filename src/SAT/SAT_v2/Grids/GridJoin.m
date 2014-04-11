
function Ant=GridJoin(Ant1,Ant2,Con1,Con2,Opt,ConName)

% Ant=GridJoin(Ant1,Ant2,Con1,Con2,Opt,ConName)
% puts together the two antenna grids Ant1 and Ant2. Additionally,
% the nodes Con1 of grid 1 are connected to the nodes Con2
% of grid 2. Con1 and Con2 are optional: If both are omitted 
% or empty, no connections are added. In case Con1 and Con2 are
% non-empty and length(Con1)>length(Con2), Ant2.Geom(Con2,:) are 
% connected to the respectively closest nodes of Ant1.Geom(Con1,:);
% vice versa for length(Con1)<length(Con2); in these cases
% a warning message is created when the optional parameter Opt 
% is not given, so set Opt=0 to omit the warning message.
%
% By passing Opt=1 a connection of Con2-nodes to closest nodes 
% of Con1 is forced; vice versa by setting Opt=2. 
% If Con1 is a string all nodes of Ant1 are used, similarly for Con2.
% If a string ConName is passed, the added connections are collected 
% in one new object of type 'Wire' with the name ConName. This object 
% is generated as the last object in the resulting structure: 
% Ant.Obj(end). If a Wire object with name ConName already exists,
% the connections are added to the elements of this object.
%
% Ant.Init is set to Ant1.Init+Ant2.Init, so successive GridJoin
% calls count the number of joined grids in the field Init.

if ~isfield(Ant1,'Init'),
  Ant1=GridInit(Ant1);
end

if ~isfield(Ant2,'Init'),
  Ant2=GridInit(Ant2);
end

if nargin<3,
  Con1=zeros(0,1);
elseif ischar(Con1),
  Con1=1:size(Ant1.Geom,1);
end
Con1=Con1(:);
Con1=Con1(find(Con1<=size(Ant1.Geom,1)));

if nargin<4,
  Con2=zeros(0,1);
elseif ischar(Con2),
  Con2=1:size(Ant2.Geom,1);
end
Con2=Con2(:);
Con2=Con2(find(Con2<=size(Ant2.Geom,1)));

if isempty(Con1)|isempty(Con2),
  Con1=zeros(0,1);
  Con2=zeros(0,1);
end

if nargin<5,
  Opt=[];
end

if (length(Con1)~=length(Con2)) & ~(isequal(Opt,1)|isequal(Opt,2)),
  Warn=~isequal(Opt,0);
  if length(Con2)<length(Con1),
    Opt=1;
  else
    Opt=2;
  end
%   if Warn,
%     warning(['GridJoin option set to ',num2str(Opt),'.']);
%   end
end

if isequal(Opt,1),
  C=GridNearest(Ant1.Geom(Con1,:),Ant2.Geom(Con2,:));
  Con1=Con1(C,1);
elseif isequal(Opt,2),
  C=GridNearest(Ant2.Geom(Con2,:),Ant1.Geom(Con1,:));
  Con2=Con2(C,1);
end

f1=fieldnames(Ant1);
f2=fieldnames(Ant2);
fc=intersect(f1,f2); 
f1=setdiff(f1,fc);
f2=setdiff(f2,fc);
fc=setdiff(fc,{'Init'});

Ant=SetStruct(Ant1,Ant2);

Ant.Init=Ant1.Init+Ant2.Init;

% append fields of Ant2 to the corresponding fields of Ant1:

for m=1:length(fc),
  f=fc{m};
  s=getfield(Ant1,f);
  if isstruct(s),
    Ant=setfield(Ant,f,SetStruct(s,0,getfield(Ant2,f)));
  elseif isequal(f,'Desc2d'),
    Ant=setfield(Ant,f,[s(:);Ant2.Desc2d(:)]);
  else
    Ant=setfield(Ant,f,[s;getfield(Ant2,f)]);
  end
end

% Update Desc, Desc2d and Obj:

n1=size(Ant1.Geom,1);
s1=size(Ant1.Desc,1);
p1=length(Ant1.Desc2d);
o1=length(Ant1.Obj);

Ant.Desc(s1+1:end,:)=Ant.Desc(s1+1:end,:)+n1;  

ConSegs=size(Ant.Desc,1)+(1:length(Con1));     % added connections
Ant.Desc(ConSegs,:)=[Con1,Con2+n1];

for p=(p1+1):(p1+length(Ant2.Desc2d)),
  Ant.Desc2d{p}=Ant.Desc2d{p}+n1;
end

[Points,Wires,Surfs]=GridFindObj(Ant2);

for n=Points(:)'+o1,
  Ant.Obj(n).Elem=(abs(Ant.Obj(n).Elem)+n1).*sign(Ant.Obj(n).Elem);
end

for n=Wires(:)'+o1,
  Ant.Obj(n).Elem=(abs(Ant.Obj(n).Elem)+s1).*sign(Ant.Obj(n).Elem);
end

for n=Surfs(:)'+o1,
  Ant.Obj(n).Elem=(abs(Ant.Obj(n).Elem)+p1).*sign(Ant.Obj(n).Elem);
end

% generate connection object:

if nargin<6,
  ConName=[];
end
if ~ischar(ConName),
  return
end

o=GridFindObj(Ant,'Type','Wire','Name',ConName);

if isempty(o),
  Ant=GridObj(Ant,'Wire',ConName,ConSegs);
else
  for n=o(:)',
    Ant.Obj(n).Elem=union(Ant.Obj(n).Elem,ConSegs);
  end
end

