% FDTD_ld_4
% FDTD simulation in free space 

% absorbing boundary condition added

% dielectric medium added

% cotinuous source

KE= 200;         % number of cells


%  Initialize 

ex=zeros(KE,1); 
hy=ex;

% initial conditions

kc = KE/2;                  % center of space
kstart = kc;                % location, where the medium starts
t0 = 40.0;                  % center of pulse
spread=12;                  % width of pulse
deltaT=0.5;

deltaT_E=zeros(KE,1);
deltaT_E(:)=deltaT_E(:)+0.5;    % free space

T = 0;                      % track of the total number
                            % of times the main loop is executed
                            
epsr=4;                     % relative permittivity in medium
     
deltaT_E(kstart:KE)=deltaT_E(kstart:KE)./epsr;  % medium right of kstart

ddx = .01;          % cell size 1 cm
dt = ddx/(2*3e8);   % timestepsize for source 

f=700e6;            % frequency

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
            ex(k) = ex(k) + deltaT_E(k)*( hy(k-1) - hy(k) );
        end    % for
        
        % Put a Gaussian pulse in the middle 
        
        %pulse = exp(-0.5*(power( (t0-T)/spread,2.0) ));
        
        % Put a continuous source
        
        pulse = sin(2*pi*f*dt*T);
        
        ex(kc-50) = ex(kc-50)+pulse;
        
        % Absorbing Boundary Conditions

        ex(1)=ex_low_m_2;
        ex_low_m_2=ex_low_m_1;
        ex_low_m_1=ex(2);

        ex(KE)=ex_high_m_2;
        ex_high_m_2=ex_high_m_1;
        ex_high_m_1=ex(KE-1);
        
        % Calculate the Hy field 
        
        for  k=1: (KE-1)
            hy(k) = hy(k) + deltaT* ( ex (k) - ex (k+1) );
        end     % for
    end %for
    
    % plot fields    
    
    x=1:KE;
    plot(x,ex);
    line(x,hy,'color','r');
    
    legend('E_x','H_y');
    
    nsteps=input('Steps:');
end % while