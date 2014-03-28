
function [Ant,NewObjs,NewSegs,NewPats]=GridUpdate(Ant0,...
  Type,NewInd,Pack,FreeObjs)

% [Ant,NewObjs,NewSegs,NewPats]=GridUpdate(Ant0,Type,NewInd,Pack,FreeObjs)
% updates the Ant0 grid as defined by NewInd, which is an index 
% map for the elements of the given Type: 'Nodes', 'Segments', 
% or 'Patches'. Optional values for Type are 0,1 and 2 which 
% correspond to 'Nodes', 'Segments' and 'Patches', respectively.
% For Type='Nodes' the Ant0-fields  Desc, Desc2d and Obj are
% updated, for Type='Segments' or 'Patches' only Obj is
% updated. Ant returns the updated grid, NewObjs an index map 
% which represents the update of objects. NewSegs and NewPats are 
% only returned for Type='Nodes' and represent the change of
% segments and patches, respectively.
% Note that the type of elements (Type) the index map of which
% is given remains unchanged. You can force this transformation 
% by adding a plus sign at the end of the Type string, e.g. 
% Type='Nodes+'. But careful use is recommended as the 
% transformation is not unique if NewInd represents a 
% non-injective map.
% Pack is a 2-element vector used to cause reduction of multiple segments 
% and patches (and zero-length segments and patches with less than 3 nodes). 
% Pack(1)=1 reduces segments, Pack(2)=1 patches. For instance, Pack=[0,1]
% reduces patches, but not segments, etc.
% The optional argument FreeObjs causes removal of the given objects if
% any elements of the respective object are removed. Objects not contained
% in FreeObjs remain, but reduced by removed elements. FreeObjs='all' sets 
% all objects free. Default: FreeObjs=[].

if nargin<3,
  error('Not enough input arguments.');
end

if (nargin<4)||isempty(Pack),
  Pack=[0,0];
elseif length(Pack)==1,
  Pack=[Pack,Pack];
end

if nargin<5,
  FreeObjs=[];
end
if ischar(FreeObjs),
  FreeObjs=1:length(Ant0.Obj);
end
FreeObjs=intersect(FreeObjs,1:length(Ant0.Obj));

Ant=Ant0;

[Points,Wires,Surfs]=FindGridObj(Ant);

if isequal(upper(Type(1)),'N')||isequal(Type,0), % Type='Nodes'

  NewNodes=NewInd(:)';
  
  % update Desc:

  NewSegs=zeros(1,size(Ant.Desc,1));
  Ant.Desc=NewNodes(Ant.Desc);
  n=find(all(Ant.Desc,2));
  Ant.Desc=Ant.Desc(n,:);
  NewSegs(n)=1:length(n);
  
  % segment-packing: remove multiple segment definitions and
  % connections of zero length (from nodes to themselves):

  if Pack(1),
    
    % remove multiple segment definitions 
    Desc=flipud(Ant.Desc); % flipud is used to choose as representative  
                           % the first of equal values, not the last
    [D,k,NSegs]=unique(sort(Desc,2),'rows');
    [k,D]=sort(k);
    Desc=flipud(Desc(k,:));
    [k,D]=sort(D);           % inversion of D
    NSegs=size(Desc,1)+1-flipud(D(NSegs));
    k=find(Desc(NSegs,2)==Ant.Desc(:,1)); % reverted segments
    NSegs(k)=-NSegs(k);                   % are set negative
    NewSegs=MapComp(NewSegs,NSegs);

    % remove connections from nodes to themselves
    k=find(Desc(:,1)~=Desc(:,2));
    Ant.Desc=Desc(k,:);
    NSegs=zeros(1,size(Desc,1));
    NSegs(k)=1:length(k);
    NewSegs=MapComp(NewSegs,NSegs);
    
  end % segment-packing 

  % update Desc2d:
  
  NewPats=zeros(1,length(Ant.Desc2d));
  for n=1:length(NewPats),
    Ant.Desc2d{n}=NewNodes(Ant.Desc2d{n});
    NewPats(n)=all(Ant.Desc2d{n});
  end
  n=find(NewPats);
  Ant.Desc2d=Ant.Desc2d(n);
  NewPats(n)=1:length(n);
  
  % patch-packing: remove multiple patch definitions
  % and patches with less than 3 nodes:

  if Pack(2),
    
    p0=length(Ant.Desc2d);
    k=zeros(1,p0);          % patches to keep
    nk=0;                   % number of patches to keep
    NPats=k;                % new patch numbers 
    
    for n=1:p0,
      dn=Ant.Desc2d{n}(:)';
      if length(unique(dn))>=3, % exclude patches with less than 3 nodes
        m=0;
        while (m<nk)&&(NPats(n)==0),
          m=m+1;
          dm=Ant.Desc2d{k(m)}(:)';
          if isequal(sort(dn),sort(dm)),
            for s=1:length(dn),
              if isequal(dn,dm),
                NPats(n)=m;
                break
              elseif isequal(dn,fliplr(dm)), % if reverse orientation 
                NPats(n)=-m;                 % set patch number negative
                break            
              end
              dm=[dm(2:end),dm(1)];
            end
          end
        end
        if NPats(n)==0,
          nk=nk+1;
          k(nk)=n;
          NPats(n)=nk;
        end
      end
    end
    
    Ant.Desc2d=Ant.Desc2d(k(1:nk));
    
    NewPats=MapComp(NewPats,NPats);
    
  end % patch-packing
  
elseif isequal(upper(Type(1)),'S')||isequal(Type,1), % Type='Segments'
  
  NewSegs=NewInd(:)';
  NewPats=[];
  NewNodes=[];
  
elseif isequal(upper(Type(1)),'P')||isequal(Type,2), % Type='Patches'
  
  NewPats=NewInd(:)';
  NewSegs=[];
  NewNodes=[];
  
else 
  
  error('Invalid Type parameter.');
  
end

% update point-, wire- and surface-objects in Ant.Obj:

NewObjs=ones(1,length(Ant.Obj));

if ~isempty(NewNodes),
  for n=Points(:)',
    e=MapComp(Ant.Obj(n).Elem,NewNodes);
    NewObjs(n)=all(e(:));
    Ant.Obj(n).Elem=e(e~=0);
  end
end

if ~isempty(NewSegs),
  for n=Wires(:)',
    e=MapComp(Ant.Obj(n).Elem,NewSegs);
    NewObjs(n)=all(e(:));
    Ant.Obj(n).Elem=e(e~=0);
  end
end

if ~isempty(NewPats),
  for n=Surfs(:)',
    e=MapComp(Ant.Obj(n).Elem,NewPats);
    NewObjs(n)=all(e(:));
    Ant.Obj(n).Elem=e(e~=0);
  end
end

n=union(find(NewObjs),setdiff(1:length(Ant.Obj),FreeObjs));
Ant.Obj=Ant.Obj(n);
NewObjs(n)=1:length(n);

% optional transformation of the given Type of elements:

if ~isequal(Type(end),'+'),
  return
end
  
if ~isempty(NewNodes),
  
  if length(NewNodes)~=size(Ant0.Geom,1),
    error('Incorrect lenght of NewNodes index map.');
  end
  n=find(NewNodes);
  Ant.Geom=zeros(max(NewNodes),3);
  Ant.Geom(NewNodes(n),:)=Ant0.Geom(n,:);
  
elseif ~isempty(NewSegs),
  
  if length(NewSegs)~=size(Ant0.Desc,1),
    error('Incorrect lenght of NewSegs index map.');
  end
  n=find(NewSegs);
  Ant.Desc=zeros(max(NewSegs),2);
  Ant.Desc(NewSegs(n),:)=Ant0.Desc(n,:);
  
elseif ~isempty(NewPats),
  
  if length(NewPats)~=length(Ant0.Desc2d),
    error('Incorrect lenght of NewPats index map.');
  end
  n=find(NewPats);
  Ant.Desc2d=cell(max(NewSegs),1);
  Ant.Desc2d(NewPats(n))=Ant0.Desc2d(n);
  
end

  