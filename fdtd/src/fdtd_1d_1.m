% FDTD_ld_1
% FDTD simulation in free space 

KE= 200;         % number of cells



%int n,k,kc,ke,NSTEPS;
%float T;
%float to,spread,pulse;

%  Initialize 

ex=zeros(KE,1); 
hy=ex;

% initial conditions

kc = KE/2;                  % center of space
t0 = 40.0;                  % center of pulse
spread=12;                  % width of pulse
deltaT=0.5;

T = 0;                      % track of the total number
                            % of times the main loop is executed
                            
nsteps=input('Steps:');

while  nsteps > 0  

    n=0;

    for n=1:nsteps
        T=T+1;

        % Calculate the Ex field 
        
        for  k=2:KE
            ex(k) = ex(k) + deltaT*( hy(k-1) - hy(k) );
        end    % for
        
        % Put a Gaussian pulse in the middle 
        
        pulse = exp(-0.5*(power( (t0-T)/spread,2.0) ));
        
        ex(kc) = pulse;
        

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