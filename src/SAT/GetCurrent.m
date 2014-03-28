function OP=GetCurrent(f, ant, solver,asapexe,titl,patches)

% Calculation of antenna currents for 
% Juno / WAVES antenna models
% f=frequency
% =========================================


% ---------------------
% prepare calculations:
% ---------------------


if solver==1 % asap
    Op.Feed=ant.Feed(:);  
    Op.Exte=[0,1];               % conductivity, rel. dielectric constant
    Op.Inte=50;                   % integration steps

    AIF='..\JunoData\AsapIn.dat';     % ASAP input files

    AOF='..\JunoData\AsapOut.dat';     % ASAP output files

    AIFC={'************************************************',...
        'ASAP current calculations for ',...
        ['''', titl,''''],...
        '************************************************'};

    % ----------------------------------------
    % calculate currents and save Op to file:
    % ----------------------------------------

    for n=1:length(f)
        Op.Freq=f(n);
        fprintf(1,'\nFrequency: %4.f kHz\n',Op.Freq/1e3);
        OpOut(n)=AntCurrent(ant,Op,2,AIF,AOF,AIFC,solver,asapexe,titl);
    end     % for all frequencies
else % concept
    Op.Feed=ant.Feed(:);    
    Op.SegFeeds=ant.SegFeeds(:);
    Op.Exte=[0,1];               % conductivity, rel. dielectric constant
    Op.Inte=50;                   % integration steps

   

    % ----------------------------------------
    % calculate currents and save Op to file:
    % ----------------------------------------

    for n=1:length(f)
        Op.Freq=f(n);
        fprintf(1,'\nFrequency: %4.f kHz\n',Op.Freq/1e3);
        OpOut(n)=AntCurrent(ant,Op,2,'','','',solver,asapexe,titl,patches);
    end     % for all frequencies
end %concept

OP=OpOut;