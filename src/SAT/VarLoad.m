
function [v,stat,vs,nn]=VarLoad(f,n,VarName,OneFile,Delimiter)

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
%
% vs returns a cell vector of the sizes of the read variables,
% nn is a vector of the numbers associated to the read variables (0 for
% variables without number associated).

if nargin<5,
  Delimiter='_';  % used as delimiter prior to the number n
end

if (nargin<4)|isempty(OneFile),
  OneFile=1;
end

if (nargin<3)|isempty(VarName),
  VarName='x';
end

if nargin<2,
  n=[];
end
if ischar(n),
  n=lower(n);
end

[pa,na,ex]=fileparts(f);
if ~exist(pa,'dir')&~isempty(pa),
  error('Path of file not found.');
end

p=prod(size(n));

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
    n1=length(VarName)+1;             % n1 = index of first char of number
  elseif ischar(n)&isequal(n(1),'a'),
    vn=[VarName,'*'];
    n1=length(VarName)+1;  
  elseif ischar(n)&isequal(n(1),'n'),
    vn=[VarName,Delimiter,'*'];
    n1=length(VarName)+2;  
  else
    vn=num2str(n(:),'%06d');
    vn=[repmat([VarName,Delimiter],p,1),vn];
    n1=length(VarName)+2;  
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
  
  nnn=sscanf(fn{1}(n1:end),'%d',1);
  if isempty(nnn), nnn=0; end
  nn=nnn;
  vv=getfield(s,fn{1});
  vs={size(vv)};
  v=vv(:);
  for k=2:length(fn),
    nnn=sscanf(fn{k}(n1:end),'%d',1);
    if isempty(nnn), nnn=0; end
    nn(end+1)=nnn;
    vv=getfield(s,fn{k});
    vs{end+1}=size(vv);
    v=[v;vv(:)];
  end
  
else % each variable stored into an own file
  
%   ff=fullfile(pa,[na,'.mat']);
%   if ~exist(ff,'file'),
%     stat=bitset(stat,3);
%     return
%   end
  
  if isempty(n),
    ff=fullfile(pa,[na,'.mat']);
    n1=length(fullfile(pa,na))+1;      % n1 = index of first char of number
  elseif ischar(n)&isequal(n(1),'a'),
    ff=fullfile(pa,[na,'*.mat']);
    n1=length(fullfile(pa,na))+1;
  elseif ischar(n)&isequal(n(1),'n'),
    ff=fullfile(pa,[na,Delimiter,'*.mat']);
    n1=length(fullfile(pa,[na,Delimiter]))+1;
  else
    vn=num2str(n(:),'%06d');
    ff=fullfile(pa,[na,Delimiter]);
    ff=[repmat(ff,p,1),vn,repmat('.mat',p,1)];
    n1=length(fullfile(pa,[na,Delimiter]))+1;
  end
  ff=cellstr(ff);
  
  fn={};
  for k=1:length(ff),
    q=dir(ff{k});
    qn={q.name};
    for k=1:length(qn),
      qn{k}=fullfile(pa,qn{k});
    end
    fn=[fn,qn];
  end
  fn=unique(fn);
  
  if isempty(fn),
    stat=bitset(stat,4);
    return
  end
  
  for k=1:length(fn),
    
    w=warning('off');
    s=load(fn{k},VarName);
    warning(w);
    
    q=fieldnames(s);
    
    if ~isempty(q),
      nnn=sscanf(fn{k}(n1:end),'%d',1);
      if isempty(nnn), nnn=0; end
      if k==1,
        nn=nnn;
        vv=getfield(s,q{1});
        vs={size(vv)};
        v=vv(:);
      else
        nn(end+1)=nnn;
        vv=getfield(s,q{1});
        vs{end+1}=size(vv);
        v=[v;vv(:)];
      end
    end
    
  end
  
  if isempty(v),
    stat=bitset(stat,5);
  end
  
end

