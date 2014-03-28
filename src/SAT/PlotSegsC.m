
function heff=PlotSegsC(Geom,Desc,Curr,Segs,k,Part,ArrowSize)

% Plot current vectors parallel to given segments. The plotted 
% vector length is proportional to the current magnitude.

if nargin<4, return, end

h=ishold;
if ~h, clf; hold on; end

if nargin<5, 
  k=2*pi, 
elseif isempty(k),
  k=2*pi, 
end

if nargin<6, Part='ri'; end
Part=lower(Part);

if nargin<7,
  ArrowSize=0.5;   % Maximum size of arrows in meters
end


p=(Geom(Desc(Segs,2),:)+Geom(Desc(Segs,1),:))/2;  % centers of segments

ds=Geom(Desc(Segs,2),:)-Geom(Desc(Segs,1),:);     % vectorial elements 

L=sqrt(sum(ds'.^2))';               % Lengths of segments 

C=InterpC(0.5*L,L,Curr(Segs,:),k);  % Currents at the segment-centers

heff=sum(diag(C)*ds);

C=C/max(abs(C))*ArrowSize;

if findstr(Part,'r'),
  Q=diag(real(C)./L)*ds;
  quiver3(p(:,1),p(:,2),p(:,3), Q(:,1),Q(:,2),Q(:,3),0,'b');
end

if findstr(Part,'i'),
  Q=diag(imag(C)./L)*ds;
  quiver3(p(:,1),p(:,2),p(:,3), Q(:,1),Q(:,2),Q(:,3),0,'r');
end

if ~h, hold off; end


