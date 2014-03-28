%   MakeTable is a script which produces a table for two different
%   configurations of the Juno spacecraft. The table shoes the length of
%   the effective axes and the angle between the two antennas as function
%   of the input parameters, which are the angle between the two physical
%   antennas and the angle of the plane of the two physical antennas in
%   relation to the z axis.
%   
%   The script uses only open feeds at the moment. The table is stored in
%   the file JunoTab.txt
%
%   It was written by Thomas Oswald, March,2007

clear

f=3e5;
patches=0;
titl='Juno 4';
asapexe='Asap3g.exe';
usecaps=0;
epsilonr=1;

er=[0,0,-1];


% load model

fh=fopen('JunoTab5.txt','w');
fprintf(fh,'Tabulated values of the length of the effective length\n');
fprintf(fh,'vectors, the angle between the two effective length\n');
fprintf(fh,'vectors, and the colatitude of the plane of the effective length\n');
fprintf(fh,'vectors as a function of the configuration, the angle between\n');
fprintf(fh,'the physical antennas and the angle between the z-axis and\n');
fprintf(fh,'the plane of the antennas.\n\n');
fprintf(fh,'Configuration 1 means that the antennas are located below a\n');
fprintf(fh,'solar panel, while at configuration 2 the antennas are located\n');
fprintf(fh,'between two solar panels.\n\n\n');


for solver=1:2
    if(solver==1)
        fprintf(fh,'Calculated with ASAP\n\n');
    else
        fprintf(fh,'Calculated with CONCEPT\n\n');
    end
    for config=1:2
        fprintf(fh,'Configuration %.0f\n\n',config);
        fprintf(fh,'Angle-->                90                   95                  100                 105                 110                 115                 120\n\n'); 
    for zeta=120:5:135
        fprintf(fh,'Theta: %.0f\t',zeta);
        for angle=90:5:120
            ant=CreateJunoGrid(config,angle,zeta);                
            op=JunoCurrent(f,ant,solver,asapexe, titl,patches,epsilonr);
    
        % compute heff
        
            heff=AntTransferx(ant,op,er,solver,0,0)
            l=norm(heff(1,:),'fro');
            ang1 = acos(heff(1,:)*heff(2,:)'/(norm(heff(1,:),'fro')*norm(heff(2,:),'fro')))*180/pi;
            vec=(heff(1,:)+heff(2,:))/2;
            ang2= acos(vec*[0,0,1]'/(norm(vec,'fro')))*180/pi;
            fprintf(fh,'%4.3fm/%4.1f°/%4.1f°\t',l,ang1,ang2);
        end % for all angles
        fprintf(fh,'\n\n');
    end % for all zetas
end % for all configs
end %for all solvers
        
fclose(fh);
    