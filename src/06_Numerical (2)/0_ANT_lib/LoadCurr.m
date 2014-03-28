
function Op=LoadCurr(DataRootDir,PhysGrid,Freqs,FeedNum)

% Op=LoadCurr(DataRootDir,Solver,Freqs,FeedNum)
% loads the currents from the directory where they are saved. This
% directory depends on the DataRootDir (data root directory), the Solver,
% the frequencies (Freqs) and the feed numbers FeedNum. 
% DataRootDir is a string containing the name of the data root directory,
% Solver a string or number identifying the solver,
% Freqs a scalar or vector of frequencies, and
% FeedNum a string ('all' or 'sys') or a feed number ('sys' is default if
% the parameter FeedNum is not passed or empty):
% FeedNum='all' means that all feeds are driven by applying the voltages
% defined in the antenna grid structure. 
% FeedNum='sys' regards as many driving (operation) situations as there are
% feeds defined in the antenna grid structure, an individual driving state 
% being realized by applying unit voltage at one feed, the other feeds being
% short-circuited. This yields a whole current system, which is ,e.g., 
% needed to determine the transfer and impedance matrices.
%
% The read currents are stored in Op as explained in CalcCurr.
% Op is a (number of feeds times number of frequencies)-array, each element
% of the array holding the antenna currents induced on the antenna when
% driven according to the feed specification at the respective frequency.
%
% Op=LoadCurr(DataRootDir,PhysGrid,Freqs,FeedNum)
% If the whole PhysGrid antenna struct is passed instead of the Solver, 
% the function returns in Op also the fields .Exterior.epsr, 
% .Vfeed and .Ifeed, which can only be determined on the basis of PhysGrid.

global Atta_Solver_Names

if ~exist('DataRootDir','var')||isempty(DataRootDir),
  DataRootDir='';
end

if isstruct(PhysGrid),
  Solver=PhysGrid.Solver;
else
  Solver=PhysGrid;
  PhysGrid=[];
end
  
Solver=CheckSolver(Solver);
if ~any(ismember(Solver,Atta_Solver_Names)),
  error('Passed Solver not known.');
end

% check FeedNum:

if ~exist('FeedNum','var')||isempty(FeedNum),
  FeedNum='sys';
end
if ischar(FeedNum),
  FeedNum=lower(FeedNum);
end
if ~isnumeric(FeedNum)&&~isequal(FeedNum,'sys')&&~isequal(FeedNum,'all'),
  error('Unknown FeedNum parameter encountered.');
end

% check number of feeds in case whole current system is to be loaded:

if isequal(FeedNum,'sys'), 

  NFeeds=zeros(length(Freqs),1);
  
  for n=1:length(Freqs),
    FeedExists=1;
    while FeedExists,
      [SolverDir,FreqDir,FeedDir]=...
        GetDataSubdirs(DataRootDir,Solver,Freqs(n),NFeeds(n)+1);
      FeedExists=exist(FeedDir,'dir');
      if FeedExists,
        NFeeds(n)=NFeeds(n)+1;
      end
    end    
  end

  if ~all(NFeeds(1)==NFeeds)||any(NFeeds<1),
    error('Inconsistent feed numbers/frequencies, current systems cannot be loaded.');
  end
  
  FeedNum=1:NFeeds(1); 

end

if ischar(FeedNum),
  NFeeds=1;
else
  NFeeds=length(FeedNum);
end


% Frequencies-feeds loop:
% -----------------------

Op=struct('Freq',{});

for n=1:length(Freqs),
  
  for m=1:NFeeds,
    
    if ischar(FeedNum),
      FN=FeedNum;
    else
      FN=FeedNum(m);
    end
    
    [SolverDir,FreqDir,FeedDir]=...
      GetDataSubdirs(DataRootDir,Solver,Freqs(n),FN);
      
    if isequal(Solver,CheckSolver('CONCEPT')),
      Opx=Concept_ReadAll(FeedDir);
    elseif isequal(Solver,CheckSolver('ASAP')),
      Opx=Asap_ReadOut(FeedDir);
    end

    Op=SetStruct(Op,Opx,{m,n},{1,1});

    Op(m,n).Freq=Freqs(n);
      
    if ~isempty(PhysGrid),
      Op(m,n).Exterior.epsr=EvaluateFun(PhysGrid.Exterior.epsr,Freqs(n));
      Op(m,n).Vfeed=GetFeedVolt(PhysGrid,FN);
      Op(m,n).Ifeed=GetFeedCurr(PhysGrid,Op(m,n));
    end

  end % count feeds

end % count frequencies

