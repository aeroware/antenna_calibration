
function varargout=EvaluateFun(f,varargin)

% varargout=EvaluateFun(f,p1,p2,..) evaluates
% f(p1,p2,...) if f is a function, 
% otherwise returns f unevaluated.

nout=max(1,nargout);

[ff,msg]=fcnchk(f);

if isempty(msg),
  [varargout{1:nout}]=ff(varargin{:});
else
  varargout={f};
end

