
function [Q,fcnt]=quadrl(funfcn,a,b,tol,trace,varargin)

% [Q,fcnt]=quadrl(f,a,b,tol,trace,varargin) performs
% a Lobatto-Kronrod quadrature of the function f from a to b.
% tol may be an absolute tolerance (scalar) or a 2-element vector
% where tol(1) is the absolute and tol(2) the relative tolerance.
% The routine recursively calculates the quadrature estimate Q,
% stopping iteration when the error is less than tol(2)*Q+tol(1).
% Set trace=1 for output of intermediate results. 
% fcnt returns the number of function evaluations performed.
% In contrast to quadl (MATLAB vers. 6), this routine also correctly 
% works for complex-valued functions.

f=fcnchk(funfcn);

if nargin<4 | isempty(tol), 
  tol=[0,1e-6];               % [absolute, relative tolerance]
elseif length(tol)==1,
  tol=[tol,0];
end

if (nargin<5)|isempty(trace), 
  trace=0; 
end

% Initial step to estimate Q with 13 function evaluations:

c=(a+b)/2;
h=(b-a)/2;

s=[.942882415695480 sqrt(2/3) .641853342345781 1/sqrt(5) .236383199662150];
x=[a c-h*s c c+h*fliplr(s) b].';
y=feval(f,x,varargin{:}); 
y=y(:);

fcnt=13;

Q1=(h/6)*[1 5 5 1]*y(1:4:13);
Q2=(h/1470)*[77 432 625 672 625 432 77]*y(1:2:13);

s=[.0158271919734802 .094273840218850 .155071987336585 ...
   .188821573960182  .199773405226859 .224926465333340];
w=[s .242611071901408 fliplr(s)];
Q=h*w*y;

tol=abs(tol(1))+abs(tol(2)*Q);

% Increase tolerance if refinement was effective
% (comment out if necessary):

r=abs(Q2-Q)/abs(Q1-Q+realmin);
if (r>0)&(r<1),
  tol=tol/max(0.001,r);
end

if abs(Q2-Q)<=tol,  % Check if accuracy of integral reached
  return            % (comment out if necessary)
end

hmin=eps/1024*abs(b-a);
w=4*(~isfinite(Q));
Q=0;
for k=1:2:11,
  if bitand(w,4),   
    break,          % Inf or NaN function value encountered
  end
  [Qk,fcnt,wk]=...
    quadrl_1(f,x(k),x(k+2),y(k),y(k+2),tol,trace,fcnt,hmin,varargin{:});
  Q=Q+Qk;
  w=bitor(w,wk);
end

if w==0, return, end

if bitand(w,1),
  warning('MATLAB:quadrl:MinStepSize','Minimum step size reached.');
end
if bitand(w,2),
  warning('MATLAB:quadrl:MaxFcnCount','Maximum function count exceeded.');
end
if bitand(w,4),
  warning('MATLAB:quadrl:ImproperFcnValue','Inf or NaN function value encountered.');
end



function [Q,fcnt,w]=quadrl_1(f,a,b,fa,fb,tol,trace,fcnt,hmin,varargin)

maxfcnt=1e5;

alpha=sqrt(2/3);
beta=1/sqrt(5);

c=(a+b)/2;
h=(b-a)/2;

if (abs(h)<hmin)|(c==a)|(c==b),  % Minimum step size reached
  Q=h*(fa+fb);
  w=1;
  return
end

% Evaluate integrand in 5 interior points [a,b] and estimate integral:

x=[c-alpha*h c-beta*h c c+beta*h c+alpha*h].';
y=feval(f,x,varargin{:});
x=[a;x(:);b];
y=[fa;y(:);fb];

fcnt=fcnt+5;

Q1=(h/6)*[1 5 5 1]*y(1:2:7);               % 4-point Lobatto quadrature

Q=(h/1470)*[77 432 625 672 625 432 77]*y;  % 7-point Kronrod refinement

if trace,
  disp(sprintf('%8d %20.10e %20.10e %20.10e',fcnt,a,h,Q));
end

if ~isfinite(Q),       % Inf or NaN function value encountered
  w=4; 
  return
elseif fcnt>maxfcnt,   % Maximum function count exceeded
  w=2; 
  return
elseif abs(Q1-Q)<=tol, % Accuracy of integral over this subinterval reached
  w=0; 
  return
end

% Subdivide into six subintervals.

Q=0;
w=0;
for k=1:6,
  [Qk,fcnt,wk]=quadrl_1(f,x(k),x(k+1),y(k),y(k+1),tol,trace,fcnt,hmin,varargin{:});
  Q=Q+Qk;
  w=bitor(w,wk);
  if bitand(w,4),
    return
  end
end
