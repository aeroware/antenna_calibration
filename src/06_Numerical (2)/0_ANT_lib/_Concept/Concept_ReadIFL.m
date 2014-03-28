 
function Op=Concept_ReadIFL(Nbases,Nfreqs,Workingdir)

% Op=Concept_ReadIFL(Nbases,Nfreqs,Workingdir) reads the surface
% currents Op.Curr2 from the Concept binary output file co_ifl.bin,
% expecting that it is in the directory Workingdir 
% (default is the current directory).
% Nbases is the total number of surface basis functions.
% Nfreqs is the number of current sets to be read (1 set per frequency), 
% default is to read all. 
% Op.Curr2 returns a vector of surface current amplitudes.

NumberType='double';   % binary type of numbers in file
NumberSize=8;          % bytes of memory needed per number

IFL='co_ifl.bin';

if ~exist('Workingdir','var')||isempty(Workingdir),
  Workingdir='';
end
IFL=fullfile(Workingdir,IFL);
d=dir(IFL);
if isempty(d),
  error(['File ',IFL,' not found.']);
end

if ~exist('Nfreqs','var')||isempty(Nfreqs),
  Nfreqs=round(d.bytes/NumberSize/Nbasis/4);
end

if ~exist('Nbases','var')||isempty(Nbases),
  error('Number of basis functions per segment not defined.');
end


fid=fopen(IFL,'rb');

Op(1,Nfreqs).Curr2=zeros(1,3);

for n=1:Nfreqs,
  x=fread(fid,2*Nbases,NumberType);
  x=x(:);
  Op(n).Curr2=x(1:2:end-1)+i*x(2:2:end);
end

fclose(fid);

