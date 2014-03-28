
function [ResultFE,ResultBG,ResultBE]=Concept_Call(WorkingDir)

% Concept_Call(WorkingDir) calls the Concept front end,
% 'buildgeo', and finally the Concept backend to calculate 
% antenna currents. The results are stored in a myriad of Concept 
% output files, the most important being 
% concept.out (main ascii output file), co_ili.bin (binary wire currents), 
% and co_ifl.bin (binary surface currents).

global Atta_Concept_FE Atta_Concept_BG Atta_Concept_BE

% redirection file for keyboard input to concept front end:

% -------------------------------------------------------------------------
% XXX adaptation to Concept-II-10 XXX
% ConceptfeKeyIn='ConceptfeKeyinput.dat'; 

Concept_FE_IN ='concept.in'; 

% change to working directory if required:

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

Message='Calling Concept front end... ';
fprintf(Message);

% -------------------------------------------------------------------------
% XXX adaptation to Concept-II-10 XXX
% fd=fopen(ConceptfeKeyIn,'w+');
% fprintf(fd,'\n\n14\n');
% fclose(fd);

%   [Status,ResultFE]=dos([Atta_Concept_FE,' < ',ConceptfeKeyIn]);    
  [Status,ResultFE]=dos([Atta_Concept_FE,' ',Concept_FE_IN]);
% -------------------------------------------------------------------------    

if Status~=0
  fprintf('failed.\n');
  error([ResultFE,'.']);
else
  fprintf(repmat('\b',1,length(Message)));
end
% -------------------------------------------------------------------------
% XXX adaptation to Concept-II-10 XXX
% delete(ConceptfeKeyIn);

% call geometry builder:

Message='Calling geometry builder... ';
fprintf(Message);

[Status,ResultBG]=dos(Atta_Concept_BG);
if Status~=0
  fprintf('failed.\n');
  error([ResultBG,'.']);
else
  fprintf(repmat('\b',1,length(Message)));
end

% call back end:

Message='Calling Concept back end... ';
fprintf(Message);

[Status,ResultBE]=dos(Atta_Concept_BE);
if Status~=0
  fprintf('failed.\n');
  error([ResultBE,'.']);
else
  fprintf(repmat('\b',1,length(Message)));
end

% go back to original directory:

if ~isempty(WorkingDir),
  cd(SaveDir);
end
