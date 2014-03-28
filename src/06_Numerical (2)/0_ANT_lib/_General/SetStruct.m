
function s=SetStruct(s1,s2,n1,n2)

% s=SetStruct(s1,s2) sets s to the structure array s1, extended
% by the fields of s2. Fields of s1 also present in s2 are overwritten
% by the respective fields of s2.
%
% s=SetStruct(s1,s2,n1,n2) does the same for the structure sub-arrays 
% s1(n1{:}) and s2(n2{:}). n1 and n2 are corresponding lists of
% ranges for each dimension. n1 and n2 must define subarrays of the 
% same size. Elements created to represent the new structure s but
% not overwritten by elements of s2(n2{:}) are set empty.
%
% s=SetStruct(s1,s2,n1) is the same as s=SetStruct(s1,s2,n1,n2)
% with n2={1:size(s2,1),...,1:size(s2,ndims(s2))}

% Rev. Feb. 2008:
% input parameter order (s1,n1,s1,n2) changed to (s1,s2,n1,n2);
% does not work for appending of s2 to s1 any longer, 
% use AppStruct for this purpose;
% does not force column-vector for vectorial result s.

if nargin==0,
  s=struct([]);
  return
end

s=s1;

if nargin==1,
  return 
end

if (nargin==2)||(nargin==3),
  n2=num2cell(size(s2));
  for m=1:length(n2),
    n2{m}=1:n2{m};
  end
end

if nargin==2,
  n1=n2;
end

f2=fieldnames(s2);

if isempty(f2)||isempty(n1)||isempty(n2)||isempty(s2),
  return
end

% detour using string n1s instead of n1{:}, for
% n1{:} cannot be used on the left side of assignments:

n1s='n1{1}';  
for m=2:length(n1),
  n1s=[n1s,',n1{',num2str(m),'}'];
end

% assignment:

for m=1:length(f2),
  eval(['[s(',n1s,').',f2{m},']=deal(s2(n2{:}).',f2{m},');']);
end

% if (ndims(s)==2)&&(size(s,1)==1),
%   s=s'; 
% end
