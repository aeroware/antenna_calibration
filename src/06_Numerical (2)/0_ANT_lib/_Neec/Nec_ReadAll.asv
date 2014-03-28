
function Op=Nec_ReadAll(WorkingDir)

% Op=Nec_ReadAll(WorkingDir)
% reads all currents from the Nec output file antfile.out;

if ~exist('WorkingDir','var')||isempty(WorkingDir),
  WorkingDir='';
end

% read concept.out:

Op=Feko_ReadOut(WorkingDir);

% now read wire and surface currents again,
% this time from binary files to improve accuracy:

Nsegs=length(Op.Curr1);
Nsegbases=cellfun(@length,Op.Curr1);
% may be different from PhysGrid.Desc_.NBases, CONCEPT changes it if
% 1. there were not enoungh bases per wavelenght;
% 2. there is a feed or load in the middle of a segment with an even
%    number of bases, then the number is de- or (mostly) increased by 1

Nfreqs=length(Op);

% read wire currents from ili.bin:

OpIli=Concept_ReadILI(Nsegs,Nsegbases,Nfreqs,WorkingDir);
for nf=1:Nfreqs,
  Op(nf).Curr1=OpIli(nf).Curr1;
end

SurfBases=length(Op.Curr2);

if SurfBases==0,
  if nargout>1,
    Surf0Grid.Geom=zeros(0,3);
    Surf0Grid.Desc2d={};
  end
  return
end

% read surface currents from ifl.bin:

OpIfl=Concept_ReadIFL(SurfBases,Nfreqs,WorkingDir);
for nf=1:Nfreqs,
  Op(nf).Curr2=OpIfl(nf).Curr2;
end

