
function Op=Asap_Curr(PhysGrid,Freq,FeedNum,WorkingDir,Titel,AddCards)

% Op=Asap_Curr(PhysGrid,Freq,FeedNum,WorkingDir,Titel) uses ASAP to
% calculate currents on antenna grid PhysGrid when driven at the 
% frequency Freq as specified by FeedNum. Titel defines a comment 
% added at the beginning of the ASAP input and output files.
% The calculations are done in the directory WorkingDir (default is
% the current directory).

if ~exist('Titel','var')||isempty(Titel),
  Titel='';
end

if ~exist('AddCards','var')||isempty(AddCards),
  AddCards='';
end

if ~exist('WorkingDir','var')||isempty(WorkingDir),
  WorkingDir='';
end

Asap_CreateIn(PhysGrid,Freq,FeedNum,Titel,WorkingDir,AddCards);

Asap_Call(WorkingDir);

Op=Asap_ReadOut(WorkingDir);


