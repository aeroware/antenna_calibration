function [x,y,z,E,H]=FieldImage3Sphere(Ant,Op,Or,Radius,NRadius,NTheta,Theta1,Theta2,Phi1,Phi2)

% [x,y,z,E,H]=FieldImage3Sphere(Ant,Op,Or,Radius,NRadius,Ntheta) 
% calculates the fields for a points lying on a sphere with the center
% at Or and radius=Radius. NRadius determines the number of points
% on the equator, NTheta the number of paralells.

x=0;
y=0;
z=0;

NRadius=NRadius+1;
NTheta=NTheta+1;

for n=1:NTheta
    RadSmall=Radius*sin(Theta1+n*(Theta2-Theta1)/NTheta);%sin(n*pi/NTheta);
    nr=floor(NRadius*sin(n*pi/NTheta));
    for nnr=1:nr
        x=[x,RadSmall*cos(Phi1+nnr*(Phi2-Phi1)/nr)];
        y=[y,RadSmall*sin(Phi1+nnr*(Phi2-Phi1)/nr)];
        z=[z,Radius*cos(Theta1+(n-1/2)*(Theta2-Theta1)/NTheta)];
    end
end

%x=[x,0];               %points on the poles
%y=[y,0];
%z=[z,Radius];
%x=[x,0];
%y=[y,0];
%z=[z,-Radius];

x=x'-repmat(Or(1),length(x),1);
y=y'-repmat(Or(2),length(y),1);
z=z'-repmat(Or(3),length(z),1);

x=x(2:end);
y=y(2:end);
z=z(2:end);

[E,H]=FieldNear(Ant,Op,[x,y,z]);