function [Ant]=COMSOL_mesh_ReadIn(Ant,WorkingDir,Atta_COMSOL_mesh_In)
% [AntGrid]=COMSOL_mesh_ReadIn(Ant,WorkingDir,Atta_COMSOL_mesh_In) 
% reads the 3D mesh from a COMSOL mesh export file (text). Filename is defined
% in the global variable Atta_COMSOL_mesh_In (which is expected in the
% directory WorkingDir) and returns it in the structure AntGrid; the
% following fields are returned: Geom, Desc, Desc2d
%
% The fields are filled when the corresponding data are found in the files.
%
% *************************************************************************
% AntGrid : returns the full antenna grid structure (Geom, Desc, Desc2d)
%
% Ant                  : antenna grid structure
% WorkingDir           : ....
% Atta_COMSOL_mesh_In  : filename
%
% *************************************************************************
% 0.50 - 07.10.2009: initial release (altered from Asap_ReadIn.m)
% 0.00 - 00.00.0000:  
% 0.00 - 00.00.0000:  
% *************************************************************************

if ~exist('Ant','var')||isempty(Ant),
  Ant = GridInit();
  AttaInit;
end

% open file:
% ----------

if ~exist('Atta_COMSOL_mesh_In','var')||isempty(Atta_COMSOL_mesh_In),
  Atta_COMSOL_mesh_In='';
end

if ~exist('WorkingDir','var')||isempty(WorkingDir),
  WorkingDir='';
end

AIF=fullfile(WorkingDir,Atta_COMSOL_mesh_In);

file_id=fopen(AIF,'rt');
log_id=fopen('COMSOL_mesh_ReadIn.log','wt');

if file_id<0
  error(['Could not open file ',AIF]);
elseif log_id<0
  error(['Could not open log file to write: ','COMSOL_mesh_ReadIn.log']);
end

% strings to find:
% ----------

str_types={'# Mesh point coordinates',...
           '1 # number of nodes per element',...
           '2 # number of nodes per element',...
           '3 # number of nodes per element',...
           '4 # number of nodes per element'};


% MAIN LOOP:
% ----------

str_line_num=0; 

while ~feof(file_id),  
  
str_Line=deblank(fgetl(file_id));
geom_sect='';

for k=str_types,
  p=strfind(str_Line,k{1});
  if ~isempty(p), 
    geom_sect=k{1};
    str_Line=str_Line(p(1)+length(str_types):end);
    break, 
  end
end
  
switch geom_sect,

case '# Mesh point coordinates',
   errmsg='';
   while isempty(errmsg)
       str_Line=deblank(fgetl(file_id));
       [coordinates,count,errmsg,nextindex] = sscanf(str_Line,'%f',inf);
       if isempty(str_Line) || ~isempty(errmsg)
           break
       end
       Ant.Geom = [Ant.Geom; coordinates'];
   end
   
   if ~isempty(errmsg),
      COMSOLFerror(log_id,...
      'buggy Mesh point coordinates ... on line ',str_line_num);
   end

% case '1 # number of nodes per element',
  
case '2 # number of nodes per element'
   errmsg='';
   while isempty(errmsg)
       str_Line=deblank(fgetl(file_id));
       if strfind(str_Line,'# number of elements')
            fprintf(log_id,'Warning - unknown line %d: %s\n',...
                 str_line_num,fopen(file_id));
            errmsg='';
       elseif strfind(str_Line,'# Elements')
            fprintf(log_id,'Warning - unknown line %d: %s\n',...
                 str_line_num,fopen(file_id));
            errmsg='';
       else 
           [geo_line,count,errmsg,nextindex] = sscanf(str_Line,'%f',inf);
           if isempty(str_Line) || ~isempty(errmsg)
               break
           end
           Ant.Desc = [Ant.Desc; geo_line'+1];% add 1 because 
      end                                  % COMSOL count index starting at 0
   end
   
   if ~isempty(errmsg),
      COMSOLFerror(log_id,'buggy gemometry line description... on line %d: %s\n',...
          str_line_num,str_Line);
   end

case {'3 # number of nodes per element','4 # number of nodes per element'}
   errmsg='';
   while isempty(errmsg)
       str_Line=deblank(fgetl(file_id));
       if strfind(str_Line,'# number of elements')
            fprintf(log_id,'Warning - unknown line %d: %s\n',...
                 str_line_num,fopen(file_id));
            errmsg='';
       elseif strfind(str_Line,'# Elements')
            fprintf(log_id,'Warning - unknown line %d: %s\n',...
                 str_line_num,fopen(file_id));
            errmsg='';
       else 
           [geo_face,count,errmsg,nextindex] = sscanf(str_Line,'%f',inf);
           if isempty(str_Line) || ~isempty(errmsg)
               break
           elseif length(geo_face)==4            % change 4rd and 3rd coordinate to fit in the Ant structure
               geo_face(3:4)=geo_face(4:-1:3);   % COMSOL does spawn 2 vectors and connects the tips
           end                                   % Ant does number it circle wise
           Ant.Desc2d = [Ant.Desc2d; geo_face'+1];  % add 1 because 
       end                                          % COMSOL count index starting at 0
   end
   
   if ~isempty(errmsg),
      COMSOLFerror(log_id,'buggy gemometry line description... on line %d: %s\n',...
          str_line_num,str_Line);
   end

otherwise
  if ~all(isspace(str_Line)) && isempty(geom_sect),
    fprintf(log_id,'Warning - unknown line %d: %s\n',...
      str_line_num,str_Line);
  end
 
end % of switch

end % of MAIN LOOP

Atta_COMSOL_mesh_In=fopen(file_id);
p=fclose(file_id);
q=fclose(log_id);
if p<0,
  error(['Could not close file ',AIF]);
elseif q<0
  error(['Could not close log file to write: ','COMSOL_mesh_ReadIn.log']);
else
  fprintf(1,'\n   Parsing COMSOL mesh file successfull: %s\n',Atta_COMSOL_mesh_In);
end

end  % of COMSOL_mesh_ReadIn


%---------------------------------

function COMSOLFerror(file_id,Err,L)

% Displays error message Err after closing the file associated 
% with file_id. In addition the line number L is output.

Atta_COMSOL_mesh_In=fopen(file_id);

fclose(file_id);

if nargin>2,
  fprintf(1,'\COMSOL file parse error in line %d of ''%s''\n',L,Atta_COMSOL_mesh_In);
end

error(Err);

end
