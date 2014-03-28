
function [To,Z]=CalcTo(er,PhysGrid,Op,DataRootDir,Method)

% To=CalcTo(er,PhysGrid,Op,DataRootDir) and
% To=CalcTo(er,Solver,Freq,DataRootDir)
% work like CalcTs (see there), except that the open-port transfer
% matrix To is returned instead of the short-circuit one (Ts).
%
% [To,Z]=CalcTo(...) additionally returns the antenna impedance matrix Z,
% which is also needed for the determination of the transfer matrix of
% the loaded antenna system (by means of To2T).

global Atta_ToFileName

if ~exist('DataRootDir','var')||isempty(DataRootDir),
  DataRootDir='';
end

if ~exist('Method','var')||isempty(Method),
  Method='';
end

% determine Ts and Y, and store it into To and Z, resp.:

[To,Z]=CalcTs(er,PhysGrid,Op,DataRootDir,Method);

% determine Z=inv(Y) and use it to calculate To=Z*Ts:

NDirs=size(To,3);
NFreqs=size(To,4);

if isstruct(Op),
  Freqs=[Op(1,:).Freq];
else
  Freqs=Op;
end
if length(Freqs)~=NFreqs,
  error('Inconsistent number of frequencies.');
end

if isstruct(PhysGrid)
  Solver=PhysGrid.Solver;
else
  Solver=PhysGrid;
end

for n=1:NFreqs,  
    
  Z(:,:,n)=inv(Z(:,:,n));
  for m=1:NDirs,
    To(:,:,m,n)=Z(:,:,n)*To(:,:,m,n);
  end
  
  [SolverDir,FreqDir]=GetDataSubdirs(DataRootDir,Solver,Freqs(n));
    
  if ~isempty(Atta_ToFileName),
    VarSave(fullfile(FreqDir,Atta_ToFileName),To(:,:,:,n),[],'To');
    VarSave(fullfile(FreqDir,Atta_ToFileName),er,[],'er');
    VarSave(fullfile(FreqDir,Atta_ToFileName),Z(:,:,n),[],'Z');
  end
  
end

