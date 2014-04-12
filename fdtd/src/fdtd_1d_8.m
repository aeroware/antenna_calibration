% FDTD_ld_8
% FDTD simulation in free space and dielectric medium

% frequency dependent material added

KE= 200;         % number of cells


%  Initialize 

ex=zeros(KE,1); 
dx=ex;	% flux density
hy=ex;
ix=ex;
sx=ex;

% FFT
ft=zeros(KE, 3);	% 3 frequenzen
amplitude=ft;
phase=ft;

% input pulse

inputPulse=zeros(3, 1);
inputAmplitude=inputPulse;
inputPhase=inputPulse;

ga=ex;	% hilfsfaktorem
gb=ex;
gc=ex;

ga(:)=1;	% free space

% initial conditions

kc = KE/2;                  % center of space
kstart = kc;                % location, where the medium starts
t0 = 40.0;                  % center of pulse
spread=12;                  % width of pulse
deltaT=0.5;



T = 0;                      % track of the total number
                            % of times the main loop is executed
 
 % material constants
 
epsz = 8.85419e-12;                           
epsr=2;                     % relative permittivity in medium
sigma=0.01;		% conductivity
chi=2;
tau=  1000;



f=700e6;            % frequency

% frequencies for FFT 

freq(1)=50e6;
freq(2)=200e6;
freq(3)=500e6;

ddx = ((3e8/sqrt(epsr))/f)/10;          % cell size 1 cm
dt = ddx/(2*3e8);   % timestepsize for source 

printf("Cellsize = %f m\n",ddx);
printf("dt = %e s\n",dt);

del_exp=exp( -dt/tau);
tau=1e-6*tau;  

ga(kstart:KE)= 1/(epsr + sigma*dt/epsz + chi*dt/tau); % medium right of kstart
gb(kstart:KE)=sigma*dt/epsz;
gc(kstart:KE)=chi*dt/tau;

% boundary conditions

ex_low_m_1=0;
ex_low_m_2=0;
ex_high_m_1=0;
ex_high_m_2=0;
                            
nsteps=input('Steps:');

while  nsteps > 0  

    n=0;

    for n=1:nsteps
        T=T+1;

        % Calculate the Ex field 
        
        for  k=2:KE
            dx(k) = dx(k) + 0.5*( hy(k-1) - hy(k) );
        end    % for
        
        % Put a Gaussian pulse in the middle 
        
        pulse = exp(-0.5*(power( (t0-T)/spread,2.0) ));
        
        % Put a continuous source
        
        %pulse = sin(2*pi*f*dt*T);
        
        dx(6) = dx(6)+pulse;
        
        % compute ex from dx
        
        for  k=2:KE
            ex(k) = ga(k)*( dx(k) - ix(k) -sx(k));
            ix(k)=ix(k)+gb(k)*ex(k);
            sx(k)=del_exp*sx(k)+gc(k)*ex(k);
        end    % for
        
        % calculate FT
        
        
        
        for  k=2:KE
        	for m=1:3
        		ft(k,m)=ft(k,m)+ex(k)*dt*exp(-i*2*pi*freq(m)*dt*T);  			
        	end
       	end
        		
        if(T<100)
        		inputPulse(:)=inputPulse(:)+dt*ex(6).*exp(-i*2*pi*freq(:)*dt*T);
        end
        		
        % Absorbing Boundary Conditions

        ex(1)=ex_low_m_2;
        ex_low_m_2=ex_low_m_1;
        ex_low_m_1=ex(2);

        ex(KE)=ex_high_m_2;
        ex_high_m_2=ex_high_m_1;
        ex_high_m_1=ex(KE-1);
        
        % Calculate the Hy field 
        
        for  k=1: (KE-1)
            hy(k) = hy(k) + 0.5* ( ex (k) - ex (k+1) );
        end     % for
    end %for
    
    % plot fields    
    
    figure(1);
    x=1:KE;
    plot(x,ex);
    title("E");
    
    %figure(2);
   % plot(x,hy);
    %title("H");
    
    % compute amplitude and phase
    
    
    inputAmplitude(:)=abs(inputPulse(:));
    inputPhase(:)=arg(inputPulse(:));
    
    for m=1:3
    	amplitude(:,m)=abs(ft(:,m))./ inputAmplitude(m);
    end
    phase(:,m)=arg(ft(:,m));
    
   figure(3);
    plot(x,amplitude(:,1));
    title(sprintf("Frequency domain f= %.1f",freq(1)));
    
    figure(4);
    plot(x,amplitude(:,2));
     title(sprintf("Frequency domain f= %.1f",freq(2)));
    
    
    figure(5);
    plot(x,amplitude(:,3));
    title(sprintf("Frequency domain f= %.1f",freq(3)));
    
    
    nsteps=input('Steps:');
end % while
