
function ViewGrid(Ant,BkObjs,BkNodes,BkSegs,BkPats)

% ViewGrid(Ant) visualizes the nodes, segments and patches
% of the given antenna grid Ant. The whole antenna grid is 
% plotted. In an interactive session an arbitrary subset of
% nodes, segments or patches can be selected, being
% plotted red for emphasis. An initial control character is
% used to indicate if objects, nodes, segments or patches 
% are to be emphasized, followed by the subset specification, 
% e.g.: 'n 10:20' the nodes 10 through 20; 's7' segment 7; 
% 'p[8,11,15]' the patches 8, 11 and 15; 'o3' object 3; and so on.
% The control character '!' can be used to execute a MATLAB 
% command without leaving the interactive visualization.
% The control character 'a' changes the state of annotation 
% (if annotation numbers should be displayed or not).
% Use 'q'  to quit the session.
%
% ViewGrid(Ant,BkObjs,BkNodes,BkSegs,BkPats) is the same, 
% but confines the shown part of the antenna grid to BkObjs,
% BkNodes, BkSegs and BkPats, which define the 'background'-items
% (objects, nodes, segments and patches) which are displayed
% during the whole interactive session. Use BkNodes='all' to 
% display all nodes, similarly for the other types. Objects are
% dispayed as their Graf fields determine. Elements which 
% are not in objects are displayed in a default style defined
% by the local variables NodeProp, NodeAnnoProp, SegProp, 
% SegAnnoProp and PatchProp, PatchAnnoProp, respectively.

% control characters (must be uppercase here):

QuitChar='Q';
ObjChar='O';
NodeChar='N';
SegChar='S';
PatchChar='P';
AnnoChar='A';
ExeChar='!';

Blank=' ';
Prompt='->';

UseAnno=1;  % use annotation by default

NodeProp=struct('Marker','o','MarkerSize',4,...
  'MarkerFaceColor',[1,0,0],'MarkerEdgeColor',[1,0,0]);
NodeAnnoProp=struct('Color',[1,0,0],'EraseMode','xor');


SegProp=struct('LineWidth',2,'Color',[0.7,0,0]);
SegAnnoProp=struct('Color',[0.7,0,0],'EraseMode','xor');

PatchProp=struct('FaceLighting','none','FaceAlpha',1,...
  'FaceColor',[0.8,0.3,0],'EdgeColor','k');
PatchAnnoProp=struct('Color',[0.8,0.3,0],'EraseMode','xor');

% view preparation, plot grid:

h=ishold;
if ~h, cla('reset'); hold on; end

if (nargin<2),
  BkObjs='all';
  BkNodes='all';
  BkSegs='all';
  BkPats='all';
end

if ischar(BkObjs),
  BkObj=1:length(Ant.Obj);
end
BkObj=intersect(BkObj,1:length(Ant.Obj));

if ~exist('BkNodes','var'),
  BkNodes=[];
elseif ischar(BkNodes),
  BkNodes=1:size(Ant.Geom,1);
end
BkNodes=intersect(BkNodes,1:size(Ant.Geom,1));

if ~exist('BkSegs','var'),
  BkSegs=[];
elseif ischar(BkSegs),
  BkSegs=1:size(Ant.Desc,1);
end
BkSegs=intersect(BkSegs,1:size(Ant.Desc,1));

if ~exist('BkPats','var'),
  BkPats=[];
elseif ischar(BkPats),
  BkPats=1:length(Ant.Desc2d);
end
BkPats=intersect(BkPats,1:length(Ant.Desc2d));

[Nodes,Segs,Pats,NH,SH,PH]=PlotGrid(Ant,BkObj,BkNodes,BkSegs,BkPats);

axis equal
xlabel('x');
ylabel('y');
zlabel('z');

set(gcf,'Renderer','zbuffer');

% visualized elements, element-, annotation- and hidden handles
[E,OldE,EH,AH,HH]=deal([]); 

% input strings
Inp=Blank;  
OldInp=Blank;

% visualization loop:

while ~isequal(Inp,QuitChar),

  if isequal(Inp,Blank),  % increment E by default
    if ~isempty(E),
      E=OldE+1+OldE(end)-OldE(1);
    end
    Inp=OldInp(1);
  elseif isequal(Inp(1),ExeChar);  % execute input-line as command
    try
      eval(Inp(2:end));
    catch
      display(lasterr);
      Inp=Blank;
    end
  elseif isequal(Inp(1),AnnoChar)&&isempty(deblank(Inp(2:end))),
    UseAnno=~UseAnno;
    Inp=Blank;
  else
    if ~ismember(Inp(1),[ObjChar,NodeChar,SegChar,PatchChar]),
      Inp=[OldInp(1),Inp];  % use recent control character
    end
    try
      E=eval(Inp(2:end));  % determine elements to plot  
      if ~isnumeric(E),
        Inp=Blank;
      end
    catch
      display(lasterr);
      Inp=Blank;
    end
  end
  
  switch Inp(1),
  case NodeChar,

    if isempty(Ant.Geom),
      E=[];
    end
    E=mod(E-1,size(Ant.Geom,1))+1;
    [d,k]=unique(E);
    E=E(sort(k));
    delete(AH);
    delete(EH);
    set(HH,'Visible','on');
    HH=[NH{E}]';
    set(HH,'Visible','off');
    EH=PlotNodes(Ant.Geom,E,[],[],'r');
    set(EH,NodeProp);
    AH=get(EH,'UserData');
    if iscell(AH),
      AH=cat(1,AH{:});
    end
    set(AH,NodeAnnoProp);
    
  case SegChar,
  
    if isempty(Ant.Desc),
      E=[];
    end
    E=mod(E-1,size(Ant.Desc,1))+1;
    [d,k]=unique(E);
    E=E(sort(k));
    delete(AH);
    delete(EH);
    set(HH,'Visible','on');
    HH=[SH{E}]';
    set(HH,'Visible','off');
    EH=PlotSegs(Ant.Geom,Ant.Desc,E,[],'r');
    set(EH,SegProp);
    AH=get(EH,'UserData');
    if iscell(AH),
      AH=cat(1,AH{:});
    end
    set(AH,SegAnnoProp);
    
  case PatchChar,
    
    if isempty(Ant.Desc2d),
      E=[];
    end
    E=mod(E-1,length(Ant.Desc2d))+1;
    [d,k]=unique(E);
    E=E(sort(k));
    delete(AH);
    delete(EH);
    set(HH,'Visible','on');
    HH=[PH{E}]';
    set(HH,'Visible','off');
    EH=PlotPats(Ant.Geom,Ant.Desc2d,E,[],'r');
    set(EH,PatchProp);
    AH=get(EH,'UserData');
    if iscell(AH),
      AH=cat(1,AH{:});
    end
    set(AH,PatchAnnoProp);
    
  case ObjChar,
  
    if isempty(Ant.Obj),
      E=[];
    end
    E=mod(E-1,length(Ant.Obj))+1;
    [d,k]=unique(E);
    E=E(sort(k));
    delete(AH);
    delete(EH);
    set(HH,'Visible','on');
    
    [Points,Wires,Surfs]=FindGridObj(Ant);
    EN=Gather({Ant.Obj(intersect(Points,E)).Elem});
    ES=Gather({Ant.Obj(intersect(Wires,E)).Elem});
    EP=Gather({Ant.Obj(intersect(Surfs,E)).Elem});
    HH=[NH{EN},SH{ES},PH{EP}]';
    set(HH,'Visible','off');
    
    ENH=PlotNodes(Ant.Geom,EN,[],[],'r');
    set(ENH,NodeProp);
    ANH=get(ENH,'UserData');
    if iscell(ANH),
      ANH=cat(1,ANH{:});
    end
    set(ANH,PatchAnnoProp);

    ESH=PlotSegs(Ant.Geom,Ant.Desc,ES,[],'r');
    set(ESH,SegProp);
    ASH=get(ESH,'UserData');
    if iscell(ASH),
      ASH=cat(1,ASH{:});
    end
    set(ASH,PatchAnnoProp);

    EPH=PlotPats(Ant.Geom,Ant.Desc2d,EP,[],'r');
    set(EPH,PatchProp);
    APH=get(EPH,'UserData');
    if iscell(APH),
      APH=cat(1,APH{:});
    end
    set(APH,PatchAnnoProp);
    
    EH=[ENH;ESH;EPH];
    AH=[ANH;ASH;APH];

  end % of switch
  
  if ismember(Inp(1),[NodeChar,SegChar,PatchChar,ObjChar]),
    OldInp=Inp;
    OldE=E;
  end
  
  if UseAnno,
    set(AH,'Visible','on');
  else
    set(AH,'Visible','off');
  end
  
  Inp=deblank(input(Prompt,'s'));
  if isempty(Inp),
    Inp=Blank;
  else
    Inp(1)=upper(Inp(1));
  end
  
end  

set(HH,'Visible','on');
delete(AH);
delete(EH);

if ~h, hold off; end
