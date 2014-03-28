
function [SolverName,SolverId]=CheckSolver(Solver)

% [SolverName,SolverId]=CheckSolver(Solver)
% returns the exact name of the given Solver. Solver may
% be an abbreviation of the Solver name or the solver id. The latter is
% simply the index number under which the solver appears in the global
% variable Atta_Solver_Names. This variable declares the exact names of all
% implemented solvers. If the Solver is not recognized, SolverName='' and
% SolverId=0 is returned. 

global Atta_Solver_Names

n=length(Atta_Solver_Names);

if ischar(Solver),  % string passed
  
  e=zeros(n,1);

  Solver=Solver(~isspace(Solver));
  for m=1:n,
    so=upper(char({Solver,Atta_Solver_Names{m}}));
    e(m)=sum(so(1,:)==so(2,:));
  end
  
  [eii,ii]=sort(e,1,'descend');
  
  if eii(1)<1,
    SolverName='';
    SolverId=0;
  else
    if eii(1)==eii(2),
      warning('Solver not uniquely identified.');
    end
    SolverId=ii(1);
    SolverName=Atta_Solver_Names{SolverId};    
  end
  
else  % solver-id passed
  
  if (Solver<1)||(Solver>n),
    SolverName='';
    SolverId=0;
  else
    SolverId=round(Solver);
    SolverName=Atta_Solver_Names{SolverId};    
  end
  
end    
  

