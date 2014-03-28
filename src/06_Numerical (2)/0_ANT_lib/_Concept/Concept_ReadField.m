
function [F,r,FieldName]=Concept_ReadField(WorkingDir)

% F=Concept_ReadField(FileName) reads complex field vectors from the file
% which is output by eh1d.exe. The file is expected in the directory
% WorkingDir.
% 
% [F,r,FieldName]=Concept_ReadField(FileName)
% also returns the positions r at which the field vectors appear, and the
% name of the field, FieldName.

global Atta_Concept_EHOut Atta_Concept_EHOutasc
global Atta_Concept_EOutasc Atta_Concept_HOutasc

if ~exist('WorkingDir','var')||isempty(WorkingDir),
  WorkingDir='';
end

FileName=fullfile(WorkingDir,Atta_Concept_EHOut);
d=dir(FileName);
if isempty(d)||d.isdir,
  error(['File ',FileName,' not found.']);
end

fid=fopen(FileName,'r');

if fid<0,
  error(['File ',FileName,' not found.']);
end

Eindicator=lower('Electric');
Hindicator=lower('Magnetic');
rIndicator=lower('Field point coord');
  
Ln=0;

% get field name:

FieldName='';
while ~feof(fid)&&isempty(FieldName),
  x=lower(fgetl(fid));
  Ln=Ln+1;
  if ~isempty(strfind(x,Eindicator)),
    FieldName='E';
    Findicator='Ex';
  elseif ~isempty(strfind(x,Hindicator)),
    FieldName='H';
    Findicator='Hx';
  end
end

% read from ascii matrix file if required and possible:

Finished=false;

if Atta_Concept_EHOutasc&&~isempty(FieldName),
  if isequal(FieldName,'E'),
    FileNamex=fullfile(WorkingDir,Atta_Concept_EOutasc);
  elseif isequal(FieldName,'H'),
    FileNamex=fullfile(WorkingDir,Atta_Concept_HOutasc);
  end
  d=dir(FileNamex);
  if ~(isempty(d)||d.isdir),
    try
      x=load(FileNamex);
      F=x(:,[1,3,5])+j*x(:,[2,4,6]);
      Finished=true;
    catch
      Finished=false;
    end
  end
end

if Finished,
  fclose(fid);
  return
end

% read field vectors F at positions r:

n=0;
r=zeros(1e4,3);
F=zeros(1e4,3);

while ~feof(fid),
  x=lower(fgetl(fid));
  Ln=Ln+1;
  if ~isempty(strfind(x,rIndicator)),
    n=n+1;
    ii=find(x=='=')+1;
    if length(ii)~=3,
      error(['Inconsistent radius vector in line ',num2str(Ln)]);
    end
    for q=1:3,
      r(n,q)=sscanf(x(ii(q):end),'%e');
    end
    for q=1:3,
      ii=[];
      while ~feof(fid)&&isempty(ii),
        x=lower(fgetl(fid));
        Ln=Ln+1;
        ii=strfind(x,lower(char(Findicator+[0,q-1])));
      end
      if isempty(ii),
        error(['Unexpected end of file in line ',num2str(Ln),...
          ' reading ',num2str(n),'-th field vector.']);
      end
      ii=find((x=='=')|(x=='j'))+1;
      if length(ii)~=2,
        error(['Incorrect field data in line ',num2str(Ln),...
          ' reading ',num2str(n),'-th field vector.']);
      end
      F(n,q)=sscanf(x(ii(1):end),'%e')+j*sscanf(x(ii(2):end),'%e');
    end
  end
end

fclose(fid);

r=r(1:n,:);
F=F(1:n,:);

