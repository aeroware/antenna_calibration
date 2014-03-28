 
function Op=Asap_ReadOut(WorkingDir)

% [Curr,Freq,Wire,epsr,Inte]
% Op=Asap_ReadOut(WorkingDir) reads data from ASAP output file,
% the filename of which is defined in the global variable Atta_Asap_Out,
% expected in the durectory WorkingDir.
% The returned parameters are:
%
%   Op.Reread.Freq           frequency
%   Op.Reread.Wire.Diam      wire diameter 
%   Op.Reread.Wire.Cond      wire conductivity 
%   Op.Reread.Exterior.epsr  dielectric constant of exterior medium 
%   Op.Reread.ASAP.Inte      number of intervals for simpson integration
%   Op.Curr1                 the currents: s x 2 matrix for s segments


global Atta_Asap_Out

cL=2.99792458e8;
eps0=1/(4e-7*pi*cL^2);


% open file:

if ~exist('WorkingDir','var')||isempty(WorkingDir),
  WorkingDir='';
end

AOF=fullfile(WorkingDir,Atta_Asap_Out);

fid=fopen(AOF,'rt');
if fid<0,
  error(['Could not open file ',AOF]);
end


% initialize parameters:

Param={'FREQUENCY (MHZ)',...
       'WIRE RADIUS (METERS)',...
       'WIRE CONDUCTIVITY (MEGAMHOS/METER)',...
       'EXTERIOR MEDIUM CONDUCTIVITY (MHOS/METER)',...
       'EXTERIOR MEDIUM DIELECTRIC CONSTANT (RELATIVE)',...
       'IF CLOSED FORM INTEGRATION IS REQUIRED',...
       'ANTENNA BRANCH CURRENTS'};

Freq=nan;
Wire.Diam=nan;
Wire.Cond=nan;
Cond=nan;
epsr=nan;
Inte=nan;
Curr=zeros(10000,2);
     

% search for end of input data cards:

LineNum=0; 

while ~feof(fid),
  [Line,LineNum]=AsapFgetl(fid,LineNum);
  if isequal(Line(1:min(1,length(Line))),'0'),
    break, 
  end
end


% Parameters Loop:

CurrFound=false;

while ~feof(fid)&&~CurrFound,
  [Line,LineNum]=AsapFgetl(fid,LineNum);
  for p=1:length(Param),
    n=strfind(upper(Line),Param{p});
    if ~isempty(n),
      n=n(end)+length(Param{p});
      switch p,
        case 1,
          Freq=sscanf(Line(n:end),'%f',1)*1e6;
        case 2,
          Wire.Diam=2*sscanf(Line(n:end),'%f',1);
        case 3,
          Wire.Cond=sscanf(Line(n:end),'%f',1)*1e6;
          if Wire.Cond<=0,
            Wire.Cond=inf;
          end
        case 4,
          Cond=sscanf(Line(n:end),'%f',1);
        case 5,
          epsr=sscanf(Line(n:end),'%f',1);
        case 6,
          Inte=sscanf(Line,'%f',1);
        case length(Param),
          CurrFound=1;
      end                       
    end
  end
end
  
if isnan(Freq)||isnan(Wire.Diam)||isnan(Wire.Cond)||...
   isnan(Cond)||isnan(epsr)||isnan(Inte),
  error('Not all parameters correctly determined from ASAP output file.');
end

epsr=epsr+Cond/(j*2*pi*Freq*eps0);
  

% Currents loop:

s=0;

while ~feof(fid),
  [Line,LineNum]=AsapFgetl(fid,LineNum);
  p=strfind(Line,'**');
  if ~isempty(p),
    Line(p)='1';
    Line(p+1)='1';
  end
  cu=sscanf(Line,'%f');
  if length(cu)==13,
    s=s+1;
    Curr(s,:)=[cu(3)+j*cu(4),cu(9)+j*cu(10)];
  elseif isequal(Line(1:min(1,length(Line))),'0'),
    break
  end
end

if s==0,
  AsapFerror(fid,'No current data found.',LineNum);
end      

if ~isequal(Line(1:min(1,length(Line))),'0'),
  warning('Encountered end of file while reading currents.')
end

% close file:

p=fclose(fid);
if p<0,
  error(['Could not close file ',AOF]);
end

% return parameters in Op struct:

Op.Reread.Freq=Freq;
Op.Reread.Wire=Wire;
Op.Reread.Exterior.epsr=epsr;
Op.Reread.ASAP.Inte=Inte;
Op.Curr1=Curr(1:s,:);


end % of ASAP_ReadOut.m


%-------------------------------
function AsapFerror(fid,Err,L)

% Displays error message Err after closing the file associated 
% with fid. In addition the line number L is output.
% The function is used by AsapRead.

Name=fopen(fid);

fclose(fid);

if nargin>2,
  fprintf(1,'\nASAP format error in line %d of ''%s''\n',L,Name);
end

error(Err);

end

%-------------------------------
function [L,N1]=AsapFgetl(fid,N)

% Read line from file associated with identifier fid,
% comment lines are returned empty, letters are modified to
% uppercase. The line number N is increased by 1. If end
% of file is reached, L=-1 is returned.
% This function is used by AsapRead.

if nargin>1,
  N1=N;
else
  N1=1;
end

L='';

if feof(fid),
  return
end

L=deblank(fgetl(fid));

N1=N1+1;

if ~ischar(L),
  return
end

L=[upper(L),' '];

if (L(1)=='C') && isspace(L(2)),
  L='';
end

end

