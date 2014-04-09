% FDTD_ld_6
% FDTD simulation in free space and dielectric medium

% flux density added

KE= 200;         % number of cells


%  Initialize 

ex=zeros(KE,1); 
dx=ex;	% flux density
hy=ex;
ix=ex;

ga=ex;	% hilfsfaktorem
gb=ex;

ga(:)=1;	% free space

% initial conditions

kc = KE/2;                  % center of space
kstart = kc;                % location, where the medium starts
t0 = 40.0;                  % center of pulse
spread=12;                  % width of pulse
deltaT=0.5;



T = 0;                      % track of the total number
                            % of times the main loop is executed
 
 epsz = 8.85419e-12;                           
epsr=4;                     % relative permittivity in medium
sigma=0.04;		% conductivity
     

f=700e6;            % frequency

ddx = ((3e8/sqrt(epsr))/f)/10;          % cell size 1 cm
dt = ddx/(2*3e8);   % timestepsize for source 

printf("Cellsize = %f m\n",ddx);
printf("dt = %e s\n",dt);


ga(kstart:KE)= 1/(epsr + sigma*dt/epsz); % medium right of kstart
gb(kstart:KE)=sigma*dt/epsz;

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
        
       % pulse = exp(-0.5*(power( (t0-T)/spread,2.0) ));
        
        % Put a continuous source
        
        pulse = sin(2*pi*f*dt*T);
        
        dx(6) = dx(6)+pulse;
        
        % compute ex from dx
        
        for  k=2:KE
            ex(k) = ga(k)*( dx(k) - ix(k) );
            ix(k)=ix(k)+gb(k)*ex(k);
        end    % for
        
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
    
    x=1:KE;
    plot(x,ex);
    line(x,hy,'color','r');
    
    legend('E_x','H_y');
    
    nsteps=input('Steps:');
end % while
