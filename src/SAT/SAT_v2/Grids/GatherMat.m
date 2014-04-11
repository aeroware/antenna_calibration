
function M=GatherMat(C,Len)

% M=GatherMat(C) converts cell array of double arrays into the 
% matrix M by building the following arrangement:
%   [C{1}(:).'; C{2}(:).'; ...]
% whereby the final rows are padded with zeros where necessary to 
% get the same length for all rows. The double arrays may also be 
% cell arrays of ... of double arrays; in this case Gather is used 
% to construct the double vectors which represent the final rows.
%
% M=GatherMat(C,Len) Here Len is an optional parameter defining the 
% row length of the returned matrix M. If not given, the row length 
% is the length of the longest double vector C{k}(:) for all k so 
% that C is completely contained in M.

if ~iscell(C),
  C={C};
end

if (nargin<2),
  Len=inf;
end

Rows=prod(size(C));

CC=cell(Rows,1);
RL=zeros(Rows,1);

for n=1:Rows,
  CC{n}=Gather(C{n});
  RL(n)=length(CC{n});
end

if isempty(Len)|ischar(Len)|isinf(Len),
  Len=max(RL);
end

M=zeros(Rows,Len);

if isempty(M),
  return
end

RL=min(RL,Len);

for n=1:Rows,
  M(n,1:RL(n))=CC{n}(1:RL(n)).';
end

