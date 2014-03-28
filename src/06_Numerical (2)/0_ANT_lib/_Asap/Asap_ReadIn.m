 
function [AntGrid,Freq]=Asap_ReadIn(WorkingDir)

% [AntGrid,Freq]=Asap_ReadIn(WorkingDir) reads data from ASAP input file 
% which is defined in the global variable Atta_Asap_In (which is expected 
% in the directory WorkingDir) and returns it in the structure AntGrid 
% the following fields of which are returned:
%   Geom, Desc, 
%   Default.Wire.Diam, Default.Wire.Cond,
%   Geom_.Feeds, Desc_.Feeds,
%   Geom_.Loads, Desc_.Loads,
%   Exterior.epsr,
%   ASAP.Inte
%   
% The fields are filled when the corresponding data are found in the files.
% Additionally the frequancy is returned separately in the variable Freq.


% These are the ASAP input cards recognized by Asap_ReadIn:

CardSet={'WIRE','INSU','GEOM','GXYZ','DESC','DNOD',...
  'FREQ','FEED','GENE','LOAD','IMPE','EXTE','INTE','STOP','OUTPUT'};

global Atta_Asap_In

deg=pi/180;

cL=2.99792458e8;
eps0=1/(4e-7*pi*cL^2);

Freq=300e6;  % Default frequency;
epsr=1;      % default dielectric constant of ambient medium
Cond=0;      % default conductivity of ambient medium


% open file:
% ----------

if ~exist('WorkingDir','var')||isempty(WorkingDir),
  WorkingDir='';
end

AIF=fullfile(WorkingDir,Atta_Asap_In);

fid=fopen(AIF,'rt');
if fid<0,
  error(['Could not open file ',AIF]);
end


% MAIN LOOP:
% ----------

LineNum=0; 

while ~feof(fid),  
  
[Line,LineNum]=AsapFgetl(fid,LineNum);  
Card='';
for k=CardSet,
  p=strfind(Line,k{1});
  if ~isempty(p), 
    Card=k{1};
    Line=Line(p(1)+length(Card):end);
    break, 
  end
end
  
switch Card,

case 'WIRE',
  [d,du]=Sscann(Line,1);
  p=[];
  q=[];
  for k=1:min(length(d),2),
    if strfind(du{k},'RADI'),
      p=d(k);
    elseif strfind(du{k},'COND'),
      q=d(k);
    end
  end
  if isempty(p),
    AsapFerror(fid,...
      'Invalid WIRE card (no RADIUS defined).',LineNum);
  end
  if isempty(q),
    if length(d)>1,
      AsapFerror(fid,...
      'Invalid WIRE card encountered.',LineNum);
    else
      q=50;
    end
  elseif q<0, 
    q=inf;
  end
  AntGrid.Default.Wire.Diam=2*p;    % diameter=2*radius
  AntGrid.Default.Wire.Cond=q*1e6;  % Conductivity in MS/m -> in S/m
  
% insulation not implemented yet in this version  
% case 'INSU',
%   [d,du]=Sscann(Line,1);
%   p=[];
%   q=[];
%   r=[];
%   for k=1:min(length(d),3),
%     if strfind(du{k},'RADI'),
%       p=d(k);
%     elseif strfind(du{k},'COND'),
%       q=d(k);
%     elseif strfind(du{k},'DIEL'),
%       r=d(k);
%     end
%   end
%   if isempty(p)|isempty(q)|isempty(r),
%     AsapFerror(fid,'Invalid INSU card encountered.',LineNum);
%   end
%   AntGrid.Insu=[p,q,r];
  
case 'GEOM',
  p=[];
  q=[];
  while ischar(Line),
    p=strfind(Line,')');
    if ~isempty(p),
      Line=Line(1:p-1);
    end
    q=[q,Sscann(Line,1)];
    if ~isempty(p), break, end
    [Line,LineNum]=AsapFgetl(fid,LineNum);  
  end   
  if isempty(p),
    AsapFerror(fid,...
      'Unexpected end of file within GEOM card.',LineNum);
  end
  p=length(q);
  if mod(p,3) || isempty(q),
    AsapFerror(fid,...
      'Invalid number of coordinates in GEOM card.',LineNum);
  end
  AntGrid.Geom=reshape(q,3,p/3).';

case 'GXYZ',
  q=[];
  p=[];
  while ~feof(fid) && isempty(p),
    [Line,LineNum]=AsapFgetl(fid,LineNum);  
    d=sscanf(Line,'%f');
    if mod(length(d),3),
      AsapFerror(fid,...
        'Invalid number of coordinates in GXYZ card.',LineNum);
    elseif isempty(d),
      p=strfind(Line,'XXXX');
      if ~all(isspace(Line)) && isempty(p),
        AsapFerror(fid,'Invalid line in GXYZ card.',LineNum);
      end
    else
      q=[q;d.'];
    end
  end
  p=strfind(Line,'XXXX');
  if isempty(p) || isempty(q),
    AsapFerror(fid,...
      'Unexpected end of data within GXYZ card.',LineNum);
  end
  AntGrid.Geom=q;

case 'DESC',
  p=[];
  q=[];
  while ischar(Line),
    p=strfind(Line,')');
    if ~isempty(p),
      Line=Line(1:p-1);
    end
    q=[q,Sscann(Line,1)];
    if ~isempty(p), break, end
    [Line,LineNum]=AsapFgetl(fid,LineNum);  
  end   
  if isempty(p),
    AsapFerror(fid,...
      'Unexpected end of file within DESC card.',LineNum);
  end
  p=length(q);
  if mod(p,2) || isempty(q),
    AsapFerror(fid,...
      'Invalid number of coordinates in DESC card.',LineNum);
  end
  AntGrid.Desc=reshape(q,2,p/2).';

case 'DNOD',
  q=[];
  p=[];
  while ~feof(fid) && isempty(p),
    [Line,LineNum]=AsapFgetl(fid,LineNum);  
    d=sscanf(Line,'%f');
    if mod(length(d),2),
      AsapFerror(fid,...
        'Invalid number of coordinates in DNOD card.',LineNum);
    elseif isempty(d),
      p=strfind(Line,'XXXX');
      if ~all(isspace(Line)) && isempty(p),
        AsapFerror(fid,'Invalid line in DNOD card.',LineNum);
      end
    else
      q=[q;d.'];
    end
  end
  p=strfind(Line,'XXXX');
  if isempty(p) || isempty(q),
    AsapFerror(fid,...
      'Unexpected end of data within DNOD card.',LineNum);
  end
  AntGrid.Desc=q;

case 'FREQ',
  q=Sscann(Line,1);
  if isempty(q),
    AsapFerror(fid,'Invalid FREQ card encountered.',LineNum);
  end
  Freq=1e6*q(1);  % Frequency in MHz -> in Hz

case 'FEED',
  p=[];
  q=[];
  while ischar(Line),
    p=strfind(Line,')');
    if ~isempty(p),
      Line=Line(1:p-1);
    end
    q=[q,Sscann(Line,1)];
    if ~isempty(p), break, end
    [Line,LineNum]=AsapFgetl(fid,LineNum);  
  end   
  if isempty(p),
    AsapFerror(fid,...
      'Unexpected end of file within FEED card.',LineNum);
  end
  p=length(q);
  if ((p~=1) && mod(p,3)) || isempty(q),
    AsapFerror(fid,'Invalid FEED card encountered.',LineNum);
  end
  if p==1,
    AntGrid.Geom_.Feeds=q;
  else
    q=reshape(q,3,p/3).';
    AntGrid.Geom_.Feeds=q(:,1);
    AntGrid.Geom_.V=q(:,2).*exp(i*q(:,3)*deg);
  end
  
case 'GENE',
  p=[];
  q=[];
  while ischar(Line),
    p=strfind(Line,')');
    if ~isempty(p),
      Line=Line(1:p-1);
    end
    q=[q,Sscann(Line,1)];
    if ~isempty(p), break, end
    [Line,LineNum]=AsapFgetl(fid,LineNum);  
  end   
  if isempty(p),
    AsapFerror(fid,...
      'Unexpected end of file within GENE card.',LineNum);
  end
  p=length(q);
  if ((p~=1) && mod(p,3)) || isempty(q),
    AsapFerror(fid,'Invalid GENE card encountered.',LineNum);
  end
  if p==1,
    AntGrid.Desc_.Feeds=q;
  else
    q=reshape(q,3,p/3).';
    AntGrid.Desc_.Feeds=q(:,1);
    AntGrid.Desc_.V=q(:,2).*exp(i*q(:,3)*deg);
  end
  
case 'LOAD',
  p=[];
  q=[];
  while ischar(Line),
    p=strfind(Line,')');
    if ~isempty(p),
      Line=Line(1:p-1);
    end
    q=[q,Sscann(Line,1)];
    if ~isempty(p), break, end
    [Line,LineNum]=AsapFgetl(fid,LineNum);  
  end   
  if isempty(p),
    AsapFerror(fid,...
      'Unexpected end of file within LOAD card.',LineNum);
  end
  p=length(q);
  if mod(p,3) || isempty(q),
    AsapFerror(fid,'Invalid LOAD card encountered.',LineNum);
  end
  q=reshape(q,3,p/3).';
  AntGrid.Geom_.Loads=q(:,1);
  AntGrid.Geom_.Z=q(:,2).*exp(j*q(:,3)*deg);
  
case 'IMPE',
  p=[];
  q=[];
  while ischar(Line),
    p=strfind(Line,')');
    if ~isempty(p),
      Line=Line(1:p-1);
    end
    q=[q,Sscann(Line,1)];
    if ~isempty(p), break, end
    [Line,LineNum]=AsapFgetl(fid,LineNum);  
  end   
  if isempty(p),
    AsapFerror(fid,...
      'Unexpected end of file within IMPE card.',LineNum);
  end
  p=length(q);
  if mod(p,3) || isempty(q),
    AsapFerror(fid,'Invalid IMPE card encountered.',LineNum);
  end
  q=reshape(q,3,p/3).';
  AntGrid.Desc_.Loads=q(:,1);
  AntGrid.Desc_.Z=q(:,2).*exp(j*q(:,3)*deg);
  
case 'EXTE',
  [d,du]=Sscann(Line,1);
  p=[];
  q=[];
  for k=1:min(length(d),2),
    if strfind(du{k},'COND'),
      p=d(k);
    elseif strfind(du{k},'DIEL'),
      q=d(k);
    end
  end
  if isempty(p)||isempty(q),
    AsapFerror(fid,'Invalid EXTE card encountered.',LineNum);
  end
  epsr=q;
  Cond=p;

case 'INTE',
  q=Sscann(Line,1);
  if isempty(q),
    AsapFerror(fid,'Invalid INTE card encountered.',LineNum);
  end
  AntGrid.ASAP.Inte=q(1);
  
case 'STOP',
  break
  
otherwise
  if ~all(isspace(Line)) && isempty(Card),
    fprintf(1,'Warning: Asap_ReadIn cannot treat input line %d: %s\n',...
      LineNum,Line);
%    AsapFerror(fid,...
%      'Unknown ASAP input card encountered.',LineNum);
  end
 
end % of switch

end % of MAIN LOOP


AntGrid.Exterior.epsr=epsr+Cond/(j*2*pi*Freq*eps0);


p=fclose(fid);
if p<0,
  error(['Could not close file ',AIF]);
end


end  % of ASAP_ReadIn.m


%---------------------------------

function AsapFerror(fid,Err,L)

% Displays error message Err after closing the file associated 
% with fid. In addition the line number L is output.

Name=fopen(fid);

fclose(fid);

if nargin>2,
  fprintf(1,'\nASAP format error in line %d of ''%s''\n',L,Name);
end

error(Err);

end

%---------------------------------

function [L,N1]=AsapFgetl(fid,N)

% Read line from file associated with identifier fid,
% comment lines are returned empty, letters are modified to
% uppercase. The line number N is increased by 1. If end
% of file is reached, L=-1 is returned.

if nargin>1,
  N1=N+1;
else
  N1=1;
end

L=deblank(fgetl(fid));

if ~ischar(L),
  N1=N1-1;
  return
end

L=[upper(L),' '];

if (L(1)=='C') && isspace(L(2)),
  L='';
end

end
