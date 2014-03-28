
function [v,stat]=VarLoad(f,n,VarName,OneFile)

% v=VarLoad(f,n,VarName) reads variable with name VarName_n from file f.
% n is the number appended to the variable name for identification as used
% by the function VarWrite. The input parameter n may be a vector of numbers,
% each element representing a variable to be read. Set n='all' to read from f 
% all variables of the form VarName*, n='numbers' read all variables of
% the form VarName_n, n='' reads only VarName.
%
% v=VarLoad(f,n,VarName,0) appends the numbers n to f instead of to VarName, 
% reading the variable VarName from the files f_n. So it works, unlike the
% former version, with several files but only with one variable per file.

NumberFormat='%06d';  % format of the number appended to the variable name
Delimiter='_';        % used as delimiter prior to the number n

if (nargin<4)||isempty(OneFile),
  OneFile=1;
end

if (nargin<3)||isempty(VarName),
  VarName='x';
end

if nargin<2,
  n=[];
end
if ischar(n),
  n=lower(n);
end

[pa,na,ex]=fileparts(f);
if ~exist(pa,'dir')&&~isempty(pa),
  error('Path of file not found.');
end

p=numel(n);

v=[];
stat=0;

if OneFile, % all variables in one file
  
  ff=fullfile(pa,[na,'.mat']);
  if ~exist(ff,'file'),
    stat=bitset(stat,1);
    return
  end
  
  if isempty(n),
    vn=VarName;
  elseif ischar(n)&&isequal(n(1),'a'),
    vn=[VarName,'*'];
  elseif ischar(n)&&isequal(n(1),'n'),
    vn=[VarName,Delimiter,'*'];
  else
    vn=num2str(n(:),NumberFormat);
    vn=[repmat([VarName,Delimiter],p,1),vn];
  end
  vn=cellstr(vn);
  
  w=warning('off');
  s=load(ff,vn{:});
  warning(w);
  
  fn=fieldnames(s);
  if isempty(fn),
    stat=bitset(stat,2);
    return
  end
  fn=sort(fn);
  
  vv=s.(fn{1});
  v=vv(:);
  for k=2:length(fn),
    vv=s.(fn{k});
    v=[v;vv(:)];
  end
  
else % each variable stored into an own file
  
  ff=fullfile(pa,[na,'.mat']);
  if ~exist(ff,'file'),
    stat=bitset(stat,1);
    return
  end
  
  if isempty(n),
    ff=fullfile(pa,[na,'.mat']);
  elseif ischar(n)&&isequal(n(1),'a'),
    ff=fullfile(pa,[na,'*.mat']);
  elseif ischar(n)&&isequal(n(1),'n'),
    ff=fullfile(pa,[na,Delimiter,'*.mat']);
  else
    vn=num2str(n(:),NumberFormat);
    ff=fullfile(pa,[na,Delimiter]);
    ff=[repmat(ff,p,1),vn,repmat('.mat',p,1)];
  end
  ff=cellstr(ff);
  
  fn={};
  for k=1:length(ff),
    q=dir(ff{k});
    fn=[fn,{q.name}];
  end
  fn=unique(fn);
  
  if isempty(fn),
    stat=bitset(stat,1);
    return
  end
  
  for k=1:length(fn),
    
    w=warning('off');
    s=load(fn{k},VarName);
    warning(w);
    
    q=fieldnames(s);
    
    if ~isempty(q),
      if k==1,
        vv=s.(q{1});
        v=vv(:);
      else
        vv=s.(q{1});
        v=[v;vv(:)];
      end
    end
    
  end
  
  if isempty(v),
    stat=bitset(stat,2);
  end
  
end

