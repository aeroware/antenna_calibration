
function PhysGrid=LoadPhysGrid(DataRootDir,Solver)

% PhysGrid=LoadPhysGrid(DataRootDir,Solver)
% loads physical grid PhysGrid from the respective directory, which 
% is defined by the data root directory DataRootDir and the Solver.

global Atta_PhysGridFile Atta_PhysGridName

SolverDir=GetDataSubdirs(DataRootDir,Solver);

PhysGrid=VarLoad(fullfile(SolverDir,Atta_PhysGridFile),[],Atta_PhysGridName);

