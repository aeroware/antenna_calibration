
function NecWrite(InFile,Ant,Comment,Trailer)

% NecWrite(InFile,Ant,Op) creates NEC input file (filename expected
% in string InFile) by translating given data into NEC input format.
% Ant defines the antenna system struct, the following fields of which 
% are used to create the NEC input file:
%   Ant. Geom, Desc, Desc2d, Obj, Phys, Freq, Solver
% 
% Field description:
%   Geom    N x 3, coordinates of grid nodes (x,y,z) 
%   Desc    S x 2, grid segments (start node, end node)
%   Desc2d  cell(P,1), nodes of P patches 
%   Obj     objects, a structure array with the fields
%           Type, Elem, Name, Graf, Phys 
%   Phys    physical properties, in particular default values; 
%           it is a structure with at least the following fields:
%           Exterior.epsr relative permittivity of exterior medium
%           Wire.Cond   conductivity of wires (inf for perfect conductors)
%           Wire.Radius radius of wires
%   Title   title or name of antenna system (optional)
%
% Note that the Ant structure contains a field Phys which defines the 
% default physical properties of the objects. In addition there is a field
% Phys in the objects (Ant.Obj.Phys) defining properties specific to the
% respective objects. If no definition of a specific object property is
% given, the respective default property in Ant.Phys is used. Further
% possible properties which can be defined in Ant.Obj.Phys:
%           Load        impedance of a connected load
%           Tag         tag, has to be nonnegative for active elements, 
%                       for Tag<0 only grafical depiction but no relevance 
%                       for calculations
%
%   Freq    operation frequency
%   Solver  defines the solver and solver-specific parameters:

% All physical quantities are supposed to be in SI-units!
%
% NecWrite(InFile,Ant,Op,Comment,Trailer)
% adds the given Comments (string array or cell array of strings) 
% as a file header and the Trailer as final commands before execution.


% open/create NEC input file:

fid=fopen(InFile,'wt');
if fid<0,
  error(['Could not open file ',InFile]);
end

% Preamble:

if exist(Comment,'var')&&~isempty(Comment),
  if ~iscell(Comment),
    Comment={Comment};
  end
  %fprintf(fid,'CM \n');
  for n=1:numel(Comment),
    L=Comment{n};
    for q=1:size(L,1),
      fprintf(fid,'CM %s\n',L(q,:));
    end
  end
  fprintf(fid,'CM \n');
end


