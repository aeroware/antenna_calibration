% FDTD_plasma
% FDTD simulation in plasma

% plasma added

KE= 500;         % number of cells


%  Initialize 

ex=zeros(KE,1); 
dx=ex;	% flux density
hy=ex;
sx=ex;

% FFT
ft=zeros(KE, 3);	% 3 frequenzen
amplitude=ft;
phase=ft;

% input pulse

inputPulse=zeros(3, 1);
inputAmplitude=inputPulse;
inputPhase=inputPulse;

sx=ex;	% hilfsfaktorem
sxm1=ex;
sxm2=ex;

ga(:)=1;	% free space

% initial conditions

kc = KE/2;                  % center of space
kstart = 300;                % location, where the medium starts
t0 = 40.0;                  % center of pulse
spread=200;                  % width of pulse
deltaT=0.5;



T = 0;                      % track of the total number
                            % of times the main loop is executed
 
 % material constants
 
epsz = 8.85419e-12;                           
epsr=2;                     % relative permittivity in medium


% plasma parameter

vc=57e12;
fp=2000e12;
omega=2*pi*fp;
f=500e12;            % frequency

% frequencies for FFT 

freq(1)=50e6;
freq(2)=200e6;
freq(3)=500e6;

ddx = 1e-9;          % cell size 1 cm
dt = ddx/(2*3e8);   % timestepsize for source 

printf("Cellsize = %e m\n",ddx);
printf("dt = %e s\n",dt);


% boundary conditions

ex_low_m_1=0;
ex_low_m_2=0;
ex_high_m_1=0;
ex_high_m_2=0;
                            
nsteps=input('Steps:');

kd=2:KE;
kp=kstart :KE;
kh=1:(KE-1);

while  nsteps > 0  

    n=0;

    for n=1:nsteps
        T=T+1;

        % Calculate the Ex field 
        
        
            dx(kd) = dx(kd) + 0.5*( hy(kd-1) - hy(kd) );
       
        
        % Put a Gaussian pulse in the middle 
        
        pulse = exp(-0.5*(power( (t0-T)/spread,2.0) ));
        
        % Put a continuous source
        
        pulse = pulse*sin(2*pi*f*dt*T);
        
        dx(6) = dx(6)+pulse;
        
        % compute ex from dx
         
        
        ex(kd) = dx(kd)-sx(kd);
        
        
         sx(kp)=(1+exp(-vc*dt))*sxm1(kp)-exp(-vc*dt)*sxm2(kp)+((omega^2)*dt/vc)*(1-exp(-vc*dt))*ex(kp);
         sxm2(kp)=sxm1(kp);
         sxm1(kp)=sx(kp);
        
        
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
         
        hy(kh) = hy(kh) + 0.5* ( ex (kh) - ex (kh+1) );
        
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
    
    
  %  inputAmplitude(:)=abs(inputPulse(:));
   % inputPhase(:)=arg(inputPulse(:));
    
   % for m=1:3
    	%amplitude(:,m)=abs(ft(:,m))./ inputAmplitude(m);
   % end
   % phase(:,m)=arg(ft(:,m));
    
   %figure(3);
   % plot(x,amplitude(:,1));
   % title(sprintf("Frequency domain f= %.1f",freq(1)));
    
   % figure(4);
   % plot(x,amplitude(:,2));
    % title(sprintf("Frequency domain f= %.1f",freq(2)));
    
    
   % figure(5);
   % plot(x,amplitude(:,3));
  %  title(sprintf("Frequency domain f= %.1f",freq(3)));
    
    
    nsteps=input('Steps:');
end % while
