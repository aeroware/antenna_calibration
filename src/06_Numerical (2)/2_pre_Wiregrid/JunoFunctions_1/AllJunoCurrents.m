%   AllJunoCurrents calculates and saves the currents of the Juno model
%
%   Written in spring 2007 by Thomas Oswald
%   ref. code. 837647326728-11

% parameters

f=1e5;
patches=0;
titl='Juno';
solver=2;
asapexe='Asap3g.exe';
CurrentFile=strcat('Currents.mat');
epsilonr=1;

% Create model(default configuration)

ant=CreateJunoGrid;

% loop for all frequencies

for(n=1:length(f))
    fprintf('\n\n\nNew Calculation !\nFrequency = %d\n',f(n));
    
    if patches
        ant=Wire2Patch(ant,titl);
    end
            
    % compute currents
    
    OP=JunoCurrent(f(n),ant,solver,asapexe, titl,patches,epsilonr);
    
    % save currents
    
    VarSave(CurrentFile,OP,f(n)/1e3,'OP');  
end % for all currents
    

