
function Ant=GridInit(Ant0,ResetFields)

% Ant=GridInit(Ant0,ResetFields) initializes antenna structure: 
% The 'grid fields' 
%   Geom, Desc, Desc2d, Obj, Default 
% are initialized if not yet present. The field Init is created after 
% initialization and in future calls of GridInit the field Init will
% not be changed if it still exists. 
% When the optional parameter ResetFields=1 is passed, initialization of
% the 'grid field' is forced. If ResetFields is a cell array 
% of strings, only the fields with the given names are reset to their 
% respective initial value. All other present fields 
% (i.e. non-'grid fields') remain unchanged.
%
% Ant=GridInit creates a new initialized antenna structure with
% the above mentioned fields.

% Rev. Mar. 2009:
% The global variable Atta_CumulativeGridFields added and
% implemented in GridJoin. Atta_CumulativeGridFields declares which 
% fields of an antenna struct are cumulative, i.e.
% which fields are appended instead of overwritten when joining two
% grids; e.g. all element fields (.Geom, .Desc and .Desc2d) and
% the objects field (.Obj) are cumulative, whereas the 
% .Default field must be non-cumulative (here appending 
% would generate an array of tantamount default values and so 
% unresolvable ambiguities).
%
% Rev. Jan. 2009:
% Fields for default values introduced:
%   Default.CONCEPT.Wire.NBases, Default.CONCEPT.Feeds.Posi,
%   Default.CONCEPT.Loads.Posi,
%   Default.ASAP.Inte
%
% Rev. Nov. 2008:
% Fields for default values introduced:
%   Default.Wire.Diam, Default.Wire.Cond, 
%   Default.Surf.Thick, Default.Surf.Cond.
% Ant.Init is set to 0 (or reset to 0 if empty or not yet present).
%
% Revision Feb. 2008:
% Obj-field 'GraphProp' replaced with 'Graf',
% new Obj-field 'Phys' added;
% Introduction of global variables Default2dObjType and OnlyObj2dElem,
% and corresponding funcionality (see also GridInit).
%
% Revision June 2007:
% Implementation of GlobalMaxPatchCorners, which defines the 
% maximum number of Corners a patch may have. This affects the
% generation of patches in the grid routines GridRevol, GridSphere, 
% GridMatrix, etc.

% define global variables characterizing grid creation behaviour:
% ---------------------------------------------------------------

global GlobalMaxPatchCorners Default2dObjType OnlyObj2dElem

% Default2dObjType prescribes the default objects which are to 
% be defined when 2d grid structures are created which may be 
% composed of segments ('Wire' object) or of patches ('Surf' object).  
% Behavior of previous toolbox versions can be forced 
% by defining Default2dObjType={}.
% Default2dObjType={'Wire','Surf'} forces the generation of both,
% a Wire as well as a Surf object.
% OnlyObj2dElem=1: only 2d-elements which are used in the
% objects defined by Default2dObjType are generated in the
% grid creation routines (GridSphere, etc.).
% OnlyObj2dElem=0: all segments and patches of 2d grids are 
% generated, no matter if objects are defined.

if ~iscell(Default2dObjType)&&isempty(Default2dObjType),
  Default2dObjType={'Wire','Surf'};
end
if isempty(OnlyObj2dElem),
  OnlyObj2dElem=1;
end

% Maximum number of corners allowed in the generation of patches:

if isempty(GlobalMaxPatchCorners),
  GlobalMaxPatchCorners=4;
end

% Declare cumulative grid fields:

global Atta_CumulativeGridFields

if isempty(Atta_CumulativeGridFields),
  Atta_CumulativeGridFields={'Geom','Desc','Desc2d','Obj','Bodies'};
end


% Initialize Ant structure:
%---------------------------

% Fields to be created in Ant:
GridFields={'Geom','Desc','Desc2d','Obj','Default'};

if nargin>0,
  Ant=Ant0;
else 
  Ant=struct('Geom',zeros(0,3));
end

if ~exist('ResetFields','var')||isempty(ResetFields),
  ResetFields={};
elseif ~iscell(ResetFields),
  ResetFields=GridFields;
end
ResetFields=ResetFields(:);

PresentFields=fieldnames(Ant);
insefi=intersect(PresentFields,GridFields);
for f=insefi(:).',
  if isempty(Ant.(f{1})),
    ResetFields=union(ResetFields,f);
  end
end

ResetFields=union(setdiff(GridFields,PresentFields),ResetFields);

% sort according to order in GridFields:
[q,loc]=ismember(GridFields,ResetFields);
if ~isempty(loc),
  loc=loc(loc~=0);
  loc=loc(:);
  ResetFields=ResetFields([loc;setdiff(1:length(ResetFields),loc)]);
end

for f=ResetFields(:).',
  switch f{1},
    case 'Geom',
      Ant.Geom=zeros(0,3);
    case 'Desc',
      Ant.Desc=zeros(0,2);
    case 'Desc2d',
      Ant.Desc2d=cell(0,1);
    case 'Obj',
      Ant.Obj=struct('Type','','Name','','Elem',[],'Graf',[],'Phys',[]);
      Ant.Obj(1)=[];
    case 'Default',
      Ant.Default.Wire.Diam=1e-2;
      Ant.Default.Wire.Cond=50e6;
      Ant.Default.Surf.Thick=1e-2;
      Ant.Default.Surf.Cond=50e6;
      Ant.Default.CONCEPT.Wire.NBases=3;
      Ant.Default.CONCEPT.Feeds.Posi='m';
      Ant.Default.CONCEPT.Loads.Posi='m';
      Ant.Default.ASAP.Inte=200;
      Ant.Exterior.epsr=1;
    otherwise
      Ant.(f{1})=[];
  end
end
  
if ~isfield(Ant,'Init')||isempty(Ant.Init),
  Ant.Init=0;
end

