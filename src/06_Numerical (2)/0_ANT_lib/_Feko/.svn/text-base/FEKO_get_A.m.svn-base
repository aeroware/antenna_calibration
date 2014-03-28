function [AA,f]=FEKO_get_A(Atta_Feko_out, WorkingDir, average,r,k)

% [A,f]=FEKO_getA(Atta_Feko_out, avarage) 
%
% extracts the magnetic vector potential from the FEKO out file
%
% The fields are filled when the corresponding data are found in the files.
%
% parameters:
%
%   Atta_Feko_out   ...the file name of the out file
%   average         ...a parameter which governs the format of A
%                       0...A is a matrix containing all As
%                       1...A is a singlevector containing the averaged
%                       field
%   r               ...distance of location of field points from the canter
%                       of the antenna system
%   k               ...k
% out-parameters:
%
%   AA               ...the magnetic vector potential(s)*r/exp(-j*k*r)
%   f               ...frequency
%
%   Each line of A has the following structure:
%       average==0:
%       
%   position: R/m THETA PHI potential: R Theta Phi
%
%   average==1:
%
%   potential: R Theta Phi
%
%   Written by Thomas Oswald, 04.2011

rad=pi/180;

if nargin < 3
  average=1;
end

if nargin < 2
    WorkingDir=pwd;
end

if nargin < 1
  Atta_Feko_out='JUNO_V0.out';
end

% open file:
% ----------



AIF=fullfile(WorkingDir,Atta_Feko_out);

fid=fopen(AIF,'rt');


if fid<0
  error(['Could not open file ',AIF]);
end

str_line_num=0;

% search for 'FREQ'

    found=0;
    l = strtrim(fgetl(fid));
    str_line_num=str_line_num+1;
    
    while ~feof(fid)
        [tok, rem]=strtok(l);
      
        while ~isempty(tok) 
            if strcmp(tok,'FREQ')
                found=1;
                break;
            end
            [tok, rem]=strtok(rem);
        end
        
        if(found==1)
            break;
        end
        
        l = strtrim(fgetl(fid));
        str_line_num=str_line_num+1;
    end % while
    
    if found==0
        error(['Error...unexpected end of file after line ',str_line_num]);
    end
    
    [tok, rem]=strtok(rem);
    [freq, rem]=strtok(rem);
    
    f=str2num(freq);
    
  % search for 'POTENTIAL'
  
    found=0;
    l = strtrim(fgetl(fid));
    str_line_num=str_line_num+1;
    
    while ~feof(fid)
        [tok, rem]=strtok(l);
      
        while ~isempty(tok) 
            if strcmp(tok,'POTENTIAL')
                found=1;
                break;
            end
            [tok, rem]=strtok(rem);
        end
        
        if(found==1)
            break;
        end
        
        l = strtrim(fgetl(fid));
        str_line_num=str_line_num+1;
    end % while
    
    % go to first line
    
    
    if found==0
        error(['Error...unexpected end of file after line ',str_line_num]);
    end
    
    % search for 'medium'
    
    found=0;
    l = strtrim(fgetl(fid));
    str_line_num=str_line_num+1;
    
    while ~feof(fid)
        [tok, rem]=strtok(l);
      
        while ~isempty(tok) 
            if strcmp(tok,'medium')
                found=1;
                break;
            end
            [tok, rem]=strtok(rem);
        end
        
        if(found==1)
            break;
        end
        
        l = strtrim(fgetl(fid));
        str_line_num=str_line_num+1;
    end % while
    
    % go to first line
    
    
    if found==0
        error(['Error...unexpected end of file after line ',str_line_num]);
    end
    
    % read in A
    
    
    potential=textscan(fid,'%d %n %n %n %n %n %n %n %n %n');
    
    % check for warning
    
    l = strtrim(fgetl(fid));
    [tok, rem]=strtok(l);
    if strcmp(tok,'WARNING')
        warning(['warning...warning message found in '...
            ,AIF,' output may not be complete.']);
    end
    
    
p=fclose(fid);

if p<0,
  error(['Could not close file ',AIF]);
end



A=zeros(size(potential{1},1), 3);
   % A_sph=A;
    
    
%     for row=1:size(A,1)       // das war die sphärische variante
%         theta=potential{3}(row)*rad;
%         phi=potential{4}(row)*rad;
%         
%         A_sph(row,1)=potential{5}(row)*...
%             (cos(rad*potential{6}(row))...
%             +i*sin(rad*potential{6}(row)));
%     
%         A_sph(row,2)=potential{7}(row)*...
%             (cos(rad*potential{8}(row))...
%             +i*sin(rad*potential{8}(row)));
%     
%         A_sph(row,3)=potential{9}(row)*...
%             (cos(rad*potential{10}(row))...
%             +i*sin(rad*potential{10}(row)));
%         
%         A(row,1) = sin(theta)*cos(phi)*A_sph(row,1) + cos(theta)*cos(phi)*A_sph(row,2) - sin(phi)*A_sph(row,3);
%         A(row,2) = sin(theta)*sin(phi)*A_sph(row,1) + cos(theta)*sin(phi)*A_sph(row,2) + cos(phi)*A_sph(row,3);
%         A(row,3) = cos(theta)*A_sph(row,1) - sin(theta)*A_sph(row,2); 
%     end 
        
for row=1:size(A,1)      
        A(row,1)=potential{5}(row)*...
            (cos(rad*potential{6}(row))...
            +i*sin(rad*potential{6}(row)));
    
        A(row,2)=potential{7}(row)*...
            (cos(rad*potential{8}(row))...
            +i*sin(rad*potential{8}(row)));
    
        A(row,3)=potential{9}(row)*...
            (cos(rad*potential{10}(row))...
            +i*sin(rad*potential{10}(row)));
 end 

        AA=A.*r*exp(i*k*r);
        
      
if(average)
    AA=zeros(3,1);

    AA(1)=mean(A(:,1));
    AA(2)=mean(A(:,2));
    AA(3)=mean(A(:,3));
end

end  % of function
