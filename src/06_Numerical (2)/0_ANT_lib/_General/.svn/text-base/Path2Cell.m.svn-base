
function c=Path2Cell(p,Option)

% c=Path2Cell(p) converts the path p to a cell array of strings 
% where each cell element contains one directory.
% 
% c=Path2Cell(p,'KeepAll') allows for empty entries and returns them as well
% (empty entries appear when two delimiters have no other characters in
% between).

Delimiter=';';

if iscell(p),
  c=p;
  return
end

if ~exist('Option','var'),
  Option='';
end
if isequal(upper(Option),upper('KeepAll'));
  KeepAll=1;
else
  KeepAll=0;
end

n=find(p==Delimiter);

if isempty(n),
  
  c={p};
  m=length(p);
  
else
  
  c=cell(length(n)+1,1);
  m=zeros(size(c));

  c{1}=p(1:n(1)-1);
  m(1)=n(1)-1;

  for q=1:length(n)-1,
    c{q+1}=p(n(q)+1:n(q+1)-1);
    m(q+1)=n(q+1)-n(q)-1;
  end

  c{end}=p(n(end)+1:end);
  m(end)=length(p)-n(end);

end

if ~KeepAll,
  c=c(m~=0);
end

