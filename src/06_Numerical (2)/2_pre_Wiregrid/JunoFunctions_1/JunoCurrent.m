function op=JunoCurrent(f, ant, solver,asapexe,titl,patches,epsilonr)

% Calculation of antenna currents for 
% Juno / WAVES antenna models
% f=frequency
% =========================================


% ---------------------
% prepare calculations:
% ---------------------


if solver==1 % asap
    op.Feed=ant.Feed(:);  
    op.Exte=[0,1];               % conductivity, rel. dielectric constant
    op.Inte=50;                   % integration steps
    op.EpsilonR=epsilonr;

    AIF='..\JunoData\AsapIn.dat';     % ASAP input files

    AOF='..\JunoData\AsapOut.dat';     % ASAP output files

    AIFC={'************************************************',...
        'ASAP current calculations for Juno GridFile',...
        ['''', titl,''''],...
        '************************************************'};

    % ----------------------------------------
    % calculate currents and save Op to file:
    % ----------------------------------------

    for n=1:length(f)
        op.Freq=f(n);
        fprintf(1,'\nFrequency: %4.f kHz\n',op.Freq/1e3);
        opOut(n)=AntCurrent(ant,op,2,AIF,AOF,AIFC,solver,asapexe,titl);
    end     % for all frequencies
else % concept
    op.Feed=ant.Feed(:);    
    op.SegFeeds=ant.SegFeeds(:);
    op.Exte=[0,1];               % conductivity, rel. dielectric constant
    op.Inte=50;                   % integration steps
    op.EpsilonR=epsilonr;

   

    % ----------------------------------------
    % calculate currents and save Op to file:
    % ----------------------------------------

    for n=1:length(f)
        op.Freq=f(n);
        fprintf(1,'\nFrequency: %4.f kHz\n',op.Freq/1e3);
        opOut(n)=AntCurrent(ant,op,2,'','','',solver,asapexe,titl,patches);
    end     % for all frequencies
end %concept

op=opOut;