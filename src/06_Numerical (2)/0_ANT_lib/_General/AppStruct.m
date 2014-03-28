
function s=AppStruct(s1,s2)

% s=AppStruct(s1,s2) appends structure array s2 to structure array s1,
% giving a structure array s which contains the fields of 
% both s1 and s2. The resulting s is a structure column vector.

% Written Feb. 2008 (formerly part of SetStruct)

if nargin==0,
  s=[];
  return
end

s=s1(:);

if nargin==1,
  return 
end

n2={1:numel(s2)};
n1={n2{1}+numel(s)};

s=SetStruct(s1(:),s2(:),n1,n2);

s=s(:);

