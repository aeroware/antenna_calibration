
function [Found1,varargout]=FirstArgin(Test1,Default1,Default2,varargin)

% [Found1,oa1,oa2,...]=FirstArgin(Test1,Default1,Default2,ia1,ia2,...)
% Checks if the first of the input arguments ia1,ia2, etc. is
% such that Test1(ia1) evaluates to true. In this case
% Found1=ia1, oa1=ia2, oa2=ia3, etc.; otherwise
% Found1=Default1, oa1=ia1, oa2=ia2, etc.
% If there are not enough input arguments to set all oa1, oa2, etc.,
% the remaining oa's are put Default2.
% The function is useful to separate the first input argument
% of any function if it is optional and different from the second 
% in that Test1 evaluates to true for the first but not the 
% second argument.

% Written Feb. 2008

if ~isempty(varargin)&&feval(Test1,varargin{1}),
  Found1=varargin{1};
  n1=2;
else
  Found1=Default1;
  n1=1;
end

nn=min(length(varargin)-n1+1,nargout-1);

[varargout{1:nn}]=deal(varargin{n1:n1+nn-1});

[varargout{nn+1:nargout-1}]=deal(Default2);
