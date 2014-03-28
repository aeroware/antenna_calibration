
function Ant=GridSphere(r,t1,t2,nt,p,np,npmin)

% Ant=GridSphere(r,t1,t2,nt,p,np,npmin) draws a 
% section of a sphere with center (0,0,0), radius r and 
% angular extent abs(t2-t1) and p in colatitude and azimuth, 
% respectively. The section extends from azimuth 0 and 
% colatitude t1 to azimuth p  and colatitude t2. The whole 
% surface grid is composed of nt horizontal polygons 
% (representing circular arcs) around the z-axis and 
% segments connecting the corners of successive polygons.
% np defines the number of segments to be used to represent 
% the horizontal polygons. A negative np sets the number 
% of segments of the first polygon (at latitude t1), 
% a positive np only estimates by its magnitude the number 
% of segments to be used for the widest horizontal polygon. 
% The actual number of segments is suitably adjusted so 
% that segment lengths do not vary too much. By npmin the 
% minimum number of segments to be used for horizontal 
% polygons can be defined. If the number of segments
% shall not be automatically adjusted, pass npmin=0.
% All parameters except r are optional, default values: 
% t1=0; t2=pi; p=2*pi; if one of the parameters np or 
% nt is not given, it is adjusted in such a way that 
% horizontal and meridian segments have similar length. 
% If both are omitted (or empty), nt is calculated to
% yield segments which extend about 18 degrees in latitude
% and np is adapted accordingly.
% Generally the following assumptions must hold: 
% 0<=t1,t2<=pi; t1~=t2.

% Revision June 2007:
% - Adaptation for change of meaning of sign(np) in GridRevol;
% - Subdivision of patches according to the global variable 
%   GlobalMaxPatchCorners (which is set to its default in GridInit)
%
% Revision Nov 2010 by Thomas Oswald:
% triangulize the patches


r=abs(r);

if (nargin<2)|isempty(t1),
  t1=0;
else
  t1=Bound(t1,0,pi);
end
if (nargin<3)|isempty(t2),
  t2=pi;
else
  t2=Bound(t2,0,pi);
end

if (nargin<5)|isempty(p),
  p=2*pi;
else
  p=p/2/pi;
  p=p-floor(p);
  if abs((p-1)*p)<1e-10,
    p=1;
  end
  p=p*2*pi;
end

if abs((t2-t1)*p)<1e-10, 
  error('Solid angle too small to generate spherical grid.');
end

if (nargin<7)|isempty(npmin)|(npmin==1)|(npmin<0),
  npmin=2;
end

% analyse and adapt nr and np:

Lt=abs(t2-t1);
if (t1-pi/2)*(t2-pi/2)<0,
  Lp=p;
else
  Lp=p*max(sin([t1,t2]));
end

nadj=0.9;  % exp. adjustment factor for Lp

if (nargin<6)|isempty(np),
  if (nargin<4)|isempty(nt),
    nt=10/pi*(t2-t1);
  end
  nt=max(1,ceil(abs(nt)));
  np=max(npmin,round(nadj*Lp*nt/Lt));    
else
  np=max(npmin,abs(np))*sign(np);
  if (nargin<4)|isempty(nt),
    if (np<0)|(npmin~=0),
      if sin(t1)>1e-5,
        Lp=p*sin(t1);
      elseif sin(t2)>1e-5,
        Lp=p*sin(t2);
      end
    end
    nt=max(1,ceil(abs(Lt*np/(nadj*Lp))));
  end
end 

if (np<0)&(npmin==0),
  np=repmat(np,nt+1,1);
end

% calculate z- and r-vector of first meridian:

z=r*cos(t1+(t2-t1)/nt*(0:nt)');
r=sqrt(r^2-z.^2);

% generate grid:

Ant=GridRevol(z,r,np,p,0,npmin);
Ant=Patch2Tri(Ant);
