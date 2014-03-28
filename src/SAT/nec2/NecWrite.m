
function NecWrite(ant,Op,NB,titl)

% function NecWrite(ant,Op,NB,titl) creates a concept input file 
% by translating given data into one of the concept input files, 
% defined by mode:
%
% 
%   ant...a structure which defines the antenna system.
%
%   Op...defines how the antennas are operated.
%   
%   NB...the number of sub segments per wire segment.
%
%   titl...title of the model
%   
%   ant has the following member variables:  
%
%   Geom: array [number of nodes x 3] of double
%
%       This array holds the cartesian coordinates of the nodes.
% 
%   Desc: array [number of segments x 2] of double
% 
%       This array holds the numbers of the nodes of each segment 
%       between which the segment is spanned.
% 
%   Desc2d: array [number of patches] of cell
% 
%       This array holds the numbers of the nodes of each patch 
%       between which the patch is spanned.
% 
%   Obj: array [number of objects] of struct object
% 
%       This array hold the objects comprising the model. Each 
%       objects holds information about the geometry of the part 
%       of the model describing it and how to use it in the 
%       calculation. Every part of the model must be 
%       member of at least one object.
% 
%   Init: integer
% 
%       The number held by this member variable counts the number of 
%       object creating function calls. Its important use is to see 
%       whether the object has been initialized.
% 
%   Antennae: array [number of antennas] of struct
% 
%       This array holds an antenna structure for each antenna of the 
%       spacecraft model. 
% 
%   Config: struct
% 
%       A structure which holds information about the spacecraft model, 
%       i.e. size and geometry issues. This structure is spacecraft 
%       dependent and has therefore no fixed structure.
% 
%   Feed: array [number of feeds] of integer
% 
%       This array holds the node numbers of each point feed of the model. 
%       This variable is mainly used in combination with the ASAP software.
% 
%   SegFeeds: array [number of feeds] of integer
% 
%       Concept uses feeds along given segments. This array holds the 
%       segment numbers of the segments where the feeds are located.
% 
%   Wire: array [2] of double
% 
%       The two numbers of this vector hold the radius of the wires, if a 
%       common radius for all wires is used, and the conductivity of the 
%       surface of the model, when a single conductivity is used for the 
%       whole model.
%
%   Op has the following member variables:
%
%   Feed:
% 
%       This member variable has the same function and content as the 
%       member with the same identifier in the ant structure.
% 
%   SegFeeds:
% 
%       This member variable has the same function and content as the 
%       member with the same identifier in the ant structure.
% 
%   Exte: array [2] of double
% 
%       This array holds information about the external medium 
%       surrounding the spacecraft. It is used by the ASAP software.
% 
%   Inte: integer
% 
%       Inte holds the number of iterations of the numerical integration 
%       performed in the ASAP software. Setting it to zero results in an 
%       analytical integration.
% 
%   EpsilonR: double
% 
%       This member holds the value of the relative permittivity of the 
%       surrounding medium to be used with Concept calculations. It can 
%       be used for a simple model to include the effect of the 
%       surrounding space plasma into the calculations.
% 
%   Freq: double
% 
%       This variable holds the frequency used for the calculation.
% 
%   Curr: array [number of antennas x number of segments x 2] of double
% 
%       This array holds the base coefficients at the end points of each 
%       segment.
% 
%   ConceptCurr: array [number of antennas x number of segments x 2] of
%   double
% 
%       This array holds the base coefficients at the three base-points of 
%       each segment.
% 
%   Excit: array [number of antennas] of double
% 
%       This array holds the excitation voltage of the feed of each 
%       antenna.

deg=pi/180;

if nargin<3
  NB=1;
end

% open/create concept input file:

CIF='necin.dat';
fid=fopen(CIF,'wt');
if fid<0,
  error(['Could not open file ',CIF]);
end

% header
fprintf(fid,'CM  ************************\n');
fprintf(fid,'CM  \n');
fprintf(fid,'CM  ');
fprintf(fid,titl);
fprintf(fid,'\nCM  \n');
fprintf(fid,'CM  ************************\n');
fprintf(fid,'CE \n');

% Geom(etry):  


    % input information
    
    
    f=Op.Freq;
    Nsegs=length(ant.Desc);
    
    % name
    
    %fprintf(fid,'1.1  characterization of the structure\n');
    %fprintf(fid,' %s \n',titl);
    
    % symmetry
    % since there is no symmetry expected on spacecraft, I will set this
    % parameter automaticcally to 0, thereby decreasing the number of
    % required parameters.
    
    %fprintf(fid,'2.1   symmetry with respect to the xz plane, yz plane or both\n');
    %fprintf(fid,'%6i\n',0);
    
    % number of wires, ground=0, segments per wavelength=8, coating =0
    
    %Nsegs=length(ant.Desc);
    %fprintf(fid,'2.2   number of wires, id. ground, segments per wavelength, coating\n');
    %if (Op.EpsilonR~=1)&(Op.EpsilonR~=0)
    %    fprintf(fid,'%5i %5i %5i %5i\n',Nsegs, 7,8,0);
    %else
    %    fprintf(fid,'%5i %5i %5i %5i\n',Nsegs, 0,8,0);
    %end
    
    % wires  

    for L=1:Nsegs
        fprintf(fid,'GW 1 %i %-10.4f %-10.4f %-10.4f %-10.4f %-10.4f %-10.4f %10.5f\n'...
            ,NB,ant.Geom(ant.Desc(L,1),:),ant.Geom(ant.Desc(L,2),:), ant.WireRadii(L,1)); 
    end %for all wires
    
    fprintf(fid,'GE 0                                                \n');
    
    %if (Op.EpsilonR~=1)&(Op.EpsilonR~=0)
     %       fprintf(fid,'2.5   tan_delta, rel. permittivity\n'); 
     %       fprintf(fid,' 0.0000     %11.4f\n', Op.EpsilonR); 
     %   end % plasma
        
    % print out currents...always yes
    
  %  fprintf(fid,'3.1  print of currents\n');
  %  fprintf(fid,'%6i\n',1);
    
    % Excitation...at the moment always a feed with one volt
    
  %  fprintf(fid,'3.2  excitation\n');
  %  fprintf(fid,'%6i\n',1);
   

    % position of feed (in terms of the wire number) ant the internal
    % resistance, which is 0 for open feeds
    
 %   fprintf(fid,'3.3  generator position, internal resistance (excitation=1)\n');
 %   fprintf(fid,'m%-3i    %11.4E\n',ant.SegFeeds(Nfeed),0);
    
    % frequency 
    
    
    
     if(length(f)==1)
        fprintf(fid,'FR 0 1 0 0 %f 0                           \n',f/1e6);
     end % if
     

%     else
%        fprintf(fid,'4.1  representation of frequency(ies) (1-6)\n'); 
%        fprintf(fid,'%6i\n',2);
%        
%        fprintf(fid,'4.3  basic frequency, frequency step width, number of frequencies\n'); 
%        fprintf(fid,'%8f      %8f        %i\n',f(1)/1e6,(f(length(f))-f(1))/((length(f)-1)*1e6), length(f)); 
%     end

    % skin effect...finite conductivity ? yes/no/maybe...I thing only yes
    % is an option for us
    
%     if (Op.EpsilonR==1)|(Op.EpsilonR==0)
%         fprintf(fid,'5.1  skin effect (1/0)\n'); 
%         fprintf(fid,'%6i\n',1);
%         
%         fprintf(fid,'5.2  number: conductivity value(s), observation point(s) E tang\n'); 
%         fprintf(fid,'%6i     %i\n',1,0);
%     
%         fprintf(fid,'5.3  conductivity value(s) in S/m (max. 3 per line)\n'); 
%         fprintf(fid,'%E\n',ant.Wire(2));
%  
%         fprintf(fid,'5.4  conductivity domain(s)\n'); 
%         fprintf(fid,'%6i\n',Nsegs);
%     else
%         fprintf(fid,'5.1  skin effect (1/0)\n'); 
%         fprintf(fid,'%6i\n',0);     % epsilon+scin effect packts concept net
%     end % no skin effect
  
% excitation
    
for n=1:length(ant.SegFeeds)
    fprintf(fid,'EX 0 1 %i 00 1.0 0.0            \n',ant.SegFeeds(n));
    fprintf(fid,'XQ 0                                                \n');
end % for
    % jetzt kommt nur blabla
    
%     fprintf(fid,'6.1  number of load impedances\n'); 
%     fprintf(fid,'%6i\n',0);
%     fprintf(fid,'7.1  current distribution on wires\n'); 
%     fprintf(fid,'%6i\n',0);
%     fprintf(fid,'7.3  number of currents at discrete points\n'); 
%     fprintf(fid,'%6i\n',0);
%     fprintf(fid,'9.0  rcs (0/1)\n'); 
%     fprintf(fid,'%6i\n',0);
%     fprintf(fid,'9.1  number of field points\n'); 
%     fprintf(fid,'%6i\n',0);
%     fprintf(fid,'10.3  total number of "cable wires"\n'); 
%     fprintf(fid,'%6i\n',0);
%     fprintf(fid,'11.1  surface currents (0/1/2)\n'); 
%     fprintf(fid,'%6i\n',0);
    
    
    % method to solve the system of equation...12 is the normal LU
    % decomposition with row pivoting...works always
    
%     fprintf(fid,'12.1  direct: 11,12,13, special direct solv. 21,22, iter. solver: 31,32,33\n'); 
%     fprintf(fid,'%6i\n',12);


fprintf(fid,'EN 0                                                \n');

% close completed input file:
  
s=fclose(fid);
if s<0,
  error(['Could not close file ',CIF]);
end


