%   PlotAllJunoAntennas is a script that plots all antennas of the
%   Juno model
%
%   the colors of the three electric antennas are red, green, blue
%   the direction of the wave is the negative z-axis

clear

f=3e5;
patches=0;
titl='Juno Preel.';
solver=1;
asapexe='Asap3g.exe';
CurrentFile=strcat('..\JunoData\Currents.mat');
force=1;
usecaps=0;
epsilonr=1;
mer=1;
config=1;
angle=120;
zeta=120;

er=[0,0,-1];

%mer=input('Merge figures ? (0=no, 1=yes)')

% load model

dh=figure
   
ant=CreateJunoGrid(config,angle,zeta);
                      
for(n=1:length(f))
    if(force==0)
        OP=VarLoad(CurrentFile,3e5/1e3,'OP'); 
   
        if(isempty(OP))
            OP=JunoCurrent(3e5,ant,solver,asapexe, titl,patches,epsilonr);
            VarSave(CurrentFile,OP,3e5/1e3,'OP');
        end % if
    else
        OP=JunoCurrent(3e5,ant,solver,asapexe, titl,patches,epsilonr);
        VarSave(CurrentFile,OP,3e5/1e3,'OP');
    end
    
        % capacitances
        
    caps=eye(2)./90e-12;
        
    if ~mer
        dh=figure;
    end

    if(solver==2)
        PlotJunoAntennae(ant,OP,er,solver,dh,0,i,1,1,'-',usecaps,caps,0,mer); 
    else
        PlotJunoAntennae(ant,OP,er,solver,dh,0,i,1,1,'-',usecaps,caps,1,mer);
    end

    PlotJunoAntennae(ant,OP,er,solver,dh,0,0,1,1,'-',1,caps,0,mer); 
end %for all frequencies      

title(strcat('Physical and electrical Antennas of the Juno Model at ',num2str(f(1)/1e3) ,' kHz and a direction of incidence from the negative z-axis'))

xlabel('X-Axis')
ylabel('Y-Axis')
zlabel('Z-Axis')

axis equal;

OP