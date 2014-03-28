%   ComputeHeff is a script which produces a table for two different
%   configurations of the Juno spacecraft. The table shoes the length of
%   the effective axes and the angle between the two antennas as function
%   of the input parameters, which are the angle between the two physical
%   antennas and the angle of the plane of the two physical antennas in
%   relation to the z axis.
%   
%   The script uses only open feeds at the moment. The output is written to
%   the screen.
%
%   It was written by Thomas Oswald, May,2007

clear

f=3e5;
patches=0;
titl='Juno 3';
asapexe='Asap3g.exe';
usecaps=0;
epsilonr=1;

er=[0,0,-1];

subtended=120;
theta=160;


% load model



for solver=1:2
    if(solver==1)
        fprintf('Calculated with ASAP\n\n');
    else
        fprintf('Calculated with CONCEPT\n\n');
    end
    for config=1:2
        fprintf('Configuration %.0f\n\n',config);
        fprintf('Theta: %.0f\t',theta);
        
        ant=CreateJunoGrid(config,subtended,theta);                
        op=JunoCurrent(f,ant,solver,asapexe, titl,patches,epsilonr);
    
        % compute heff
        
        heff=AntTransferX(ant,op,er,solver,0,0);
        l=norm(heff(1,:),'fro');
        ang1 = acos(heff(1,:)*heff(2,:)'/(norm(heff(1,:),'fro')*norm(heff(2,:),'fro')))*180/pi;
        vec=(heff(1,:)+heff(2,:))/2;
        ang2= acos(vec*[0,0,1]'/(norm(vec,'fro')))*180/pi;
        fprintf('%4.3fm/%4.1f°/%4.1f°\t',l,ang1,ang2);
        fprintf('\n\n');
  
    end % for all configs
end %for all solvers
        
