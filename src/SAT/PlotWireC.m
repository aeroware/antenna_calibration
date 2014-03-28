
function [Lines,Points]=PlotWireC(Geom,Desc,Curr,Segs,k,NperSeg)

% PlotWireC(Geom,Desc,Curr,Segs,k,NperSeg) plots currents through 
% given segments. The given segments are stringed together to give a 
% wire along the abscissa. The ordinate represents the real and 
% imaginary part, which are drawn as a function of the location. 
% k is the wavenumber (2pi/wavelength). As a last argument (NperSeg) 
% the number of interpolation points used per segment 
% can but need not be given (default is 10).
% Lines and Points return handles to the plotted objects.

if nargin<4, return, end

h=ishold;
if ~h, clf; hold on; end

if nargin<6,
  NperSeg=10;
end

if nargin<5,   
  k=2*pi;      % default wavelength is 1 meter
end;

n1=Geom(Desc(Segs,1),:);
n2=Geom(Desc(Segs,2),:);

C12=Curr(Segs,:);

x=[];                     % location on joined segments
C=[];                     % current at x
L=zeros(1,length(Segs));  % lengths of segments
n=L;                      % number of points per segment

xend=0;

for s=1:length(Segs),
  if s==1,
    if length(Segs)>1,                           % ensure that 2. segment 
    if (n1(1,:)==n1(2,:)) | (n1(1,:)==n2(2,:)),  % can be connected by
      [n1(1,:),n2(1,:)]=deal(n2(1,:),n1(1,:));   % interchanging nodes of 
      C12(s,:)=-fliplr(C12(s,:));                % 1. segment if wrong oriented
    end, end
  else
    if n2(s,:)==n2(s-1,:),  % find out if nodes need be interchanged
      n2(s,:)=n1(s,:);      % for a correct connection to previous segment
      n1(s,:)=n2(s-1,:);
      C12(s,:)=-fliplr(C12(s,:));
    end
  end
  L(s)=norm(n2(s,:)-n1(s,:));  
  n(s)=max(NperSeg,round(20*L(s)*k/2/pi)); % use at least 20 points/wavelength
  xr=(0:1/(n(s)-1):1)*L(s);
  x=[x,xend+xr];
  xend=x(end);
  C=[C,InterpC(xr,L(s),C12(s,:),k)];
end

Lines=plot(x,real(C),'-b',x,imag(C),'--r');

legend(Lines,'Real(I)','Imag(I)');

xlabel('Length [m]');
ylabel('Current [A]');

n=[1,cumsum(n)];
Points=plot(x(n),real(C(n)),'.b',x(n),imag(C(n)),'.r');

if ~h, hold off; end
  

