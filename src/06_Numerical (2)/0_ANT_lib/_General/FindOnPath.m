
function d=FindOnPath(fi,pa)

% d=FindOnPath(fi) finds the file with the name fi on
% the MATLAB search path and returns the directories where
% fi has been found in the cell array d. 
% If the file is not on the path, d={} is returned.
%
% d=FindOnPath(fi,pa) does the same assuming the path pa.

if ~exist('pa','var'),
  pa=path;
end

pa=Path2Cell(pa);

[p,fi,ext]=fileparts(fi);
fi=[fi,ext];

d={};

for n=1:numel(pa),
  
  fis=dir(pa{n});
  fis={fis.name};
  
  if ismember(upper(fi),upper(fis)),
    d=[d;pa{n}];
  end
  
end

