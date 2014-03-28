function PlotJunoNearFieldEHD3

%   This function computes and plots the Near Field of the Juno spacecraft
%   by using the EH1D routine of the concept package.
%
%   Written by Thomas Oswald, September 2007

clear;

 % constants
 
mu=4*pi*1e-7;    % henry/meter...free space
c=2.99792458e8;
eps0=1/c^2/mu;

Z0=377;  % ohm...impedance of free space

% set parameters

N=1;
f=3e5;
asapexe='Asap3g.exe';
solver=2;   % this script works only for concept
ca=0;
force=1;
patches=1;
epsilonr=1;

if(patches)
    CurrentFile='CurrentsPatches.mat';
    GainFile='GainPatches.mat';
    titl='Juno/CONCEPT w. PATCHES';
else
    CurrentFile='Currents.mat';
    GainFile='Gain.mat';
    titl='Juno/CONCEPT';
end % else

N_theta=input('Number of points in theta direction :');
N_phi=input('Number of points in phi direction :');
NN=N_theta*N_phi;
dist=input('Distance :');
        
figure
 
ant=CreateJunoGrid;                

if patches
    ant=Wire2Patch(ant,titl);
end
           

for(n_f=1:length(f))   % for all f
    if force ~=1
        OP=VarLoad(CurrentFile,f/1e3,'OP');
    end
         
    
    if(~exist('OP')|isempty(OP))
        OP=StereoCurrent(f,ant,solver,asapexe, titl,patches,epsilonr);
        VarSave(CurrentFile,OP,f/1e3,'OP');
    end
    
    for feed =1:2    
        % compute current
        
        if patches
            ConceptWrite('concept.in',ant,OP,8,3,feed,titl);
            rval=ConceptCall();    
        else
            ConceptWrite('concept.in',ant,OP,8,2,feed,titl);
            rval=ConceptCall();
        end
        
        clear er;
        er=zeros(NN,3);
    
        N=length(ant.Desc);

        wavelength=3e8/f(n_f);
        k=2*pi/wavelength;
        omega=2*pi*f(n_f);

        theta=linspace(0,pi,N_theta);
        phi=linspace(0,2*pi,N_phi);
            

% vectors to points

        for(t=1:N_theta)        
            for(p=1:N_phi)
    
            % direction of incident wave
                
                er((t-1)*N_phi+p,1)=dist*sin(theta(t))*cos(phi(p)); % kein einheitsvector !!!
                er((t-1)*N_phi+p,2)=dist*sin(theta(t))*sin(phi(p));
                er((t-1)*N_phi+p,3)=dist*cos(theta(t));
                
                ep((t-1)*N_phi+p,1)=-sin(phi(p)); % das is der einheitsvektor
                ep((t-1)*N_phi+p,2)=cos(phi(p));
                ep((t-1)*N_phi+p,3)=0;      
            end % for all theta
        end     % for all phi

        et=cross(ep ,er,2)/dist; % das auch
        uer=er/dist;    % ja, das auch
   %----------------------------------------------------------------------
   
% make field calculation   

        [EE,HH,SS]=FieldConceptEH(er);
       
        EEtheta=dot(EE,et,2);
        EEphi=dot(EE,ep,2);
        EF=sqrt(dot(EE,EE,2));
        
        HHtheta=dot(HH,et,2);
        HHphi=dot(HH,ep,2);
        HF=sqrt(dot(HH,HH,2));
        
        
        S=real(dot(SS,uer,2));
        
        
        
        
 % compute radiated power
 % P=integral <S> dA
    
    
        dt = pi/N_theta;
        dp= 2*pi/N_phi;
        
        P=0;
                
        for(t=1:N_theta)
            for(p=1:N_phi)
                P=P+S((t-1)*N_phi+p)*sin(theta(t))*dist^2*dt*dp;
            end
        end

    
        fprintf('\nRadiated Power = %e\n',P);                
         
    % Gain
    
        G=S/(P/(4*pi*dist^2));

% plot graph


        %PlotField(EEtheta,N_theta,N_phi,theta,phi,sprintf('Theta component of electric field of feed %d',feed));
        
        %PlotField(EEphi,N_theta,N_phi,theta,phi,sprintf('Phi component of electric field od feed %d',feed));
        
        %PlotField(EF,N_theta,N_phi,theta,phi,sprintf('Magnitude of electric field of feed %d',feed));
        
        %-----------
        
      % PlotField(HHtheta,N_theta,N_phi,theta,phi,sprintf('Theta component of magnetic field of feed %d',feed))
        
       %PlotField(HHphi,N_theta,N_phi,theta,phi,sprintf('Phi component of magnetic field od feed %d',feed));
        
      % PlotField(HF,N_theta,N_phi,theta,phi,sprintf('Magnitude of magnetic field of feed %d',feed));
        
        %------
        
       % PlotField(S,N_theta,N_phi,theta,phi,sprintf('Magnitude of Poynting Flux of feed %d',feed))
        PlotField(G,N_theta,N_phi,theta,phi,sprintf('Gain of of antenna %d',feed))
    end % for all feeds
end % for all f
end % function
%------------------------------------------------------------------------

function PlotField(field,N_theta,N_phi,theta,phi,titel)
    figure
    for t=1:N_theta
        for p=1:N_phi
            x(t,p)=abs(field((t-1)*N_phi+p))*cos(phi(p))*sin(theta(t));
            y(t,p)=abs(field((t-1)*N_phi+p))*sin(phi(p))*sin(theta(t));
            z(t,p)=abs(field((t-1)*N_phi+p))*cos(theta(t));
                
            data(t,p)=abs(field((t-1)*N_phi+p));
        end
    end

    surf(x,y,z,data)
    handle=surf(x,y,z,real(data));
    set(handle,'edgecolor','none','facecolor','interp');
    colorbar

    title(titel);
        
    xlabel('x-axis');
    ylabel('y-axis');
    zlabel('z-axis');
    hold off
end % function
