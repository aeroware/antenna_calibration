
function Op=Concept_Curr(PhysGrid,Freq,FeedNum,WorkingDir,Titel)

% Op=Concept_Curr(PhysGrid,Freq,FeedNum,WorkingDir,Titel) uses Concept to
% calculate currents on antenna grid PhysGrid when driven at the 
% frequency Freq as specified by FeedNum. Titel defines the title 
% added at the beginning of the Concept input and output files.
% The calculations are done in the directory WorkingDir (default is
% the current directory).

if ~exist('Titel','var')||isempty(Titel),
  Titel='';
end

if ~exist('WorkingDir','var')||isempty(WorkingDir),
  WorkingDir='';
end

Concept_CreateIn(PhysGrid,Freq,FeedNum,Titel,WorkingDir);

Concept_Call(WorkingDir);

Op=Concept_ReadAll(WorkingDir);

