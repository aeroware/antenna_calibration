
function [T,er,YZ]=LoadT(DataRootDir,Solver,Freqs,FileName)

% [T,er,YZ]=LoadT(DataRootDir,Solver,Freqs,FileName)
% loads transfer matrices (T) from files with name FileName in the
% respective frequency directories which are determined by the 
% data root directory DataRootDir, the Solver and the frequencies Freqs.  
% er are the directions for which the T-matrices are loaded. It is assumed
% that er is the same for all frequencies. YZ returns either Y or Z,
% whichever is stored in the file (if both are in the file, Z is returned).

global Atta_Solver_Names

if ~exist('DataRootDir','var')||isempty(DataRootDir),
  DataRootDir='';
end

Solver=CheckSolver(Solver);
if ~any(ismember(Solver,Atta_Solver_Names)),
  error('Passed Solver not known.');
end

if ~exist('FileName','var')||isempty(FileName),
  error('No file name defined.');
end


NFreqs=numel(Freqs);

for n=1:NFreqs,
  
   [SolverDir,FreqDir]=GetDataSubdirs(DataRootDir,Solver,Freqs(n));
   FN=fullfile(FreqDir,FileName);
   v=load(FN);
   
   na=fieldnames(v);
   m=strmatch('T',na);
   if length(m)~=1,
     error('No or several T-candidates found for frequency = %fkHz.\n',...
       Freqs(n)/1e3);
   end
   nam=na{m};
   
   if n==1,
     NFeeds=size(v.(nam),1);
     NDirs=size(v.(nam),3);
     T=zeros(NFeeds,3,NDirs,NFreqs);
     YZ=zeros(NFeeds,NFeeds,NFreqs);
     er=v.er;
     isZ=isfield(v,'Z');
   end

   T(:,:,:,n)=v.(nam);
   
   if isZ,
     YZ(:,:,n)=v.Z;
   else
     YZ(:,:,n)=v.Y;
   end
    
end

