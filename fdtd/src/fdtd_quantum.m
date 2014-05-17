% FDTD_quantum
% FDTD simulation of an electron hitting a potential barrier


KE= 400;         % number of cells


%  Initialize 

psi=zeros(KE,1); 
vp=psi;	% potential energy



% input pulse

inputPulse=zeros(3, 1);
inputAmplitude=inputPulse;
inputPhase=inputPulse;

% initial conditions

kc = KE/2;                  % center of space
kstart = kc;                % location, where the medium starts
k0 = kc/2;                  % center of pulse
sigma=20;                  % width of pulse
Ekin=146*1.602e-19; 	% eV
hc=1.98644568e-25; % h*c
lambda=hc/Ekin;


Vpot=0;	% eV
vp(kstart:KE)=Vpot*1.602e-19; % eV -> J


T = 0;                      % track of the total number
                            % of times the main loop is executed
 
 % material constants
 
m_e=9.2e-31;		% electron mass
h_bar=1.055e-34;	% planck's constant

ddx = 5e-10;          % cell size 
ra=1/8;
dt =0.25*(m_e/h_bar)*ddx^2;   % timestepsize for source 
lambda_grid=lambda/ddx;

printf("Cellsize = %e m\n",ddx);
printf("dt = %e s\n",dt);
printf("lambda = %d cells\n",lambda_grid);

% init particle

x=1:kstart;

psi(x)=(cos(2*pi*(x-k0)/lambda_grid)+i*sin(2*pi*(x-k0)/lambda_grid)).*exp(-0.5*((x-k0)/sigma).^2);
                
nsteps=input('Steps:');


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
        		ft(k,m)=ft(k,m)+ex(k)*dt*exp(-I*2*pi*freq(m)*dt*T);  			
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
    plot(x,psi);
    title("Psi");
    
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
