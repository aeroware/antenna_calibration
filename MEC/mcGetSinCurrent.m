function [CS,Z_a]=mcGetSinCurrent(ant, f,freqrelsqu,ioneffect,volt)

%   function [CS,Z_a]=mcGetSinCurrent(ant,
%   f,freqrelsqu,ioneffect,volt,integral,inte)
%
%   This function computes the currents of the wiregrid structure stored in
%   ant and saves it in the current structure CS together with the 
%   frequency and the feed position used for the calculation. It uses the 
%   method of moments. The antennaimpedance is also calculated and stored 
%   in Z_a. The difference to mcGetCurrent is the use of sinoid
%   bse-functions instead of pulse functions.
%
%   ant...antenna structure
%   f...frequency
%   frequrelsequ...omega_pe^2/omega^2
%   ioneffect...consider the effect of ions ?   0...no
%                                               1...jep
%   volt...excitation voltage on feeds
%   integral...method of integral evaluation
%   inte...number of integration steps
%
%   Written October 1009 by Thomas Oswald

% constants

mu=4*pi*1e-7;    % henry/meter...free space
epsilon0=8.8542e-12;   % parad/meter...free space


% parameter

if(nargin<3)
    freqrelsqu=0;
end

if(nargin<4)
    ioneffect=0;
end

if(nargin<5)
    volt=1;
end


ionrelsequ=ioneffect*freqrelsqu/2000; % omega_pe/omega_pi = 1/sqrt(2000)
epsilon_r=(1-freqrelsqu-ionrelsequ);
epsilon=epsilon0*epsilon_r;  % epsilon=epsilon0*(1-omega_pe^2/omega^2-omega_pi^2/omega^2)

Z0=sqrt(mu/epsilon0);  % ohm...impedance of free space

CS=struct(...
    'I',[],...
    'feeds',[],...
    'f',0, ...
    'epsilon',0,...
    'base',1);  % ...sinoid basefunctions

CS.feeds=ant.feeds;
CS.f=f;
CS.epsilon_r=epsilon_r;

%   setup matrices

N=ant.nSegs;
M=ant.nNodes;

I=zeros(N,1);   % Current vector
E=zeros(N,1);   % Voltages
Z=zeros(N);     % Impedanz Matrix
l=zeros(N,1);

wavelength=3e8/(f*sqrt(epsilon_r));
k=2*pi/wavelength;
omega=2*pi*f;
a=ant.radius;  % wire radius
a_rel=a/wavelength; 

%   construct impedance matrix

n=1:N;
m=1:N;


delta=ant.nodes(ant.segs(n,2),:)-ant.nodes(ant.segs(n,1),:);
l=sqrt(dot(delta,delta,2));
mid(n,:)=(ant.nodes(ant.segs(n,1),:)+ant.nodes(ant.segs(n,2),:))./2;



l_rel=l./wavelength;

% compute distance between segments

%r=zeros(N);

for(m=1:N)
    for(n=1:N)           
        r(m,n)=sqrt(norm(ant.nodes(n,:)-ant.nodes(m,:),'fro')^2+a^2);
    end
end

%r_rel=r./wavelength;

% constructing the integrand

G=zeros(N,N);

% integrating
         
fprintf('Working on segment 000');
        
for(m=2:(N-1))
    fprintf('\b\b\b\b%4i',m);
   for(n=2:(N-1))
            G(m,n)=-30/sqrt(epsilon_r)*i*(exp(-i*k*r(m-1,n))/(r(m-1,n)*sin(k*l(m)))...
               -(sin(2*k*l(m))*exp(-i*k*r(m,n)))/(r(m,n)*sin(k*l(m))^2)...
               +exp(-i*k*r(m+1,n))/(r(m+1,n)*sin(k*l(m))));
    end % for
end % for


% compute impedance matrix
    

E(ant.feeds)=volt./l(ant.feeds);


I=-G(2:N-1,2:N-1)\E(2:N-1);
I(1)=0;
I(N)=0;

CS.I=I;

% Antenna Impedance

Z_a=volt./I(ant.feeds)
heff=sqrt(norm((mid(1,:)-l(1)/2)-(mid(N,:)+l(N)/2),'fro')^2+a^2)/2;
RadiationResistance=20*(heff*k)^2;

fprintf('Radiation Resistance of ideal thin dipole = %f',RadiationResistance);

%figure
%plot(abs(I));
%title('Current Distribution/ Absolute value');

% figure
% plot(real(I));
% title('Current Distribution/ Real part');
% 
% figure
% plot(imag(I));
% title('Current Distribution/ Imaginary part');