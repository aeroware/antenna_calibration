function OP=DipolCurrent(f, ant, solver,asapexe,titl,epsilonr, nec2bin)

% Calculation of antenna currents for 
% Dipole antenna models
% f=frequency
%
% Nov. 2010 by Thomas Oswald
% =========================================



% ---------------------
% prepare calculations:
% ---------------------

Op.Feed=ant.Feed(:);
Op.Exte=[0,epsilonr];    % conductivity, rel. dielectric constant

switch solver
    case 1  % asap  
        Op.Inte=50;      % integration steps
    case 2 % concept
        Op.SegFeeds=ant.SegFeeds(:);
    case 3 % nec2
        Op.SegFeeds=ant.SegFeeds(:);
end % switch

 % ----------------------------------------
 % calculate currents and save Op to file:
 % ----------------------------------------
    
for n=1:length(f)
    Op.Freq=f(n);
    fprintf(1,'\nFrequency: %4.f kHz\n',Op.Freq/1e3);
  
    OpOut(n)=AntCurrent(ant,Op,2,solver,asapexe,titl,0,nec2bin);
end     % for all frequencies

OP=OpOut;