
function VarSave(f,v,n,VarName,OneFile)

% VarSave(f,v,n,VarName) writes v to the file f using variable name
% VarName or VarName_n: If n is an array, v must be an array of same size; 
% in this case each element of v is stored in an own variable, VarName_n, 
% uniquely identified by the numbers n. If n is scalar, v is saved as a 
% whole in VarName_n; if n is not defined, no numbers are added to the VarName.
% 
% VarSave(f,v,n,VarName,0) writes elements of v to separate files, 
% appending _n to the filename f, so the filenames identify the various stored 
% variables and the same variable name VarName is used in all saved files.
%
% n must be integer <=999999.
%
% Defaults: n=[] (no numbers appended), VarName='x'.
%
% Extensions of f are substituted by the extension 'mat'.

Delimiter='_';  % used as delimiter prior to the number n

if (nargin<5)|isempty(OneFile),
  OneFile=1;
end

if (nargin<4)|isempty(VarName),
  VarName='x';
end

if nargin<3,
  n=[];
end

[pa,na,ex]=fileparts(f);
if ~exist(pa,'dir')&~isempty(pa),
  s=mkdir(pa);
end

p=prod(size(n));
m=prod(size(v));

if OneFile, % all variables in one file
  
  ff=fullfile(pa,[na,'.mat']);
  
  if isempty(n)|isequal(p,1),
    if ~isempty(n),
      VarName=[VarName,Delimiter,num2str(n,'%06d')];
    end
    eval([VarName,'=v;']);
    if exist(ff,'file'),
      save(ff,VarName,'-append');
    else
      save(ff,VarName);
    end
    return
  end
  
  if m~=p,
    error('Variable- and number-array must be of same length.');
  end
  
  for k=1:m,
    vn=[VarName,Delimiter,num2str(n(k),'%06d')];
    eval([vn,'=v(k);']);
    if exist(ff,'file'),
      save(ff,vn,'-append');
    else
      save(ff,vn);
    end

  end
  
else % each variable stored into an own file
  
  if isempty(n)|isequal(p,1),
    if isempty(n), 
      ff=fullfile(pa,[na,'.mat']);
    else
      ff=fullfile(pa,[na,Delimiter,num2str(n,'%06d.mat')]);
    end
    eval([VarName,'=v;']);
    save(ff,VarName);
    return
  end
  
  if m~=p,
    error('Variable- and number-array must be of same length.');
  end
  
  VarName0='v';
  if isequal(VarName,VarName0),
    VarName0='vv';
    vv=v;
  end
  
  for k=1:m,
    ff=fullfile(pa,[na,Delimiter,num2str(n(k),'%06d.mat')]);
    eval([VarName,'=',VarName0,'(k);']);
    save(ff,VarName);
  end
  
end