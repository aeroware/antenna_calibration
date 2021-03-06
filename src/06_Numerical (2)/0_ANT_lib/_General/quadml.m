
function [Q,fcnt]=quadml(funfcn,a,b,tol,trace,varargin)

% [Q,fcnt]=quadml(funfcn,a,b,tol,trace,varargin) performs
% a multi-interval Lobatto-Kronrod quadrature, working like
% quadl, except that these additional features are implemented:
% a and b may be vectors defining several intervals,
%  [a(1),b(1)], ...  [a(end),b(end)],
% Q returning the sum of the integrals over all given intervals.
% tol may be an absolute tolerance (scalar) or a 2-element vector
% where tol(1) is the absolute and tol(2) the relative tolerance.
% The routine stops when the error is less than tol(2)*Q+tol(1).
%
% quadml profits more from vectorization than quadl, 
% so its much faster but needs a lot of memory.
% quadml can also handle complex-valued functions accurately, 
% in contrary to quadl of Matlab ver. 6!

f=fcnchk(funfcn);

if ~exist('tol','var')||isempty(tol), 
  tol=[1e-6,0];               % [absolute, relative tolerance]
elseif length(tol)==1,
  tol=[tol,0];
end
tol=abs(tol);

if ~exist('trace','var')||isempty(trace), 
  trace=0; 
end

maxfcnt=1e5;
hmin=eps/1024*max(abs(b(:)-a(:)));
MaxRecursions=25;
MaxIntervals=2000;  

% initialize for recursion:

a=a(:);
b=b(:);
ni=length(a);

if ni==1,
  
  % Initial step to estimate Q with 13 function evaluations:
  
  c=(a+b)/2;
  h=(b-a)/2;
  
  s=[.942882415695480 sqrt(2/3) .641853342345781 1/sqrt(5) .236383199662150];
  xx=[a c-h*s c c+h*fliplr(s) b].';
  yy=feval(f,xx,varargin{:}); 
  yy=yy(:);
  
  fcnt=13;
  
  Q1=(h/6)*[1 5 5 1]*yy(1:4:13);
  Q2=(h/1470)*[77 432 625 672 625 432 77]*yy(1:2:13);
  
  s=[.0158271919734802 .094273840218850 .155071987336585 ...
     .188821573960182  .199773405226859 .224926465333340];
  w=[s .242611071901408 fliplr(s)];
  Q=h*w*yy;
  
  tola=abs(tol(1))+abs(tol(2)*Q);
  
  % Increase absolute tolerance if refinement was effective
  % (comment out if necessary):
  
  r=abs(Q2-Q)/abs(Q1-Q+realmin);
  if (r>0)&&(r<1),
    tola=tola/max(0.001,r);
  end
  tol(1)=tola;
  
  if abs(Q2-Q)<=tola,  % Check if accuracy of integral reached
    return             % (comment out if necessary)
  end
  
  xx=xx(1:2:13);
  yy=yy(1:2:13);
  
  ni=length(xx)-1;
  N=1:ni;
  MaxIntervals=max(MaxIntervals,ni);
  
  y=zeros(MaxIntervals,7);
  y(N,1)=yy(1:end-1);
  y(N,7)=yy(2:end);
  
  x=zeros(MaxIntervals,7);
  x(N,1)=xx(1:end-1);
  x(N,7)=xx(2:end);
  
else  
  
  % No initial step and tol-refinement if several intervals given
  
  [xx,yy,c]=unique([a;b]);
  yy=feval(f,xx,varargin{:});
  
  fcnt=length(yy);
  
  N=1:ni;
  MaxIntervals=max(MaxIntervals,ni);
  
  y=zeros(MaxIntervals,7);
  y(N,1)=yy(c(N));
  y(N,7)=yy(c(N+ni));
  
  x=zeros(MaxIntervals,7);
  x(N,1)=a;
  x(N,7)=b;
  
end

alpha=sqrt(2/3);
beta=1/sqrt(5);
c=zeros(MaxIntervals,1);
h=c;

Q=0;

% recursion loop:

for r=1:MaxRecursions,  
  
  c(N)=(x(N,1)+x(N,7))/2;
  h(N)=(x(N,7)-x(N,1))/2;
  
  if any(abs(h(N))<hmin | c(N)==x(N,1) | c(N)==x(N,7)) 
    Q=Q+sum(h(N).*(y(N,1)+y(N,7)));
    warning('Minimum step size reached; singularity possible.')
    return
  end
  
  % Subdivide into six subintervals:
  
  x(N,2:6)=[c(N)-alpha*h(N),c(N)-beta*h(N),c(N),c(N)+beta*h(N),c(N)+alpha*h(N)];
  
  y(N,2:6)=feval(f,x(N,2:6),varargin{:});
  
  fcnt=fcnt+5*ni;
  
  % Four point Lobatto quadrature:
  
  Q1(N)=(y(N,1:2:7)*[1;5;5;1]).*h(N)/6;
  
  % Seven point Kronrod refinement:
  
  Q2(N)=(y(N,:)*[77;432;625;672;625;432;77]).*h(N)/1470;
  
  Qest=Q+sum(Q2(N));
  
  if any(~isfinite(Q2)),
    Q=Qest;
    warning('Infinite or Not-a-Number function value encountered.')
    return
  end
    
  % Check accuracy of integral over the subintervals:
  
  na=find(abs(Q1(N)-Q2(N))<=tol(2)*abs(Qest)+tol(1));
  Q=Q+sum(Q2(na));
  
  na=find(abs(Q1(N)-Q2(N))>tol(2)*abs(Qest)+tol(1));
  
  if trace,
%    fprintf('%18.8e %18.8e %18.8e %18.8e %18.8e\n',x(N,1));
    if isequal(r,1),
      fprintf('%10s %10s %10s %23s %23s\n',...
        'rec-level','intervals','f-count','real(Qestimated)','imag(Qestimated)');
    end
    fprintf('%10d %10d %10d %23.15e %23.15e\n',r,ni,fcnt,real(Qest),imag(Qest));
  end
  
  if isempty(na),
    return
  end
  
  if fcnt>maxfcnt
    Q=Qest;
    warning('Maximum function count exceeded; singularity likely.')
    return
  end
  
  % rearrange subintervals:
  
  ni=length(na);
  
  x(1:ni,:)=x(na,:);
  x(1:6*ni,7)=reshape(x(1:ni,2:7),6*ni,1);
  x(ni+1:6*ni,1)=x(1:5*ni,7);
  
  y(1:ni,:)=y(na,:);
  y(1:6*ni,7)=reshape(y(1:ni,2:7),6*ni,1);
  y(ni+1:6*ni,1)=y(1:5*ni,7);
  
  ni=6*ni;
  N=1:ni;
  
end % recursion loop

warning('Maximum number of recursions exceeded!');
Q=Qest;

