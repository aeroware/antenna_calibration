 
function [ant,op]=NecRead(ant_in,op_in);

% [Ant,Op]=NecRead(AIF,AOF) reads data from NEC2 output file necout.dat
%
% Ant and Op are structures with the fields
%   Ant. Geom, Desc, Wire, Insu
%   Op. Freq, Feed, Load, Exte, Inte, Curr
% as exlained in WriteAsap. The fields are filled when the
% corresponding data are found in the files.


CIF='necout.dat';
fid=fopen(CIF,'r');
if fid<0,
  error(['Could not open file ',CIF]);
end

ant=ant_in;
op=op_in;
Nsegs=length(ant.Desc);

for n=1:length(ant.Feed);
    % search for 'CURRENTS'
    found=0;
    l = strtrim(fgetl(fid));
    
    while (found == 0)
        [tok, rem]=strtok(l);
        
        while (~isempty(rem)) & (found==0)
            if strcmp(tok,'CURRENTS')
                found=1;
            end
                [tok, rem]=strtok(rem);  
        end % while
        l = strtrim(fgetl(fid));
    end % while
    % go to first line
    
    for m=1:4
        fgetl(fid);
    end
    
    
     C=textscan(fid,'%d %d %n %n %n %n %n %n %n %n');
     op.NecCurr(n,:)=C{7}+C{8}*i;
end %for all feeds


s=fclose(fid);
if s<0,
  error(['Could not close file ',CIF]);
end