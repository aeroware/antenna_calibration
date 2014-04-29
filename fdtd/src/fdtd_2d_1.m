% FDTD_2d_1
% FDTD simulation 2d

% frequency dependent material added

IE= 60;         % number of cells
JE=60;

%  Initialize 

ez=zeros(IE, JE); 
dz=ez;	% flux density
hx=ez;
hy=ez;


% FFT

%ft=zeros(KE, 3);	% 3 frequenzen
%amplitude=ft;
%phase=ft;

% input pulse

inputPulse=zeros(3, 1);
inputAmplitude=inputPulse;
inputPhase=inputPulse;

ga=ez;	% hilfsfaktoren


ga(:,:)=1;% free space

% initial conditions

ic = IE/2;                  % center of space
jc=JE/2;

%kstart = kc;                % location, where the medium starts
t0 = 20.0;                  % center of pulse
spread=6;                  % width of pulse
deltaT=0.5;



T = 0;                      % track of the total number
                            % of times the main loop is executed
 
 % material constants
 
epsz = 8.85419e-12;                           
epsr=1;                     % relative permittivity in medium
sigma=0.0;		% conductivity
chi=0;
tau=  1000;



f=700e6;            % frequency

% frequencies for FFT 

freq(1)=50e6;
freq(2)=200e6;
freq(3)=500e6;

%ddx = ((3e8/sqrt(epsr))/f)/10;          % cell size 1 cm
ddx = 0.01;          % cell size 1 cm
dt = ddx/(2*3e8);   % timestepsize for source 

printf("Cellsize = %f m\n",ddx);
printf("dt = %e s\n",dt);

del_exp=exp( -dt/tau);
tau=1e-6*tau;  

%ga(kstart:KE)= 1/(epsr + sigma*dt/epsz + chi*dt/tau); % medium right of kstart

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

        % Calculate the dz field 
        
        for  j=2:JE
        	for i=2:IE
            		dz(i,j) = dz(i,j) + 0.5*( hy(i,j) - hy(i-1,j)-hx(i,j) + hx(i,j-1) );
            	end	
        end    % for
        
        % Put a Gaussian pulse in the middle 
        
        pulse = exp(-0.5*(power( (t0-T)/spread,2.0) ));
        
        % Put a continuous source
        
        %pulse = sin(2*pi*f*dt*T);
        
        dz(ic,jc) = dz(ic,jc)+pulse;
        
        % compute ez from dz
        
        for  j=2:JE
        	for i=2:IE
            		ez(i,j) = ga(i,j)*dz(i,j);
            	end
        end    % for
        
        % calculate FT
        
        
        %for  k=2:KE
        %	for m=1:3
        %		ft(k,m)=ft(k,m)+ex(k)*dt*exp(-i*2*pi*freq(m)*dt*T);  			
        %	end
       	% end
        		
      %  if(T<100)
        %		inputPulse(:)=inputPulse(:)+dt*ex(6).*exp(-i*2*pi*freq(:)*dt*T);
        %end
        		
        % Absorbing Boundary Conditions

       % ex(1)=ex_low_m_2;
        %ex_low_m_2=ex_low_m_1;
        %ex_low_m_1=ex(2);

        %ex(KE)=ex_high_m_2;
        %ex_high_m_2=ex_high_m_1;
        %ex_high_m_1=ex(KE-1);
        
        % Calculate the H field 
        
        for  j=1:(JE-1)
        	for i=1:(IE-1)
        		hx(i,j) = hx(i,j) + 0.5* ( ez (i,j) - ez (i,j+1) );
            		hy(i,j) = hy(i,j) + 0.5* ( ez (i+1,j) - ez (i,j) );
            	end
        end     % for
    end %for
    
    % plot fields    
    
    x=1:IE;
    y=1:JE;
    
    mesh(x,y, ez);
    
  %  figure(1);
   % x=1:KE;
   % plot(x,ex);
   % title("E");
    
    %figure(2);
   % plot(x,hy);
    %title("H");
    
    % compute amplitude and phase
    
    
  %  inputAmplitude(:)=abs(inputPulse(:));
    %inputPhase(:)=arg(inputPulse(:));
    
   % for m=1:3
    %	amplitude(:,m)=abs(ft(:,m))./ inputAmplitude(m);
   % end
   % phase(:,m)=arg(ft(:,m));
    
   %figure(3);
    %plot(x,amplitude(:,1));
    %title(sprintf("Frequency domain f= %.1f",freq(1)));
    
    %figure(4);
   % plot(x,amplitude(:,2));
    % title(sprintf("Frequency domain f= %.1f",freq(2)));
    
    
    %figure(5);
    %plot(x,amplitude(:,3));
    %title(sprintf("Frequency domain f= %.1f",freq(3)));
    
    
    nsteps=input('Steps:');
end % while
