
function r=SphPart(t1,t2,nt,p1,p2,np,PhiLines,NoOverlap);

% r=SphPart(t1,t2,p1,p1) returns unit vectors that cover a part
% of the unit sphere. The vectors are equally spaced in 
% theta (from t1 to t2) and phi (from p1 to p2) with 
% (nt-1) x (np-1) partitions. The returned matrix is of
% the form [r,t,p], where each row represents the spherical
% coordinates of one unit vector (r(:,1)=1).
% If a 7th argument unequal to 0 is given, phi- instead of 
% theta-lines are returned. Similarly, if NoOverlap gets a
% value unequal 0, the routine prevents the occurrence of equal 
% vectors if the first and last phi-value differ by 2*pi. In 
% this case np gives the number of segments per latitude.


if (nt<1) | (np<1), 
  r=[];
  return
end

if t1==t2,
  nt=1; t2=t1+1
elseif t1>t2, 
  [t1,t2]=deal(t2,t1); 
end

if p1==p2,
  np=1; p2=p1+1;
elseif p1>p2, 
  [p1,p2]=deal(p2,p1); 
end


if nargin<8, NoOverlap=0; end

if NoOverlap,
  if p2-p1>2*pi-1e-5,   
    p2=p1+2*pi/np*(np-1);  % ensure that no phi-overlap occurs
  end
end


n=nt*np;

dt=(t2-t1)/max((nt-1),1);
dp=(p2-p1)/max((np-1),1);

r=ones(n,3);

if nargin<7, PhiLines=0; end

if ~PhiLines,
  r(:,2)=reshape((t1+(0:nt-1)*dt)' * ones(1,np),n,1);
  r(:,3)=reshape(ones(nt,1) * (p1+(0:np-1)*dp) ,n,1);
else
  r(:,2)=reshape(ones(np,1) * (t1+(0:nt-1)*dt),n,1);
  r(:,3)=reshape((p1+(0:np-1)*dp)' * ones(1,nt),n,1);
end


