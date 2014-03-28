
function F=Concept_Near(r,WorkingDir,Field)

% E=Concept_Near(r,DataDir,Field) calculates near field F generated 
% by the antenna system the currents of which already must have been 
% determined and the results stored in the directory WorkingDir.
% The field is calculated for the positions r. r is an n x 3 matrix
% each row of which gives a radius vector (n vectors present). 
% F is of same size, so F(m,:) is the electric field at the position r(m,:).
% Field is a string defining the field to be calculated: 'E' or 'H'.

global Atta_Concept_EHExe Atta_Concept_EHOut Atta_Concept_EHIn
global Atta_Concept_DelEHFiles Atta_Concept_EOutasc Atta_Concept_HOutasc

% -------------------------------------------------------------------------
% XXX adaptation to Concept-II-10 XXX
% KeyinputFile='EH1dKeyinput.dat';  % file for key input redirection

FieldNames='EH';

if ischar(Field),
  Field=strtrim(Field);
  Field=upper(Field(1));
  if isequal(Field,'E'),
    Field=1;
  elseif isequal(Field,'H'),
    Field=2;
  else
    Field=-1;
  end
end
if (Field~=1)&&(Field~=2),
  error('Wrong field identifier.');
end

if (size(r,2)~=3)||(ndims(r)~=2),
  error('Radius vectors must be 3-dimensional and stored as rows.');
end


% print message to screen:

Message=sprintf('Applying EH1d to calculate %c-field ... ',FieldNames(Field));
fprintf(Message);


% change to new directory if required:

if ~exist('WorkingDir','var')||isempty(WorkingDir),
  WorkingDir='';
end

if ~isempty(WorkingDir),
  SaveDir=pwd;
  try
    cd(WorkingDir);
  catch
    error(['Cannot change to directory "',WorkingDir,'".']);
  end
end


% create eh1d.in (input file for eh1d.exe):

fid=fopen(Atta_Concept_EHIn,'w');
if fid<0
  error('Could not open file eh1d.in');
end

fprintf(fid,'*** E field -> 1, H field -> 2, sar values ->3\n');
fprintf(fid,'%d\n',Field);
fprintf(fid,'*** Total number of lines\n');
fprintf(fid,'0\n');
fprintf(fid,'*** Field points from a file (y/n)\n');
fprintf(fid,'n\n');
fprintf(fid,'*** Total number of field points\n');
fprintf(fid,'%i\n',size(r,1));

for n=1:size(r,1),
  fprintf(fid,'*** Coordinates (x y z) for point %i\n',n);
  fprintf(fid,'%17.8e %17.8e %17.8e\n',r(n,1),r(n,2),r(n,3));
end

fclose(fid);

% call eh1d:

% -------------------------------------------------------------------------
% XXX adaptation to Concept-II-10 XXX

% fid=fopen(KeyinputFile,'w');
% fprintf(fid,'1\n');
% fclose(fid);

% [Status,Result]=dos([Atta_Concept_EHExe,' < ',KeyinputFile]);
[Status,Result]=dos([Atta_Concept_EHExe,' ',Atta_Concept_EHIn]);
% -------------------------------------------------------------------------

if Status~=0
  fprintf('failed.\n');
  error([Result,'.']);
end

% -------------------------------------------------------------------------
% XXX adaptation to Concept-II-10 XXX
% delete(KeyinputFile);


% read results of eh1d from eh1d.out or *.asc:

F=Concept_ReadField('');


% delete in- and output files if Atta_Concept_DelEHFiles:

if Atta_Concept_DelEHFiles,
  x={Atta_Concept_EHIn,Atta_Concept_EHOut,...
     Atta_Concept_EOutasc,Atta_Concept_HOutasc,'fort.89'};
  for n=1:length(x),
    if exist(x{n},'file'),
      delete(x{n});
    end
  end
end  


% go back to directory before call and remove message from screen:

if ~isempty(WorkingDir),
  cd(SaveDir);
end

fprintf(repmat('\b',1,length(Message)));

