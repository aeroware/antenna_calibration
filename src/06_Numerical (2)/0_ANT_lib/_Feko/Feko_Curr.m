
function Feko_Curr(PhysGrid,Freq,FeedNum,WorkingDir,Titel,er)

% Feko_Curr(PhysGrid,Freq,FeedNum,WorkingDir,Titel, er) uses Feko to
% calculate currents on antenna grid PhysGrid when driven at the 
% frequency Freq as specified by FeedNum. Titel defines the title 
% added at the beginning of the input and file.
% The calculations are done in the directory WorkingDir (default is
% the current directory).

if ~exist('Titel','var')||isempty(Titel),
  Titel='';
end

if ~exist('WorkingDir','var')||isempty(WorkingDir),
  WorkingDir='';
end

%   set er to the correct distance

r=FieldZones(Freq, PhysGrid);

l=sqrt(dot(er,er,2));
f=2*r./l;

er(:,1)=er(:,1).*f;
er(:,2)=er(:,2).*f;
er(:,3)=er(:,3).*f;

Feko_CreateIn(PhysGrid,Freq,FeedNum,Titel,WorkingDir, er);
Feko_Call(WorkingDir);
%Op=Feko_ReadAll(WorkingDir);

