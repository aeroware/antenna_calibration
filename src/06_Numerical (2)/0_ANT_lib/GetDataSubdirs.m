
function [SolverDir,FreqDir,FeedDir]=...
  GetDataSubdirs(DataRootDir,Solver,Freq,FeedNum,GenerateDirs)

% [SolverDir,FreqDir,FeedDir]=...
%   GetDataSubdirs(DataRootDir,Solver,Freq,FeedNum)
% determines the subdirectories for data of given Solver, 
% frequency Freq and feed number FeedNum.
% In the subdirectory FreqDir all data which are specific for a certain 
% frequency are stored, where in the subsubdirectory FeedDir the data 
% specific to a certain driven feed  are stored. FeedNum may be 'all' or a
% scalar. Usually FeedDir is a subdirectory of FreqDir, and FreqDir a 
% subdirectory of SolverDir.
%
% The formats for the names of the (sub)directories are declared 
% in the global variables Atta_SolverDirFormat, Atta_FreqDirFormat,
% Atta_FeedDirFormat and Atta_FeedDirAlldrivenand.
%
% [...]=GetDataSubdirs(DataRootDir,Solver,Freq,FeedNum,1)
% also creates the directories down to the FeedDir if not yet present.

global Atta_SolverDirFormat Atta_FreqDirFormat
global Atta_FeedDirFormat Atta_FeedDirAlldriven

SolverName=CheckSolver(Solver);

SolverDir=fullfile(DataRootDir,sprintf(Atta_SolverDirFormat,SolverName));
CreateDir=SolverDir;

if nargout>1,

  FreqDir=fullfile(SolverDir,sprintf(Atta_FreqDirFormat,Freq/1e3));
  CreateDir=FreqDir;
  
  if nargout>2,
    
    if isnumeric(FeedNum),
      FeedDir=fullfile(FreqDir,sprintf(Atta_FeedDirFormat,FeedNum));
    else
      FeedDir=fullfile(FreqDir,Atta_FeedDirAlldriven);
    end
    CreateDir=FeedDir;
    
  end
  
end

if exist('GenerateDirs','var')&&~isempty(GenerateDirs),
  
  if ~exist(CreateDir,'dir'),
    Success=mkdir(CreateDir);
    if ~Success,
      error(['Could not create directory "',CreateDir,'".']);
    end
  end
  
end
