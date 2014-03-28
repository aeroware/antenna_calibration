
function Asap_CreateIn(PhysGrid,Freq,FeedNum,C,WorkingDir,AddCards)

% Asap_CreateIn(PhysGrid,Freq,FeedNum,C,WorkingDir)
% creates ASAP input file (filename in global variable Atta_Asap_In) 
% by translating given data into ASAP input format.
% Freq defines the operation frequency.
% C is an optional comment line which serves as a preamble. 
% PhysGrid defines the antenna system, the following fields of which 
% are used:
%
%   Geom .. N x 3, coordinates of grid nodes (x,y,z) 
%   Desc .. S x 2, grid segments (start node, end node)
%   Geom_.Feeds, Desc_.Feeds .. feeds at nodes and segments, respectively
%   Geom_.Loads, Desc_.Loads .. loads at nodes and segments, respectively
%   Desc_.Wire.Diam, Desc_.Wire.Cond, segment diameters and conductivities
%            (ASAP uses the value that appears most often)
%   Default.ASAP.Inte .. number of steps for simpson integration 
%            (0 causes analytic integration)
%   Exterior.epsr  .. dielectric constant of exterior medium
%
% FeedNum='all' signifies that all feeds 
% [PhysGrid.Geom_.Feeds.Elem,PhysGrid.Desc_.Feeds.Elem] are
% driven, namely by the respective voltages 
% [PhysGrid.Geom_.Feeds.V,PhysGrid.Desc_.Feeds.V].
% In case FeedNum is numeric, only the feed with the number FeedNum
% is driven by 1 Volt, the others are short-circuited, where
% the counting is according to the order in the concatenation
% [PhysGrid.Geom_.Feeds.Elem,PhysGrid.Desc_.Feeds.Elem]. 
% The fields PhysGrid.Geom_.Feeds.V and PhysGrid.Desc_.Feeds.V
% are ignored in this case.
%
% All physical quantities are supposed to be in SI-units!
%
% Default values are used for certain elements if omitted ore empty
% (the other elements must be defined):
%   Exterior.epsr=1, i.e. vacuum (Exte=(0,1))
%
% The wire conductivities may be inf indicating perfectly conducting wires. 
% If they are 0, a default value of 50e6 S/m is used 
% (e.g. Cu 64e6, Al 38e6, Fe ~10e6).
% Since ASAP can only manage one wire diameter and a fixed conductivity  
% over the whole antenna, it uses the most frequently occuring
% values in PhysGrid.Desc_.Diam and PhysGrid.Desc_.Cond, respectively.
%
% Asap_CreateIn(PhysGrid,Freq,WorkingDir,C,AddCards) 
% additionally inserts the cards AddCards before the output request 
% card OUTPUT(CURRENT) in the ASAP input file. The file is terminated 
% by the STOP card and a comment indicating when the file was generated.
%
% C and AddCards may be char matrices (each row a line), or 
% a cell vector of strings (each line in a separate cell).

global Atta_Asap_In

sig=8;  % Number of significant decimals to be used for ASAP format

deg=pi/180;

cL=2.99792458e8;
eps0=1/(4e-7*pi*cL^2);


if ~exist('C','var')||isempty(C),
  C={};
end

if ~exist('AddCards','var')||isempty(AddCards),
  AddCards={};
end


% open/create ASAP input file:
% ---------------------------

if ~exist('WorkingDir','var')||isempty(WorkingDir),
  WorkingDir='';
end

AIF=fullfile(WorkingDir,Atta_Asap_In);

fid=fopen(AIF,'wt');
if fid<0,
  error(['Could not open/create file ',AIF]);
end


% Preamble:
% ---------

if ~isempty(C),

  fprintf(fid,'C      \n');
  
  if ischar(C),
    C=cellstr(C);
  end

  for L=C(:).',
    fprintf(fid,'C      %s\n',L{:});
  end

  fprintf(fid,'C      \n');
  
end


% Wire:
% -----

Radius=mode(PhysGrid.Desc_.Diam)/2;   % take most frequently occuring radius
Cond=mode(PhysGrid.Desc_.Cond)/1e6;   % conductivity in MS/m!

if isequal(Cond,0),
  Cond=50;
elseif isinf(Cond),
  Cond=-1;
end

fprintf(fid,'WIRE(RADI=');
AsapFprintf(fid,sig,Radius);

fprintf(fid,'/COND=');
AsapFprintf(fid,sig,Cond);  

fprintf(fid,')\n');


% Insu(lation):
% -------------
% (not yet implemented in this version) 
%
% if isfield(PhysGrid,'Insu'),
%   if ~isempty(PhysGrid.Insu),
%     fprintf(fid,'INSU(RADI=');
%     AsapFprintf(fid,sig,PhysGrid.Insu(1,1));
%     fprintf(fid,'/COND=');    
%     AsapFprintf(fid,sig,PhysGrid.Insu(1,2)); % conductivity in S/m!
%     fprintf(fid,'/DIEL=');    
%     AsapFprintf(fid,sig,PhysGrid.Insu(1,3));
%     fprintf(fid,')\n');
%   end
% end


% Geom(etry):  
% -----------

fprintf(fid,'GXYZ\n');

f=sprintf('%%%d.%df ',sig+5,sig-1);

for L=1:size(PhysGrid.Geom,1),
  fprintf(fid,[f,f,f,' /%d\n'],PhysGrid.Geom(L,:),L);
end

fprintf(fid,'XXXX\n');


% Desc(ription):
% --------------

fprintf(fid,'DNOD\n');

for L=1:size(PhysGrid.Desc,1),
  fprintf(fid,'%4d %4d  /%d\n',PhysGrid.Desc(L,:),L);
end

fprintf(fid,'XXXX\n');


% Freq(uency):
% ------------

fprintf(fid,'FREQ(');

AsapFprintf(fid,sig,Freq/1e6);  % frequency in MHz!

fprintf(fid,')\n');


% Feed:
% -----

if ~exist('FeedNum','var')||isempty(FeedNum),
  FeedNum='all';
end
  
[V,q0,q1]=GetFeedVolt(PhysGrid,FeedNum);
V0=V(1:length(q0));
V1=V(1+length(q0):end);

if ~isempty(q0),
  fprintf(fid,'FEED(');
  N=find(V0~=0);
  for L=N(:).',
    fprintf(fid,'%d,',q0(L));
    AsapFprintf(fid,sig,abs(V0(L)));
    fprintf(fid,',');
    AsapFprintf(fid,sig,angle(V0(L))/deg);
    if L==N(end),
      fprintf(fid,')\n');
    else
      fprintf(fid,'/\n');
    end
  end
end
  
if ~isempty(q1),
  fprintf(fid,'GENE(');
  N=find(V1~=0);
  for L=N(:).',
    fprintf(fid,'%d,',q1(L));
    AsapFprintf(fid,sig,abs(V1(L)));
    fprintf(fid,',');
    AsapFprintf(fid,sig,angle(V1(L))/deg);
    if L==N(end),
      fprintf(fid,')\n');
    else
      fprintf(fid,'/\n');
    end
  end
end


% Load:
% -----

try
  q=PhysGrid.Geom_.Loads;
  Z=PhysGrid.Geom_.Z;
catch
  q=[];
end
if ~isempty(q),
  fprintf(fid,'LOAD(');
  N=length(q);
  for L=1:N,
    fprintf(fid,'%d,',q(L));
    AsapFprintf(fid,sig,abs(Z(L)));
    fprintf(fid,',');
    AsapFprintf(fid,sig,angle(Z(L))/deg);
    if L==N,
      fprintf(fid,')\n');
    else
      fprintf(fid,'/\n');
    end
  end
end
  
try
  q=PhysGrid.Desc_.Loads;
  Z=PhysGrid.Desc_.Z;
catch
  q=[];
end
if ~isempty(q),
  fprintf(fid,'IMPE(');
  N=length(q);
  for L=1:N,
    fprintf(fid,'%d,',q(L));
    AsapFprintf(fid,sig,abs(Z(L)));
    fprintf(fid,',');
    AsapFprintf(fid,sig,angle(Z(L))/deg);
    if L==N,
      fprintf(fid,')\n');
    else
      fprintf(fid,'/\n');
    end
  end
end


% Exte(rior medium):
% ------------------

try
  epsr=EvaluateFun(PhysGrid.Exterior.epsr,Freq);
  %mu=EvaluateFun(PhysGrid.Exterior.mu,mu);
catch
  epsr=[];
end

if ~isempty(epsr),
  
  Cond=-imag(eps0*PhysGrid.Exterior.epsr)*2*pi*Freq;
  Reepsr=real(PhysGrid.Exterior.epsr);

  fprintf(fid,'EXTE(COND=');
  AsapFprintf(fid,sig,Cond); % conductivity in S/m!

  fprintf(fid,'/DIEL=');
  AsapFprintf(fid,sig,Reepsr);

  fprintf(fid,')\n');

end


% Inte(rvals) for integration:
% ----------------------------

q=PhysGrid.Default.ASAP.Inte;  % number of integration steps for simpson rule (~100)

fprintf(fid,'INTE(%d)\n',q);


% additional optional cards:
% --------------------------

if ~isempty(AddCards),
  
  if ischar(AddCards),
    AddCards=cellstr(AddCards);
  end
  
  for L=AddCards(:).',
    fprintf(fid,'%s\n',L{:});
  end

end
  

% output request and stop card:
% -----------------------------

fprintf(fid,'OUTPUT(CURRENT)\n');
fprintf(fid,'STOP\n\n');


% Trailer:
% --------

fprintf(fid,'C      ============================================\n'); 
fprintf(fid,'C      ASAP input file created %s\n',datestr(now));
fprintf(fid,'C      by Asap_CreateIn.m (MATLAB Toolbox)\n');


% close completed ASAP input file:
% --------------------------------

s=fclose(fid);
if s<0,
  error(['Could not close file ',AIF]);
end

end

%-------------------------------

function c=AsapFprintf(fid,s,x)

% c=AsapFprintf(fid,s,x) prints number x in ASAP format to the text
% file associated with file identifier fid, using s significant 
% decimals (1<=s<=9, as ASAP can correctly read only up to 9 digits
% per number). The number of written bytes is returned in c.

% number of significant digits:

s=max(round(s),1);
if s>9,
  error('Too many significant decimals requested.');
end

% conversion to exponential string-format:

xs=sprintf(sprintf('%%.%de',s-1),x);

% exponent:

e=str2double(xs(strfind(xs,'e')+1:end));
if e>11,
  error('Number too large to be printed in ASAP format.');
end

% minimum shift-left q, so that a maximum of 9 digits is
% printed (ASAP cannot read more than 9 digits to represent
% a number because long integers are used to store its basis 
% and no exponent identifier e... can be given):

q=max(s-e-9,0); 
if q>6,
  error('Number too small to be printed in ASAP format.');
end

% print x using K, M or U postfix if necessary:

if e>5,
  
  % K postfix
  f=sprintf('%%.%df',max(s-1-e+3,0));
  c=fprintf(fid,[f,'K'],x/1e3);
  
elseif (e<-5)||(q>3),  
  
  % U postfix
  f=sprintf('%%.%df',max(s-1-e-6,0));
  c=fprintf(fid,[f,'U'],x*1e6);
  
elseif (e<-2)||(q>0),  
  
  % M postfix
  f=sprintf('%%.%df',max(s-1-e-3,0));
  c=fprintf(fid,[f,'M'],x*1e3);
  
else  
  
  % no postfix
  f=sprintf('%%.%df',max(s-1-e,0));
  c=fprintf(fid,f,x);
  
end

end

