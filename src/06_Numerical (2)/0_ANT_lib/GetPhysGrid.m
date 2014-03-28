
function [PhysGrid,NewO,NewN,NewS,NewP]=...
  GetPhysGrid(AntGrid,Solver,Option,DataRootDir)

% [PhysGrid,NewO,NewN,NewS,NewP]=GetPhysGrid(AntGrid,Solver,Option) 
% extracts the physically effective objects from AntGrid (objects for which
% AntGrid.Obj.Phys.Act=1) and returns it in PhysGrid. Only the elements 
% occuring in these objects are maintained.
%
% Wires containing segments which are patch edges are not extracted
% unless Option={'OnlyWires'} is passed or the Solver is ASAP. 
% In the latter case Surf objects and patches are removed.
% Default is Option={}, i.e. wires which are patch edges are omitted.
% If Option={'ForceWires'} is passed, the edges of patches are used as
% segments. All such segments are taken in one Wire object with 
% Name='SurfEdges'.
%
% The index maps NewO, NewN, NewS and NewP describe the mapping from 
% the old to the new object, node, segment and patch indices, respectively.
%
% Solver defines the program to be used for the determination of 
% antenna the currents. The implemented solvers are declared in the
% global variable Atta_Solver_Names.
%
% [...]=GetPhysGrid(AntGrid,Solver,Option,DataRootDir)
% also passes the directory DataRootDir in which all data concerning
% the antenna configuration AntGrid are to be stored. If this parameter is 
% given, PhysGrid is stored into the file defined in the global variable
% Atta_PhysGridFile in the respective solver-directory (For directory
% structure see also GetDataSubdirs).

if ~exist('Solver','var')||isempty(Solver),
  error('No solver defined.');
end
Solver=CheckSolver(Solver);
if isempty(Solver),
  error('Unknown solver requested.');
end

EdgeObjName4Surfs='SurfEdges';

if ~exist('Option','var')||isempty(Option),
  Option={};
end
if ~iscell(Option),
  Option={Option};
end

OnlyWires=false;
if ismember(upper('OnlyWires'),cellfun(@upper,Option,'UniformOutput',false))...
    || isequal(Solver,CheckSolver('ASAP')),
  OnlyWires=true;
end
  
ForceWires=false;
if ismember(upper('ForceWires'),cellfun(@upper,Option,'UniformOutput',false)),
  ForceWires=true;
end


% pack grid:
% ------------

[AntGrid,NewN,NewS,NewP,NewO]=GridPack(AntGrid,0,'all',[1,1]);


% extract physical grid:
% ------------------------

PhysObjs=[];
for n=1:numel(AntGrid.Obj),
  try
    m=AntGrid.Obj(n).Phys.Act;
  catch
    m=[];
  end
  if isempty(m),
    m=0;
  end
  if m~=0,
    PhysObjs=[PhysObjs,n];
  end
end

[Pos,Wis,Sus]=FindGridObj(AntGrid);

% add edges of patch objects as segments and collect them in a wire object:

if ForceWires, 
  
  Nsegold=size(AntGrid.Desc,1);
  
  % detect edges that are not yet present as segments in wire objects:
  
  Edges=FindPatchEdges(AntGrid,Sus);
  nn={AntGrid.Obj(Wis).Elem};
  for n=1:length(nn),
    nn{n}=nn{n}(:).';
  end
  nn=unique([nn{:}]);
  n=~ismember(sort(Edges,2),sort(AntGrid.Desc(nn,:),2),'rows');
  Edges=Edges(n,:); 
  
  if ~isempty(Edges),

    AntGrid.Desc=[AntGrid.Desc;Edges];

    % determine unique name for new object containing edge segments:

    q=EdgeObjName4Surfs;
    x=FindGridObj(AntGrid,'Name',q);
    n=0;
    while ~isempty(x),
      n=n+1;
      q=[EdgeObjName4Surfs,num2str(n)];
      x=FindGridObj(AntGrid,'Name',q);
    end

    % add new wire object:
    
    AntGrid=GridObj(AntGrid,'Wire',(Nsegold+1):size(AntGrid.Desc,1),...
      'Name',q,'Phys.Dimension',2);
    
    PhysObjs=[PhysObjs,length(AntGrid.Obj)];
  
  end
  
end

% remove patches if only wire grid:

if OnlyWires||ForceWires,
  PhysObjs=setdiff(PhysObjs,Sus);
end

% finally extract:

[PhysGrid,NewO2,NewN2,NewS2,NewP2]=GridExtract(AntGrid,PhysObjs);

NewO=MapComp(NewO,NewO2);
NewN=MapComp(NewN,NewN2);
NewS=MapComp(NewS,NewS2);
NewP=MapComp(NewP,NewP2);

PhysGrid.Solver=Solver;


% check if there are segments along patches and delete 
% the corresponding wire-objects:
% ---------------------------------------------------------

if ~isempty(PhysGrid.Desc2d),
  
  Edges=FindPatchEdges(PhysGrid);

  n=find(ismember(sort(PhysGrid.Desc,2),sort(Edges,2),'rows'));

  if ~isempty(n),
    
    [PhysGrid,NewO2,NewN2,NewS2,NewP2]=...
      GridRemove(PhysGrid,[],[],-n,[],[],'all');
    NewO=MapComp(NewO,NewO2);
    NewN=MapComp(NewN,NewN2);
    NewS=MapComp(NewS,NewS2);
    NewP=MapComp(NewP,NewP2);
    
    [PhysGrid,NewO2,NewN2,NewS2,NewP2]=GridExtract(PhysGrid,'all');
    NewO=MapComp(NewO,NewO2);
    NewN=MapComp(NewN,NewN2);
    NewS=MapComp(NewS,NewS2);
    NewP=MapComp(NewP,NewP2);
    
  end

end


% sort elements according to their appearance in the 
% physical objects (PhysGrid.Obj):
% ---------------------------------------------------

[Pos,Wis,Sus]=FindGridObj(PhysGrid);

% segments:

Nseg=size(PhysGrid.Desc,1);      % number of segments

PhysGrid.Desc_.ObjNum=zeros(Nseg,1);

NewS2=zeros(Nseg,1);

count=0;
for n=1:length(Wis),
  nn=length(PhysGrid.Obj(Wis(n)).Elem);
  PhysGrid.Desc_.ObjNum(count+1:count+nn)=Wis(n);
  NewS2(count+1:count+nn)=abs(PhysGrid.Obj(Wis(n)).Elem);
  count=count+nn;
end

if count<Nseg,
  error('Not all segments in Wire-objects.');
elseif any(NewS2==0),
  error('Zero segment number not allowed.'); 
end

SegObjs=cell(Nseg,1);
for q=1:Nseg,
  SegObjs{q}=PhysGrid.Desc_.ObjNum(NewS2==q);
end

[xx,ii]=unique(NewS2,'last');
ii=sort(ii);
PhysGrid.Desc_.ObjNum=PhysGrid.Desc_.ObjNum(ii);
NewS2=NewS2(ii);

SegObjs=SegObjs(NewS2);
PhysGrid.Desc=PhysGrid.Desc(NewS2,:);

NewS2(NewS2)=(1:length(NewS2)).';
NewS=MapComp(NewS,NewS2);

if count>Nseg,
  display('Overlapping Wire-objects.');
  fprintf(' Seg   Objects\n');
  for q=1:Nseg,
    if length(SegObjs{q})>1,
      fprintf('%4d: ',q);
      fprintf(' %3d',SegObjs{q});
      fprintf('\n')
    end
  end
  fprintf('\n');      
end

PhysGrid=GridUpdate(PhysGrid,'Segments',NewS2);

if ~isequal(PhysGrid.Desc_.ObjNum,sort(PhysGrid.Desc_.ObjNum))
  error('Wire ObjNums must be sorted.');
end

% patches:

Npat=numel(PhysGrid.Desc2d);   % number of patches

PhysGrid.Desc2d_.ObjNum=zeros(Npat,1);

NewP2=zeros(Npat,1);

count=0;
for n=1:length(Sus),
  nn=length(PhysGrid.Obj(Sus(n)).Elem);
  PhysGrid.Desc2d_.ObjNum(count+1:count+nn)=Sus(n);
  NewP2(count+1:count+nn)=abs(PhysGrid.Obj(Sus(n)).Elem);
  count=count+nn;
end

if count<Npat,
  error('Not all patches in Surf-objects.');
elseif any(NewP2==0),
  error('Zero patch number not allowed.'); 
end

PatObjs=cell(Npat,1);
for q=1:Npat,
  PatObjs{q}=PhysGrid.Desc2d_.ObjNum(NewP2==q);
end

[xx,ii]=unique(NewP2,'last');
ii=sort(ii);
PhysGrid.Desc2d_.ObjNum=PhysGrid.Desc2d_.ObjNum(ii);
NewP2=NewP2(ii);

PatObjs=PatObjs(NewP2); 
PhysGrid.Desc2d=PhysGrid.Desc2d(NewP2);

NewP2(NewP2)=(1:length(NewP2)).';
NewP=MapComp(NewP,NewP2);

if count>Npat,
  display('Overlapping Patch-objects.');
  fprintf(' Pat   Objects\n');
  for q=1:Npat,
    if length(PatObjs{q})>1,
      fprintf('%4d: ',q);
      fprintf(' %3d',PatObjs{q});
      fprintf('\n')
    end
  end
  fprintf('\n');      
end

PhysGrid=GridUpdate(PhysGrid,'Patches',NewP2);

if ~isequal(PhysGrid.Desc2d_.ObjNum,sort(PhysGrid.Desc2d_.ObjNum))
  error('Surface ObjNums must be sorted.');
end


% Collect Wire properties:
% ----------------------------

PhysGrid.Desc_.Diam=nan(Nseg,1);
PhysGrid.Desc_.Cond=nan(Nseg,1);

if isequal(Solver,CheckSolver('CONCEPT')),
  PhysGrid.Desc_.NBases=nan(Nseg,1);
end

for n=1:length(Wis),
  
  e=PhysGrid.Obj(Wis(n)).Elem;

  try 
    q=PhysGrid.Obj(Wis(n)).Phys.Diam;
  catch
    q=[];
  end
  if ~isempty(q),
    PhysGrid.Desc_.Diam(e)=q;
  end
  
  try
    q=PhysGrid.Obj(Wis(n)).Phys.Cond;
  catch
    q=[];
  end
  if ~isempty(q),
    PhysGrid.Desc_.Cond(e)=q;
  end
  
  try
    q=PhysGrid.Obj(Wis(n)).Phys.NBases;
  catch
    q=[];
  end
  if ~isempty(q),
    PhysGrid.Desc_.NBases(e)=q;
  end
  
end

PhysGrid.Desc_.Diam(isnan(PhysGrid.Desc_.Diam))=PhysGrid.Default.Wire.Diam;
PhysGrid.Desc_.Cond(isnan(PhysGrid.Desc_.Cond))=PhysGrid.Default.Wire.Cond;

if isequal(Solver,CheckSolver('CONCEPT')),
  PhysGrid.Desc_.NBases(isnan(PhysGrid.Desc_.NBases))=PhysGrid.Default.CONCEPT.Wire.NBases;
end


% Collect Surf properties:
% ----------------------------

PhysGrid.Desc2d_.Thick=zeros(Npat,1);
PhysGrid.Desc2d_.Cond=zeros(Npat,1);

for n=1:length(Sus),
  
  e=PhysGrid.Obj(Sus(n)).Elem;
  
  try 
    q=PhysGrid.Obj(Sus(n)).Phys.Thick;
  catch
    q=[];
  end
  if ~isempty(q),
    PhysGrid.Desc2d_.Thick(e)=q;
  end
  
  try
    q=PhysGrid.Obj(Sus(n)).Phys.Cond;
  catch
    q=[];
  end
  if ~isempty(q),
    PhysGrid.Desc2d_.Cond(e)=q;
  end
  
end

PhysGrid.Desc2d_.Thick(isnan(PhysGrid.Desc2d_.Thick))=PhysGrid.Default.Surf.Thick;
PhysGrid.Desc2d_.Cond(isnan(PhysGrid.Desc2d_.Cond))=PhysGrid.Default.Surf.Cond;


% Find Feeds and Loads:
% ---------------------

% node feeds:

NodeFeedObjs=FindGridObj(PhysGrid,'Name','Feeds','Type','Point');
q=[];
V=[];
obnu=[];
for n=1:length(NodeFeedObjs),
  el=PhysGrid.Obj(NodeFeedObjs(n)).Elem(:);
  q=[q;el];
  obnu=[obnu;repmat(NodeFeedObjs(n),size(el))];
  try
    Vn=PhysGrid.Obj(NodeFeedObjs(n)).Phys.V(:);
  catch
    Vn=[];
  end
  if isempty(Vn),
    Vn=repmat(nan,size(el)); 
  elseif length(Vn)~=length(el),
    error(['Voltage definition inconsistent with number of elements in object ',...
      num2str(NodeFeedObjs(n))]);
  end
  V=[V;Vn];
end
[qq,ii]=unique(q);
ii=sort(ii);
if length(ii)<length(q),
  warning('Multiple (overlapping) feed definitions in point objects.');
end
PhysGrid.Geom_.Feeds.ObjNum=obnu(ii);
PhysGrid.Geom_.Feeds.Elem=q(ii);
V=V(ii);
if any(isnan(V)),
  if ~all(isnan(V)),
    warning('Some but not all feed voltages are defined (missining ones are set 0).');
    V(isnan(V))=0;
  else
    V=[];  % [] indicate that no voltages are defined
  end
end
PhysGrid.Geom_.Feeds.V=V;

% segment feeds:

SegFeedObjs=FindGridObj(PhysGrid,'Name','Feeds','Type','Wire');
q=[];
p='';
V=[];
for n=1:length(SegFeedObjs),
  el=PhysGrid.Obj(SegFeedObjs(n)).Elem(:);
  q=[q;el];
  obnu=[obnu;repmat(SegFeedObjs(n),size(el))];
  try
    Vn=PhysGrid.Obj(SegFeedObjs(n)).Phys.V(:);
  catch
    Vn=[];
  end
  if isempty(Vn),
    Vn=repmat(nan,size(el)); 
  elseif length(Vn)~=length(el),
    error(['V(oltage) definition inconsistent with number of elements in object ',...
      num2str(SegFeedObjs(n))]);
  end
  V=[V;Vn];
  try
    po=PhysGrid.Obj(SegFeedObjs(n)).Phys.Posi(:);
  catch
    po='';
  end
  if isempty(po),
    po=repmat('n',size(el));
    % 'n' identifies missing position definition
  elseif length(po)~=length(el),
    error(['Posi(tion) definition inconsistent with number of elements in object ',...
      num2str(SegFeedObjs(n))]);
  end
  p=[p;po];
end
[qq,ii]=unique(q);
ii=sort(ii);
if length(ii)<length(q),
  warning('Multiple (overlapping) feed definitions in wire objects.');
end
PhysGrid.Desc_.Feeds.ObjNum=obnu(ii);
PhysGrid.Desc_.Feeds.Elem=q(ii);
V=V(ii);
if any(isnan(V)),
  if ~all(isnan(V)),
    warning('Some but not all feed voltages are defined (missining ones are set 0).');
    V(isnan(V))=0;
  else
    V=[];
  end
end
PhysGrid.Desc_.Feeds.V=V;
p=p(ii);
if any(p=='n')&&isequal(Solver,CheckSolver('CONCEPT')),
  fprintf('Non-defined feed positions are set to default.\n\n');
  p(p=='n')=PhysGrid.Default.CONCEPT.Feeds.Posi;
end
if isequal(Solver,CheckSolver('CONCEPT')),
  p=CheckCONCEPTPosiChars(p);  
end
PhysGrid.Desc_.Feeds.Posi=p;

% node loads:

NodeLoadObjs=FindGridObj(PhysGrid,'Name','Loads','Type','Point');
q=[];
Z=[];
for n=1:length(NodeLoadObjs),
  el=PhysGrid.Obj(NodeLoadObjs(n)).Elem(:);
  q=[q;el];
  obnu=[obnu;repmat(NodeLoadObjs(n),size(el))];
  ZZ=PhysGrid.Obj(NodeLoadObjs(n)).Phys.Z(:);
  if length(ZZ)~=length(el),
    error(['Number of impedances not correct in Loads of object ,',...
      NodeLoadObjs(n)]);
  end
  Z=[Z;ZZ];
end
[qq,ii]=unique(q);
ii=sort(ii);
if length(ii)<length(q),
  warning('Multiple (overlapping) load definitions in point objects.');
end
PhysGrid.Geom_.Loads.ObjNum=obnu(ii);
PhysGrid.Geom_.Loads.Elem=q(ii);
PhysGrid.Geom_.Loads.Z=Z(ii);

% segments loads:

SegLoadObjs=FindGridObj(PhysGrid,'Name','Loads','Type','Wire');
q=[];
p='';
Z=[];
for n=1:length(SegLoadObjs),
  el=PhysGrid.Obj(SegLoadObjs(n)).Elem(:);
  q=[q;el];
  obnu=[obnu;repmat(SegLoadObjs(n),size(el))];
  ZZ=PhysGrid.Obj(SegLoadObjs(n)).Phys.Z(:);
  if length(ZZ)~=length(el),
    error(['Number of impedances not correct in Loads of object ,',...
      SegLoadObjs(n)]);
  end
  Z=[Z;ZZ];
  try
    po=PhysGrid.Obj(SegLoadObjs(n)).Phys.Posi(:);
  catch
    po='';
  end
  if isempty(po),
    po=repmat('n',size(el));
    % 'n' identifies missing position definition
  elseif length(po)~=length(el),
    error(['Posi(tion) definition inconsistent with number of elements in object ',...
      num2str(SegLoadObjs(n))]);
  end
  p=[p;po];  
end
[qq,ii]=unique(q);
ii=sort(ii);
if length(ii)<length(q),
  warning('Multiple (overlapping) load definitions in wire objects.');
end
PhysGrid.Desc_.Loads.ObjNum=obnu(ii);
PhysGrid.Desc_.Loads.Elem=q(ii);
PhysGrid.Desc_.Loads.Z=Z(ii);
p=p(ii);
if any(p=='n')&&isequal(Solver,CheckSolver('CONCEPT')),
  fprintf('Not defined load positions are set to default.');
  p(p=='n')=PhysGrid.Default.CONCEPT.Loads.Posi;
end
if isequal(Solver,CheckSolver('CONCEPT')),
  p=CheckCONCEPTPosiChars(p);  
end
PhysGrid.Desc_.Loads.Posi=p;


% save PhysGrid if DataRootDir is passed:
% ---------------------------------------

global Atta_PhysGridFile Atta_PhysGridName

if exist('DataRootDir','var'),
  
  if isempty(DataRootDir),
    DataRootDir='';
  end
  SolverDir=GetDataSubdirs(DataRootDir,Solver,[],[],1);
  VarSave(fullfile(SolverDir,Atta_PhysGridFile),PhysGrid,[],Atta_PhysGridName);
  
end


end  % GetPhysGrid


% ---------------------------------------

function pp=CheckCONCEPTPosiChars(p)

pp=lower(p);

pp(pp=='b')='a';
pp((pp~='a')&(pp~='e'))='m';

end
