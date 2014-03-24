function S=RadPower(a,b)
load temp

S=0;
for(n=1:N)           
    %S_new=(Z0/2)*(((k*I(n)*l(n))/(4*pi))*((k*I(n)*l(n))/(4*pi))')*sin(theta(t))^2;
     S=S+(Z0/2)*abs((k*I(n)*l(n))/(4*pi))^2.*sin(a).^3;
 end
