 
function Op=Concept_ReadILI(Nsegs,Nbases,Nfreqs,WorkingDir)

% Op=Concept_ReadILI(Nsegs,Nbases,Nfreqs,WorkingDir) reads the wire
% currents Op.Curr1 from the Concept binary output file co_ili.bin,
% expecting that it is in the directory WorkingDir (default is the current 
% directory).
% Nfreqs is the number of current sets (1 set per frequency), 
% default is to read all. 
% Nsegs is the number of segments in the wire grid, Nbases the number of 
% basis functions per segment (a vector giving the number of basis 
% funcion for each segment, or a scalar in case all segments have the 
% same number of basis functions). 
% Op.Curr1 returns a cell vector, each element of which contains 
% one current set.

NumberType='double';   % binary type of numbers in file
NumberSize=8;          % bytes of memory needed per number
NumbersPerFreq=20000;  % allocated numbers per frequency 
% ! adapt NumbersPerFreq if necessary, it is JSP7/NumberSize, where JSP7 is 
% defined in the Concept program directory in the file 
% $CONCEPT\hfiles\dr_par.inc
% (JSP7 is the number of bytes reserved per frequency)

ILI='co_ili.bin';

if ~exist('WorkingDir','var')||isempty(WorkingDir),
  WorkingDir='';
end
ILI=fullfile(WorkingDir,ILI);
d=dir(ILI);
if isempty(d),
  error(['File ',ILI,' not found.']);
end

if ~exist('Nfreqs','var')||isempty(Nfreqs),
  Nfreqs=round(d.bytes/NumberSize/NumbersPerFreq);
end

if ~exist('Nsegs','var')||isempty(Nsegs),
  error('Number of segments not defined.');
end

if ~exist('Nbases','var')||isempty(Nbases),
  error('Number of basis functions per segment not defined.');
end
if length(Nbases)==1,
  Nbases=repmat(Nbases,Nsegs,1);
end
SumNbases=sum(Nbases);


fid=fopen(ILI,'rb');

Op(1,Nfreqs).Curr1={};

for n=1:Nfreqs,
  for s=1:Nsegs,
    x=reshape(fread(fid,2*Nbases(s),NumberType),[2,Nbases(s)]);
    Op(n).Curr1{s,1}=x(1,:)+i*x(2,:);
  end
  if n~=Nfreqs,
    fread(fid,NumbersPerFreq-2*SumNbases,NumberType);
  end
end

fclose(fid);

