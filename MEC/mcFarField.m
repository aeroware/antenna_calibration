function [A,E,B]=mcFarField(ant,cs, NN,freqrelsqu,ioneffect)

%   function [E B]=mcFarField(ant,cs, NN)
%
%   This function computes the electric and magnetic field  as function 
%   of theta and phi. Since E has only a
%   component in theta direction, and B only in phi direction, only a
%   scalar is required for each direction. So E and B are a 2
%   dimensional matrices. Since the field depends on the distance from the
%   antenna, the output is normalized. To get the
%   actual field strengths, one has to multiply the result by exp(ikr)/r
%
%   ant...antenna structure
%   cs...current structure
%   NN...number of points in theta and phi direction or unit vector of
%   direction where the field is evaluated.


if(nargin<4)
    freqrelsqu=0;
end

if(nargin<5)
    ioneffect=0;
end

% constants

mu=4*pi*1e-7;    % henry/meter...free space
epsilon0=8.8542e-12;   % parad/meter...free space
Z0=376.7;  % ohm...impedance of free space

% parameter

if(nargin<3)
    fprintf('Not enough parameters');
    return
end

ionrelsequ=ioneffect*freqrelsqu/2000; % omega_pe/omega_pi = 1/sqrt(2000)
epsilon_r=(1-freqrelsqu-ionrelsequ);
epsilon=epsilon0*epsilon_r;  

% epsilon=epsilon0*(1-omega_pe^2/omega^2-omega_pi^2/omega^2)

ZP=sqrt(mu/epsilon);  % ohm...impedance of free space

N=ant.nSegs;

wavelength=3e8/(cs.f*sqrt(epsilon_r));

k=2*pi/wavelength;
omega=2*pi*cs.f;

%   compute lengths and midpoints of segments

n=1:N;
delta=ant.nodes(ant.segs(n,2),:)-ant.nodes(ant.segs(n,1),:);
l=sqrt(dot(delta,delta,2));
mid(n,:)=(ant.nodes(ant.segs(n,1),:)+ant.nodes(ant.segs(n,2),:))./2;

%   compute fields

if length(NN)==1
    
    E=zeros(NN,NN);
    B=zeros(NN,NN);
    A=zeros(NN,NN);

    %fprintf('Working on segment 000');
    theta=linspace(0,pi,NN);
    phi=linspace(0,2*pi,NN);
    
    II=zeros(1,NN)+1;

    for(n=1:N)  
            % compute fields
            
                A=A+(cs.I(n)*l(n))*(exp(i*mid(n,3)*cos(theta))'*II);
                B=B+(k*cs.I(n)*l(n))*(sin(theta)'*II).*(exp(i*mid(n,3)*cos(theta))'*II);
     
    end % for all segments
    
    A=A*mu/(4*pi);
    E=B*ZP*i/(4*pi);
    B=B*mu*i/(4*pi);
    
else
    cos_theta=dot(NN,[0,0,1])/sqrt(dot(NN,NN));
    sin_theta=sqrt(NN(1)^2+NN(2)^2)/sqrt(dot(NN,NN));
    A=0;
    E=0;
    B=0;
    
    for(n=1:N)
                      
            % compute fields
            
         A=A+(cs.I(n)*l(n))*exp(i*k*dot(NN,mid(n,:)));
         B=B+(k*cs.I(n)*l(n))*sin_theta*exp(i*k*dot(NN,mid(n,:)));
               
    end % for all segments
    
    A=A*mu/(4*pi);
    E=abs(real(B*ZP*i/(4*pi)));
    B=abs(real(B*mu*i/(4*pi)));
   
    return
end % single direction



% plot graph

polar(theta(1,:),abs(real(E(:,1))'),'r');
hold on
polar(-theta(1,:),abs(real(E(:,1+floor(NN/2)))'),'r');
%hold off

title('Electric field as function of colatitude');

% x=zeros(NN,NN);
% y=x;
% z=x;
% II=zeros(1,NN)+1;
% 
% figure
% x=abs(real(E)).*(sin(theta)'*cos(phi));
% y=abs(real(E)).*(sin(theta)'*sin(phi));
% z=abs(real(E)).*(cos(theta)'*II);
%         
% handle=surf(x,y,z,real(E));
% colorbar
% hold on
% set(handle,'edgecolor','none','facecolor','interp');
% % c=contourc(real(E));
% % clabel(c,ch);
% title('Electric field, color coded');
% 
% figure
% polar(theta(1,:),abs(real(B(:,1))'));
% hold on
% polar(-theta(1,:),abs(real(B(:,1+floor(NN/2)))'));
% hold off
% 
% title('Magnetic induction field as function of colatitude');
% 
% figure
% x=abs(real(B)).*(sin(theta)'*cos(phi));
% y=abs(real(B)).*(sin(theta)'*sin(phi));
% z=abs(real(B)).*(cos(theta)'*II);
% 
% 
% handle=surf(x,y,z,real(B))
% colorbar
% hold on
% set(handle,'edgecolor','none','facecolor','interp');
% title('Magnetic induction field as function of colatitude');
