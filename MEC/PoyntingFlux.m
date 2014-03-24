function S=PoyntingFlux(ant,f, I, NN)

%   function S=FarField(ant,f, I, NN)
%
%   This function computes the average Poyting flux as function of theta and phi. Since S has only a
%   component in theta direction, and B only in phi direction, only a
%   scalar is required for each direction. So S is a 2
%   dimensional matrix. Since the field depends on the distance from the
%   antenna, the output is normalized to one antenna length. 
%
%   ant...antenna structure
%   f...frequency
%   I...a vector where the entries are the magnitude of the current in this
%       segment
%   NN...number of points in theta direction


% constants

mu=4*pi*1e-7;    % henry/meter...free space
epsilon=8.8542e-12;   % parad/meter...free space
Z0=377;  % ohm...impedance of free space

% parameter

if(nargin<3)
    fprintf('Not enough parameters');
    return
end

N=ant.nSegs;

wavelength=3e8/f;
k=2*pi/wavelength;
omega=2*pi*f;

S=zeros(NN,NN);
E=zeros(NN,NN);
B=zeros(NN,NN);
H=zeros(NN,NN);

% compute midpoints

for(n=1:N)
    l(n)=norm((ant.nodes(ant.segs(n,2),:)-ant.nodes(ant.segs(n,1),:)),'fro');
    mid(n,:)=(ant.nodes(ant.segs(n,1),:)+ant.nodes(ant.segs(n,2),:))./2;
end

theta=linspace(0,pi,NN);
phi=linspace(0,2*pi,NN);
    

% compute fields

 [E,B]=FarField(ant,f,I,NN);
 
 H=B./mu;
 
 
 % average poynting flux <S>
 
 for(t=1:NN)
    for(p=1:NN)
 S(t,p)=0.5*real(E(t,p).*conj(H(t,p)));               
end
end

 % compute radiated power
 % P=integral <S> dA
    
    
dt = pi/NN;
dp= 2*pi/NN;
A=0;
P=0;

for(t=1:NN)
    for(p=1:NN)
        P=P+S(t,p)*sin(theta(t))*dt*dp;
    end
end

I0=abs(I(ant.feeds));

fprintf('\nRadiated Power = %f\n',P);            
fprintf('Theoretical value for halfwave dipole = %f',36.5*I0^2);            
            
         
fprintf('\nRadiation Resistance = %f\n',P/(I0^2/2));           


% plot graph

figure
polar(theta(1,:),S(:,1)');
hold on
polar(-theta(1,:),S(:,1+floor(NN/2))');
hold off



title('Poynting Flux as function of colatitude');

figure
for t=1:NN
    for p=1:NN
        x(t,p)=S(t,p)*cos(phi(p))*sin(theta(t));
        y(t,p)=S(t,p)*sin(phi(p))*sin(theta(t));
        z(t,p)=S(t,p)*cos(theta(t));
    end
end
surf(x,y,z,S)
colorbar
title('Poynting Flux distribution, color coded');
