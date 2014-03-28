%   PlotJunoGain is a script which computes and plots the Gain Pattern of
%   the Juno spacecraft.
%
%   Written by Thomas Oswald, September, 2007

n=1;
er=[1,0,0];

 % constants

mu=4*pi*1e-7;    % henry/meter...free space
epsilon=8.8542e-12;   % parad/meter...free space
Z0=377;  % ohm...impedance of free space

clear x;
clear y;
clear z;
clear NN;
clear theta;
clear phi;
clear thetamat;
clear phimat;

%   parameters

 N=1;
 f=3e5;
 asapexe='Asap3g.exe';
 solver=2;
 ca=0;
 force=0;
 patches=0;
 epsilonr=1;
 
 method=2;   % 1=field far (transmitting antenna),2==anttransferx(receiving antenna)
 
if(solver==1)
    CurrentFile='JunoCurrents.mat';
    GainFile='JunoGain.mat';
    titl='Juno/ASAP';
else % concept
    if(patches)
        CurrentFile='CurrentsPatches.mat';
        GainFile='GainPatches.mat';
        titl='Juno/CONCEPT w. PATCHES';
    else
        CurrentFile='Currents.mat';
        GainFile='Gain.mat';
        titl='Juno/CONCEPT';
    end % else
end % concept

figure
    
ant=CreateJunoGrid;                
        

for(n_f=1:length(f))   % for all f

    op=VarLoad(CurrentFile,f/1e3,'OP');
         
    if(isempty(op) | force==1)
        op=JunoCurrent(f,ant,solver,asapexe, titl,patches,epsilonr);
        VarSave(CurrentFile,op,f/1e3,'OP');
    end
    
    N_theta=input('Number of points in theta direction :');
    N_phi=input('Number of points in phi direction :');
    
    N=length(ant.Desc);

    wavelength=3e8/f(n_f);
    k=2*pi/wavelength;
    omega=2*pi*f(n_f);

    S=zeros(N_theta,N_phi);
    S1=zeros(N_theta,N_phi);
    S2=zeros(N_theta,N_phi);
    S3=zeros(N_theta,N_phi);
    
    theta=linspace(0,pi,N_theta);
    phi=linspace(0,2*pi,N_phi);
    
    for(t=1:N_theta)
        for(p=1:N_phi)
            thetamat(t,p)=theta(t);
            phimat(t,p)=phi(p);
        end
    end
            
    if(solver==1)   % if asap
        fprintf('Working on point  0/ 0');     
        for(t=1:N_theta)
            for(p=1:N_phi)
                fprintf('\b\b\b\b\b%2i/%2i',t,p);
            % direction of incident wave
            
                er(1)=sin(theta(t))*cos(phi(p));
                er(2)=sin(theta(t))*sin(phi(p));
                er(3)=cos(theta(t));
            
                % effective length vector
            
                if ca==1
                    caps=eye(2)./70e-12;
                    impedances=caps./(i*op.Freq*2*pi);
                    TM=AntTransferx(ant,op,er,solver,0,25.4/1000,impedances);
                else
                    TM=AntTransferx(ant,op,er,solver,0,0);
                end
                
                HeffE1=TM(1,:);
                HeffE2=TM(2,:);
                
                S1(t,p)=mag(cross(HeffE1,er))^2;
                S2(t,p)=mag(cross(HeffE2,er))^2;
            end % for all theta
        end     % for all phi

        figure
        PlotPolar3(thetamat',phimat',S1',[-30,max((abs(S1(:))))],[],[-30:3:0]);
        title(sprintf('F=%d MHz, feed=1',f/1e6));
        
        figure
        PlotPolar3(thetamat',phimat',S2',[-30,max((abs(S2(:))))],[],[-30:3:0]);
        title(sprintf('F=%d MHz, feed=2',f/1e6));
    else % concept
        if method==1
            for feed=1:2
                fprintf('\nFeed = %i\n', feed)
                fprintf('Working on point  0/ 0');     
                for(t=1:N_theta)
                    for(p=1:N_phi)
                        fprintf('\b\b\b\b\b%2i/%2i',t,p);
            % direction of incident wave
            
                        er(1)=sin(theta(t))*cos(phi(p));
                        er(2)=sin(theta(t))*sin(phi(p));
                        er(3)=cos(theta(t));
            
            % energy flux
            
                        S(t,p)=FieldFarConcept(ant,op,er,feed,'SS');
           
                    end % for all theta
                end     % for all phi

 % compute radiated power
 % P=integral <S> dA
    
    
                dt = pi/N_theta;
                dp= 2*pi/N_phi;
                A=0;
                P=0;

                for(t=1:N_theta)
                    for(p=1:N_phi)
                        P=P+S(t,p)*sin(theta(t))*dt*dp;
                    end
                end

    
                fprintf('\nRadiated Power = %e\n',P);                
         
    % Gain
    
                G=S/(P/(4*pi));

% plot graph

            figure
            polar(theta(1,:),G(:,1)');
            hold on
            polar(-theta(1,:),G(:,1+floor(N_theta/2))');
            hold off

            title('Poynting Flux as function of colatitude');

                figure
                for t=1:N_theta
                    for p=1:N_phi
                        x(t,p)=G(t,p)*cos(phi(p))*sin(theta(t));
                        y(t,p)=G(t,p)*sin(phi(p))*sin(theta(t));
                        z(t,p)=G(t,p)*cos(theta(t));
                    end
                end
                surf(x,y,z,G)
                handle=surf(x,y,z,real(G));
                set(handle,'edgecolor','none','facecolor','interp');
                colorbar;
 
                title(strcat(titl,sprintf(' Feed %i f= %d MHz',feed,f/1e6)));
                xlabel('x-axis');
                ylabel('y-axis');
                zlabel('z-axis');
            end % for all feeds
        else
            fprintf('Working on point  0/ 0');     
            for(t=1:N_theta)
                for(p=1:N_phi)
                    fprintf('\b\b\b\b\b%2i/%2i',t,p);
            % direction of incident wave
            
                    er(1)=sin(theta(t))*cos(phi(p));
                    er(2)=sin(theta(t))*sin(phi(p));
                    er(3)=cos(theta(t));
            
                % effective length vector
            
                    if ca==1
                        caps=eye(2)./90e-12;
                        impedances=caps./(i*op.Freq*2*pi);
                        TM=AntTransferx(ant,op,er,solver,0,25.4/1000,impedances);
                    else
                        TM=AntTransferx(ant,op,er,solver,0,0);
                    end
                
                    HeffE1=TM(1,:);
                    HeffE2=TM(2,:);
                
                    S1(t,p)=mag(cross(HeffE1,er))^2;
                    S2(t,p)=mag(cross(HeffE2,er))^2;
                end % for all theta
            end     % for all phi

            figure
            PlotPolar3(thetamat',phimat',S1',[-30,max((abs(S1(:))))],[],[-30:3:0]);
            title(sprintf('F=%d MHz, feed=1',f/1e6));
        
            figure
            PlotPolar3(thetamat',phimat',S2',[-30,max((abs(S2(:))))],[],[-30:3:0]);
            title(sprintf('F=%d MHz, feed=2',f/1e6));
        end % method
    end % concept
end % for all f


