
% TestFitPoly

x=(1:10)'; 

for k=1:5;
  xx=x+(rand(size(x))-0.5)*2;
  a=[0.2,0.3,0.4,7,9]'; 
  y(:,k)=[ones(size(xx)),xx,xx.^2,xx.^3,xx.^4]*a+k*1e5;
end

[p,r]=PolyFitM(x,y,3)

xx=0:0.1:10;
yy=PolyVAlM(p,xx);

plot(x,y,'.'); 
hold on; 
plot(xx,yy); 
hold off

