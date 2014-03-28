
function AsapWrite(Ant,Op,AddCards)

% AsapWrite(AIF,C,Ant,Op) creates ASAP input file (filename expected
% in string AIF) by translating given data into ASAP input format.
% C is a number of comment lines which serve as a preamble 
% of the file. Ant defines the antenna system, Op how it is 
% operated. Both are structures, with the following fields:
%   Ant. Geom, Desc, Wire, Insu
%   Op.  Freq, Feed, Load, Exte, Inte
% where 
%   Geom .. N x 3, coordinates of grid nodes (x,y,z) 
%   Desc .. S x 2, grid segments (start node, end node)
%   Wire .. 1 x 2, defines the wire by (Radius, Conductivity)
%   Insu .. 1 x 3, insulation (Radi, Cond, rel. Dielectric constant)
%   Freq .. scalar, operating frequency
%   Feed .. F x 2, feeds defined by (Terminal, Voltage)
%   Load .. L x 2, loads defined by (Terminal, Impedance)
%   Exte .. 1 x 2, exterior medium (Cond, rel. Dielectric constant)
%   Inte .. scalar, number of intervals for Simpson's rule integration, 
%           Inte=0 causes use of rigorous closed form expressions
%   Feed and Load use a special representation of the terminals by 
%   complex numbers: Terminal=Node+i*Segm, giving the node or the
%   segment between which the feed/load is situated, thereby defining
%   the positive terminal on the side of the segment, the negative 
%   terminal on the node. If all nodes are defined (i.e. all terminal
%   numbers are real), the ASAP cards FEED/LOAD are used, otherwise 
%   (all segments defined, i.e. all terminal values imaginary) 
%   GENE/IMPE are used, respectively. A mixture of node/segments 
%   identifiers can only be used if it is possible to express the
%   terminals either by all node-identifiers or by all segment-ids.  
%
% All physical quantities are supposed to be in SI-units!
%
% Default values are used for certain elements if omitted ore empty
% (the other elements must be defined):
%   Insu       none
%   Load       none
%   Exte       vacuum, i.e. Exte=(0,1)
%   Inte       0 (rigorous closed form integration)
% The wire conductivity, Wire(:,2), may be set <0 or =inf in order 
% to indicate perfectly conducting wires. If it is set =0, a default 
% value of 50e6 S/m is used (e.g. Cu 64e6, Al 38e6, Fe ~10e6).
%
% The ASAP input file is completed by the additional cards AddCards, 
% the output request card OUTPUT(CURRENT) (i.e. the current 
% distribution shall be calculated by ASAP and written to the ASAP 
% output file), the STOP card and a comment indicating when the
% file was generated.
%
% Revision 01.08 by Thomas Oswald
% AIF and C removed

sig=8;  % Number of significant decimals to be used for ASAP format

deg=pi/180;

if nargin<3,
  AddCards=[];
end

% open/create ASAP input file:

fid=fopen('asapin.dat','wt');
if fid<0,
  error(['Could not open file ','asapin.dat']);
end

% Preamble:

% fprintf(fid,'C      \n');
% if iscell(C),
%   for L=C(:)',
%     fprintf(fid,'C      %s\n',L{:});
%   end
% elseif ischar(C),  
%   for L=1:size(C,1),
%     fprintf(fid,'C      %s\n',C(L,:));
%   end
% end
% fprintf(fid,'C      \n');

% Wire:

du=Ant.wire(1,2)/1e6;  % conductivity in MS/m!
if du<0 | du==inf,
  du=-1;
elseif du==0,
  du=50;
end
fprintf(fid,'WIRE(RADI=');
AsapFprintf(fid,sig,Ant.wire(1,1));
fprintf(fid,'/COND=');
AsapFprintf(fid,sig,du);  
fprintf(fid,')\n');

% Insu(lation):

if isfield(Ant,'Insu'),
  if ~isempty(Ant.Insu),
    fprintf(fid,'INSU(RADI=');
    AsapFprintf(fid,sig,Ant.Insu(1,1));
    fprintf(fid,'/COND=');    
    AsapFprintf(fid,sig,Ant.Insu(1,2)); % conductivity in S/m!
    fprintf(fid,'/DIEL=');    
    AsapFprintf(fid,sig,Ant.Insu(1,3));
    fprintf(fid,')\n');
  end
end

% Geom(etry):  

fprintf(fid,'GXYZ\n');
f=sprintf('%%%d.%df ',sig+5,sig-1);
for L=1:size(Ant.Geom,1),
  fprintf(fid,[f,f,f,' /%d\n'],Ant.Geom(L,:),L);
end
fprintf(fid,'XXXX\n');

% Desc(ription):

fprintf(fid,'DNOD\n');
for L=1:size(Ant.Desc,1),
  fprintf(fid,'%4d %4d  /%d\n',Ant.Desc(L,:),L);
end
fprintf(fid,'XXXX\n');

% Freq(uency):

fprintf(fid,'FREQ(');
AsapFprintf(fid,sig,Op.Freq/1e6);  % frequency in MHz!
fprintf(fid,')\n');

% Feed:

if isempty(Op.Feed),
  fclose(fid);
  error('No feeds defined in operation structure.');
end

[TC,TA]=CheckTerminal(Ant.Desc,Op.Feed(:,1));
if ~all(real(TA)) & ~all(imag(TA)),
  du=['\nFeed terminals incompatible with FEED card:\n',...
      num2str(find((real(TA)==0)')),'\n',...
      'Feed terminals incompatible with GENE card:\n',...
      num2str(find((imag(TA)==0)')),'\n'];
  fprintf(1,du);
  fclose(fid);
  error('Feed definition is incompatible with ASAP input format.');
end
if all(real(TA)),
  fprintf(fid,'FEED(');
  nu=real(TA);
else 
  fprintf(fid,'GENE(');
  nu=imag(TA);
end

du=Op.Feed;
N=length(TA); 
for L=1:N,
  fprintf(fid,'%d,',nu(L));
  AsapFprintf(fid,sig,1);
  fprintf(fid,',');
  AsapFprintf(fid,sig,angle(du(L))/deg);
  if L==N,
    fprintf(fid,')\n');
  else
    fprintf(fid,'/\n');
  end
end

% Load:

if isfield(Op,'Load'),
    if ~isempty(Op.Load),
        [TC,TA]=CheckTerminal(Ant.Desc,Op.Load(:,1));
            if ~all(real(TA)) & ~all(imag(TA)),
                du=['\nLoad terminals incompatible with LOAD card:\n',...
                    num2str(find((real(TA)==0)')),'\n',...
                    'Load terminals incompatible with IMPE card:\n',...
                    num2str(find((imag(TA)==0)')),'\n'];
                fprintf(1,du);
                fclose(fid);
                error('Load definition is incompatible with ASAP input format.');
            end % if ~all...

            if all(real(TA)),
                fprintf(fid,'LOAD(');
                nu=real(TA);
            else 
                fprintf(fid,'IMPE(');
                nu=imag(TA);
            end % else

            du=Op.Load(:,2);
            N=length(TA); 
            
            for L=1:N,
                fprintf(fid,'%d,',nu(L));
                AsapFprintf(fid,sig,abs(du(L)));
                fprintf(fid,',');
                AsapFprintf(fid,sig,angle(du(L))/deg);
    
                if L==N,
                    fprintf(fid,')\n');
                else
                    fprintf(fid,'/');
                end % else

            end % for

    end % ~isempty...
end % if isfield...

% Exte(rior medium):

if isfield(Op,'Exte'),
  if ~isempty(Op.Exte),
    fprintf(fid,'EXTE(COND=');
    AsapFprintf(fid,sig,Op.Exte(1)); % conductivity in S/m!
    fprintf(fid,'/DIEL=');    
    AsapFprintf(fid,sig,Op.Exte(2));
    fprintf(fid,')\n');
  end
end

% Inte(rvals) for integration:

du=0;
if isfield(Op,'Inte'),
  if ~isempty(Op.Inte),
    du=Op.Inte;
  end
end
fprintf(fid,'INTE(%d)\n',du);

% additional optional cards:

if ~isempty(AddCards),
  if iscell(AddCards),
    for L=AddCards,
      fprintf(fid,'%s\n',L{:});
    end
  elseif ischar(AddCards),  
    for L=1:size(AddCards,1),
      fprintf(fid,'%s\n',AddCards(L,:));
    end
  end
end
  
% output request and stop card:

fprintf(fid,'OUTPUT(CURRENT)\n');
fprintf(fid,'STOP\n\n');

% Trailer:

fprintf(fid,'C      ============================================\n'); 
fprintf(fid,'C      ASAP input file created %s\n',datestr(now));
fprintf(fid,'C      by AsapWrite.m (ASAP-MATLAB Toolbox)\n');

% close completed ASAP input file:
  
s=fclose(fid);
if s<0,
  error(['Could not close file ',AIF]);
end



function c=AsapFprintf(fid,s,x)

% c=AsapFprintf(fid,s,x) prints number x in ASAP format to the text
% file associated with file identifier fid, using s significant 
% decimals (1<=s<=9, as ASAP can correctly read only up to 9 digits
% per number). The number of written bytes is returned in c.
% This function is used by AsapWrite.

% number of significant digits:

s=max(round(s),1);
if s>9,
  error('Too many significant decimals requested.');
end

% conversion to exponential string-format:

xs=sprintf(sprintf('%%.%de',s-1),x);

% exponent:

e=str2double(xs(findstr(xs,'e')+1:end));
if e>11,
  error('Number too large to be printed in ASAP format.');
end

% minimum shift-left q, so that a maximum of 9 digits is
% printed (ASAP cannot read more than 9 digits to represent
% a number because long integers are used to store its basis 
% and no expnent identifier e... can be given):

q=max(s-e-9,0); 
if q>6,
  error('Number too small to be printed in ASAP format.');
end

% print x using K, M or U postfix if necessary:

if e>5,  
  % K postfix
  f=sprintf('%%.%df',max(s-1-e+3,0));
  c=fprintf(fid,[f,'K'],x/1e3);
elseif (e<-5)|(q>3),  
  % U postfix
  f=sprintf('%%.%df',max(s-1-e-6,0));
  c=fprintf(fid,[f,'U'],x*1e6);
elseif (e<-2)|(q>0),  
  % M postfix
  f=sprintf('%%.%df',max(s-1-e-3,0));
  c=fprintf(fid,[f,'M'],x*1e3);
else  
  % no postfix
  f=sprintf('%%.%df',max(s-1-e,0));
  c=fprintf(fid,f,x);
end


