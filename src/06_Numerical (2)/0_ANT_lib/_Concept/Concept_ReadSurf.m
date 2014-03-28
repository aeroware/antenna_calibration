 
function Grid=Concept_ReadSurf(WorkingDir)

% Grid=Concept_ReadSurf(WorkingDir,SurfFile) reads the surface
% structure from the file the name of which is defined in the
% global variable Atta_Concept_Surf0. The file is expected in the 
% directory WorkingDir (default is the current directory).
% The returned Grid contains the fields Geom and Desc2d
% defining the surface structure.

global Atta_Concept_Surf0

if ~exist('WorkingDir','var')||isempty(WorkingDir),
  WorkingDir='';
end

SurfFile=fullfile(WorkingDir,Atta_Concept_Surf0);
d=dir(SurfFile);
if isempty(d)||d.isdir,
  error(['File "',SurfFile,'" not found.']);
end

fid=fopen(SurfFile,'r');

NNodes=fscanf(fid,'%e',1);
NPats=fscanf(fid,'%e',1);

%Grid.Geom=zeros(NNodes,3);
Grid.Geom=reshape(fscanf(fid,'%e',3*NNodes),3,NNodes).';

Grid.Desc2d=cell(NPats,1);
for n=1:NPats,
  x=fscanf(fid,'%e',4);
  x=x(:).';
  if x(4)~=0,
    Grid.Desc2d{n}=x;
  else
    Grid.Desc2d{n}=x(1:3);
  end
end

fclose(fid);

