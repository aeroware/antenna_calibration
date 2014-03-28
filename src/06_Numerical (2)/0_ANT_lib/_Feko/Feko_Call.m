
function [ResultFE,ResultBG,ResultBE]=Feko_Call(WorkingDir)

% Feko_Call(WorkingDir) calls prefeko and feko,
% to calculate the antenna currents, as well as the magnetic potential 
% fields and the far-field. The results are stored in antfile.out 
% ,main ascii output file.

global Atta_Concept_FE Atta_Concept_BG Atta_Concept_BE


if ~exist('WorkingDir','var')||isempty(WorkingDir),
  WorkingDir='';
end

if ~isempty(WorkingDir),
  SaveDir=pwd;
  try
    cd(WorkingDir);
  catch
    error(['Cannot change to working directory "',WorkingDir,'".']);
  end
end

% call front end:

Message='Calling prefeko... ';
fprintf(Message);

% -------------------------------------------------------------------------

 [Status,ResultFE]=dos('prefeko antfile.pre');
% -------------------------------------------------------------------------    

if Status~=0
  fprintf('failed.\n');
  error([ResultFE,'.']);
else
  fprintf(repmat('\b',1,length(Message)));
end

Message='Calling feko... ';
fprintf(Message);

[Status,ResultBG]=dos('runfeko antfile.fek -np 2 --parallel-authenticate localonly');

if Status~=0
  fprintf('failed.\n');
  error([ResultBG,'.']);
else
  fprintf(repmat('\b',1,length(Message)));
end

% go back to original directory:

if ~isempty(WorkingDir),
  cd(SaveDir);
end
