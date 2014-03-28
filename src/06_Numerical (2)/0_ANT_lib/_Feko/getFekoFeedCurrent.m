function IA=getFekoFeedCurrent(WorkingDir,Atta_Feko_out)

% IA=getFekoFeedCurrent(feedDir);
%
% extracts the feed current from the FEKO out file
%
% The fields are filled when the corresponding data are found in the files.
%
% parameters:
%
%   WorkingDir      ...directory where the out-file is found

% out-parameters:
%
%   IA              ...the current on the feed
%
%   Written by Thomas Oswald, 05.2011


if nargin < 1
    WorkingDir=pwd;
end

if nargin < 2
    Atta_Feko_out='antfile.out';
end


% open file:
% ----------


AIF=fullfile(WorkingDir,Atta_Feko_out);

fid=fopen(AIF,'rt');

if fid<0
  error(['Could not open file ',AIF]);
end

str_line_num=0;

% search for 'DATA' as first token

found=0;

l = strtrim(fgetl(fid));
str_line_num=str_line_num+1;
    
while ~feof(fid)
    [tok, rem]=strtok(l);   
         
    if strcmp(tok,'DATA')
        found=1;
        break;
    end
         
    l = strtrim(fgetl(fid));     
    str_line_num=str_line_num+1;
end % while
    
if found==0        
    error(['Error...unexpected end of file after line ',str_line_num]);
end
    
  % search for 'Current' as first token
  
    nFeed=1;
    found=0;
    while ~feof(fid)
        
        % search for 'Current' as first token
        
        l = strtrim(fgetl(fid));
        str_line_num=str_line_num+1;
    
        while ~feof(fid)
            [tok, rem]=strtok(l);
     
            if strcmp(tok,'Current')
                found=1;
                break;
            end
            l = strtrim(fgetl(fid));     
            str_line_num=str_line_num+1;
         end % while
    
        if found==0
            break;
            %error(['Error...unexpected end of file after line ',str_line_num]);
        end
    
        [tok, rem]=strtok(rem); %   'in'
        [tok, rem]=strtok(rem); %   'A'
    
        [c_real, rem]=strtok(rem);  % real part
        [c_imag, rem]=strtok(rem);  % imaginary part
    
        IA(nFeed)=str2num(c_real)+i*str2num(c_imag);
        
        nFeed = nFeed+1;
        found=0;
    end % while
    fclose(fid);
end  % of function
