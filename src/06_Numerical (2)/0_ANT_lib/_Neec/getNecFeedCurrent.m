function IA=getNecFeedCurrent(ant,WorkingDir)

% IA=getNecFeedCurrent(ant,WorkingDir);
%
% extracts the feed current from the nec.out file
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
%   Written by Thomas Oswald, 08.2011

global Atta_Nec_Out;

if nargin < 1
    WorkingDir=pwd;
end


% open file:
% ----------

AIF=fullfile(WorkingDir,Atta_Nec_Out);
fid=fopen(AIF,'rt');

if fid<0
  error(['Could not open file ',AIF]);
end

str_line_num=0;

% search for 'TAG' as first token

found=0;

l = strtrim(fgetl(fid));
str_line_num=str_line_num+1;
    
while ~feof(fid)
    [tok, rem]=strtok(l);   
         
    if strcmp(tok,'TAG')
        found=1;
        break;
    end
         
    l = strtrim(fgetl(fid));     
    str_line_num=str_line_num+1;
end % while
    
if found==0        
    error(['Error...unexpected end of file after line ',str_line_num]);
end
   
% scrap 2 lines

l = strtrim(fgetl(fid));     
str_line_num=str_line_num+1;
    
for nF=1:length(ant.Desc_.Feeds.Elem)
    l = strtrim(fgetl(fid));     
    str_line_num=str_line_num+1;

    c_real=l(32:43);
    c_imag=l(44:56);
%     [tok, rem]=strtok(l); %   
%     [tok, rem]=strtok(rem); %   
%     [tok, rem]=strtok(rem); %   
%     [tok, rem]=strtok(rem); %   
%     
%     [c_real, rem]=strtok(rem);  % real part
%     [c_imag, rem]=strtok(rem);  % imaginary part

    IA(nF)=str2num(c_real)+i*str2num(c_imag);
end

fclose(fid);
end  % of function
