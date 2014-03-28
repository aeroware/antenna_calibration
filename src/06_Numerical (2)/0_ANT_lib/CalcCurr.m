
function Op=CalcCurr(PhysGrid,Freq,FeedNum,Titel,DataRootDir, er)

% Op=CalcCurr(PhysGrid,Freq,FeedNum,Titel)
% solves the boundary value problem for the currents on the given antenna
% structure PhysGrid, where the feeding is defined in FeedNum:
% FeedNum='all' causes simultaneous driving of all feeds as declared in
%   PhysGrid.Geom_.Feeds.Elem and/or PhysGrid.Desc_.Feeds.Elem, 
%   driven by the respective voltages 
%   PhysGrid.Geom_.Feeds.V and/or PhysGrid.Desc_.Feeds.V.
% If FeedNum passes a number, unit voltage at the feed with number FeedNum 
%   is applied, the other feeds being short-circuited, where
%   the counting is according to the order in the concatenation
%   [PhysGrid.Geom_.Feeds.Elem,PhysGrid.Desc_.Feeds.Elem]. 
%   The fields PhysGrid.Geom_.Feeds.V and PhysGrid.Desc_.Feeds.V
%   are ignored in this case.
% FeedNum='sys' solves consecutively for FeedNum=1,2,...;
%   this gives a whole current system which fully defines the behaviour of
%   the antenna system as part of an electronic circuit and the possible
%   reception and transmission states (from the resulting current system 
%   the antenna impedance matrix and the transfer matrices can be calculated).
% 
% The returned struct Op contains the calculated antenna currents
% (.Curr1 on wires and .Curr2 on surfaces; .Curr1b and .Curr2b wire and 
% surface bases definition), E-field normal to surface (.Ensurf), 
% exterior properties (.Exterior) and input parameters reread from 
% the output file (.Reread.Freq, .Reread.Exterior, etc.). 
% The array size of Op depends on the number of frequencies, ie.
% length(Freq), and the number of driving states to be observed: 
% the first dimension of Op counts the driving states (feeds), 
% the second the frequencies.
% For FeedNum='all' or numeric FeedNum (must be scalar) only one driving
% state is analysed, for FeedNum='sys' the number of driving states agrees
% with the number of feeds (as explained above).
%
% The string Titel is placed as a title at the beginning of the input files.
% 
% Op=CalcCurr(PhysGrid,Freq,FeedNum,Titel,DataRootDir) 
% defines also the directory DataRootDir which is the root of certain
% subdirectories where the calculations have to be performed, 
% i.e. where the input and output files are stored
% (default is the current directory).
% Actually a directory structure of the form
%   DataRootDir/solver/frequency/feed 
% is created for each frequency and driving type.
% For further info see the function GetDataSubdirs.
% 
% Note that all present files of the type DeleteFiles (defined in the
% beginning of the this function) are deleted before new input files are 
% generated for the following calculations.


% Old files to be deleted from the directory of output files 
% before calling Solver:
%
% Revision, 03.2011 by Thomas Oswald:
%   solver Feko implemented
%
% Revision, 06.2011 by Thomas Oswald:
%  er

DeleteFiles={'*.bin','*.o','*.out'};


if ~exist('DataRootDir','var')||isempty(DataRootDir),
  DataRootDir='';
end

if ~exist('Titel','var')||isempty(Titel),
  Titel='';
end

Op=struct('Freq',{});

% check FeedNum and applied voltages:

if ~exist('FeedNum','var')||isempty(FeedNum),
  FeedNum='sys';
end

if ischar(FeedNum),
  FeedNum=lower(FeedNum);
end

if ~isnumeric(FeedNum)&&~isequal(FeedNum,'sys')&&~isequal(FeedNum,'all'),
  error('Unknown FeedNum parameter encountered.');
end

if isequal(FeedNum,'sys'), 
  
  % determine the whole current system
  
  try
    q0=PhysGrid.Geom_.Feeds.Elem;
  catch
    q0=[];
  end
  
  try
    q1=PhysGrid.Desc_.Feeds.Elem;
  catch
    q1=[];
  end
  
  MaxFeedNum=length(q0)+length(q1);
  if MaxFeedNum<1,
    error('No feeds found.');
  end
  
  for nf=1:length(Freq),
    for FeedNum=1:MaxFeedNum,
      Opx=CalcCurr(PhysGrid,Freq(nf),FeedNum,Titel,DataRootDir,er);
      Op=SetStruct(Op,Opx,{FeedNum,nf},{1,1});
    end  
  end
  
  return

elseif isequal(FeedNum,'all'),

  % perform some checks if all feeds are to be driven:
  
  try
    SegmFeeds=PhysGrid.Desc_.Feeds.Elem(:);
    NodeFeeds=PhysGrid.Geom_.Feeds.Elem(:);
    SegmV=PhysGrid.Desc_.Feeds.V(:);
    NodeV=PhysGrid.Geom_.Feeds.V(:);
  catch
    error('Incorrect feed definition in antenna grid.');
  end
  
  if isequal(CheckSolver(PhysGrid.Solver),CheckSolver('CONCEPT')),
    if ~isempty(NodeFeeds)||~isempty(NodeV),
      error('Node feeds are not allowed for Concept calculation.');
    end
  end
  
  if length(SegmFeeds)~=length(SegmV),
    error('The number of segment voltages does not agree with feeds.');
  end
  
  if length(NodeFeeds)~=length(NodeV),
    error('The number of node voltages does not agree with feeds.');
  end

end


% Frequency loop:
% ---------------

for nf=1:length(Freq),
  
  % subdirectories of DataRootDir dependent on solver, frequency and FeedNum

  [SolverDir,FreqDir,FeedDir]=...
    GetDataSubdirs(DataRootDir,PhysGrid.Solver,Freq(nf),FeedNum,1);  

  % delete old files:
  
  fclose all;
  try
    for n=1:length(DeleteFiles),
      Filn=fullfile(FeedDir,DeleteFiles{n});
      d=dir(Filn);
      if ~isempty(d),
        delete(Filn);
      end
    end
  catch
    error(['Error occured while trying to delete "',Filn,'".']);
  end

  % display solver, frequency and feed on screen
  
  if ~isempty(lastwarn),
    fprintf('\n');
    lastwarn('');
  end

  if isnumeric(FeedNum),
    Message=sprintf('Solver=%s, f = %g kHz, driven feed = %d \n',...
      CheckSolver(PhysGrid.Solver),Freq(nf)/1e3,FeedNum);
  else
    Message=sprintf('Solver=%s, f = %g kHz, all feeds driven \n',...
      CheckSolver(PhysGrid.Solver),Freq(nf)/1e3);
  end
  
  fprintf(Message);
  
  % generate input files, call solver and read output (result) files

  if isequal(CheckSolver(PhysGrid.Solver),CheckSolver('CONCEPT')),
    Op=Concept_Curr(PhysGrid,Freq(nf),FeedNum,FeedDir,Titel);
  elseif isequal(CheckSolver(PhysGrid.Solver),CheckSolver('ASAP')),
    Op=Asap_Curr(PhysGrid,Freq(nf),FeedNum,FeedDir,Titel);
  elseif isequal(CheckSolver(PhysGrid.Solver),CheckSolver('FEKO')),
    Feko_Curr(PhysGrid,Freq(nf),FeedNum,FeedDir,Titel,er);
  elseif isequal(CheckSolver(PhysGrid.Solver),CheckSolver('NEC')),
    Nec_Curr(PhysGrid,Freq(nf),FeedNum,FeedDir,Titel,er);
  else  
    error('Unknown Solver declaration in grid-struct.')
  end
  
  if ~exist('Op','var')
      Op=struct([]);
  end % if
  
  Op(1,nf).Freq=Freq(nf);
  
  Op(1,nf).Exterior.epsr=EvaluateFun(PhysGrid.Exterior.epsr,Freq(nf));
  Op(1,nf).Vfeed=GetFeedVolt(PhysGrid,FeedNum);
  Op(1,nf).Ifeed=GetFeedCurr(PhysGrid,Op(1,nf),FeedDir);  
end


