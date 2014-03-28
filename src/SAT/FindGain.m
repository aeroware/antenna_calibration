
function [t,p,G]=FindGain(Ant,Op,Gtarget,t0,p0,Tol,GainFun,varargin)

% [t,p,G]=FindGain(Ant,Op,Gtarget,t0,p0,Tol) finds the direction
% where the gain comes closest to the given value Gtarget.
% Set Gtarget=0 to find the direction of minimum gain, 
% and Gtarget=inf to find the direction of maximum gain.
% t, p and G return colatitude, azimuth and gain of the found 
% direction. 
% The search starts at t0, p0. The optional Tol sets the termination 
% tolerance on the angles, default: Tol=1e-3 (~6/100 degrees).
%
% FindGain(Ant,Op,Gtarget,t0,p0,Tol,GainFun,...) defines GainFun as
% the gain function to be used. It must be of the form  
% g=GainFun(Ant,Op,er,...), where er is a matrix of unit vectors in
% its rows which define the directions for which the gains are 
% calculated and returned in the vector g. The ... may be a list of 
% further arguments for GainFun.
% Default: GainFun='PowerGain'.

SimpleSearch=1;  % no transforms etc.

if (nargin<7)|isempty(GainFun),
  GainFun='PowerGain';
end

Gtarget=abs(Gtarget);

if (nargin<6)|isempty(Tol),
  Tol=1e-4;
end

opt=optimset('fminsearch');
opt=optimset(opt,'TolX',Tol,'MaxFunEvals',2e3,'MaxIter',2e3);


deg=pi/180;

if SimpleSearch,
  
  tp=[t0,p0];
  
  [tp,G,o1,o2]=fminsearch(@FindGainSearch0,tp,opt,Ant,Op,...
    Gtarget,GainFun,varargin{:});
  if o1==0,
    warning('Search failed, maximum number of iterations was reached.');
    fprintf(1,'funcCount=%d, iterations=%d\n',o2.funcCount,o2.iterations);
  end
  
  t=tp(1);
  p=tp(2);
  
  [x,y,z]=sph2cart(p,pi/2-t,1);
  
  G=feval(GainFun,Ant,Op,[x,y,z],varargin{:});
  
  return
  
end

Transform=abs(sin(t0))<sin(15*deg);
if Transform,
  [x,y,z]=sph2cart(p0,pi/2-t0,1);
  [p0,t0,z]=cart2sph(y,z,x);
  t0=pi/2-t0;
end

tp=[t0,abs(sin(t0))*p0];

[tp,G,o1,o2]=fminsearch(@FindGainSearch,tp,opt,Ant,Op,...
  Gtarget,Transform,GainFun,varargin{:});
if o1==0,
  warning('Search failed, maximum number of iterations was reached.');
  fprintf(1,'funcCount=%d, iterations=%d\n',o2.funcCount,o2.iterations);
end

t=tp(1);
p=tp(2);
if abs(sin(t))==0,
  p=0;
else
  p=p/abs(sin(t));
end
[x,y,z]=sph2cart(p,pi/2-t,1);
if Transform,
  er=[z,x,y];
else
  er=[x,y,z];
end

[p,t,z]=cart2sph(er(1),er(2),er(3));
t=pi/2-t;

G=feval(GainFun,Ant,Op,er,varargin{:});


function [d,t,p]=FindGainSearch0(tp,Ant,Op,G,GainFun,varargin)

t=tp(1);
p=tp(2);

[x,y,z]=sph2cart(p,pi/2-t,1);

if isinf(G),
  d=-feval(GainFun,Ant,Op,[x,y,z],varargin{:});
else
  d=abs(feval(GainFun,Ant,Op,[x,y,z],varargin{:})-G);
end


function [d,t,p]=FindGainSearch(tp,Ant,Op,G,Transform,GainFun,varargin)

t=tp(1);
p=tp(2);
if abs(sin(t))==0,
  p=0;
else
  p=p/abs(sin(t));
end
[x,y,z]=sph2cart(p,pi/2-t,1);
if Transform,
  er=[z,x,y];
else
  er=[x,y,z];
end

if isinf(G),
  d=-feval(GainFun,Ant,Op,er,varargin{:});
else
  d=abs(feval(GainFun,Ant,Op,er,varargin{:})-G);
end

