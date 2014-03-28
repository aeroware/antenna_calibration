
function Concept_CreateIn(PhysGrid,Freq,FeedNum,Titel,WorkingDir)

% Concept_CreateIn(PhysGrid,Freq,Titel,FeedNum,WorkingDir)
% creates CONCEPT input file in directory WorkingDir
% (default is the current working directory) 
% by translating given data into CONCEPT input format.
% Freq defines the operation frequency. Titel is an optional title 
% which is written as first item to the file.
% PhysGrid defines the antenna system, the following fields of which are used:
%
%   Geom .. N x 3, coordinates of grid nodes (x,y,z) 
%   Desc .. S x 2, wire segments (start node, end node)
%   Desc2d .. P x 1 cell, patches (represented by node vectors)
%   Geom_.Feeds, Desc_.Feeds .. loads at nodes and segments, respectively
%     Feeds.Elem element numbers, 
%     Feeds.Posi position specification 
%       (CONCEPT: 'a' beginning, 'm' middle, 'e' end)
%   Geom_.Loads, Desc_.Loads .. loads at nodes and segments, respectively
%     Loads.Elem and Loads.Posi the same as for Feeds
%     Loads.Z    Impedances
%   Desc_.Wire.Diam, Desc_.Wire.Cond, segment diameters and conductivities
%   Exterior.epsr  .. dielectric constant of exterior medium
%
% All physical quantities are supposed to be in SI-units!
%
% The wire conductivities may be inf indicating perfectly conducting wires.
%
% FeedNum='all' signifies that all feeds PhysGrid.Desc_.Feeds.Elem are
% driven, namely by the respective voltages PhysGrid.Desc_.Feeds.V.
% In case FeedNum is numeric, only the feed with the number FeedNum
% is driven by 1 Volt, the others are short-circuited.

global Atta_Concept_In Atta_Concept_Wire1 Atta_Concept_Surf1

WriteWireFile=0;     
% wire file is not needed for CONCEPT calculations
% since the wire data are included in concept.in

if ~exist('WorkingDir','var')||isempty(WorkingDir),
  WorkingDir='';
end

deg=pi/180;

%cL=2.99792458e8;
%eps0=1/(4e-7*pi*cL^2);

% The following value is substituted for ideal conductivity 
% when also non-ideal conductors are present:
InfiniteCond=1e10; 

Nnodes=size(PhysGrid.Geom,1);
Nsegs=size(PhysGrid.Desc,1);
Npats=length(PhysGrid.Desc2d);


% write wire file
% ===============

% only correct if the number of bases is the same for all segments, see (*)

if WriteWireFile&&(Nsegs~=0),
   
   WireFile=fullfile(WorkingDir,Atta_Concept_Wire1);

   fid=fopen(WireFile,'wt');
   if fid<0,
      error(['Could not open/create file ',WireFile]);
   end

   fprintf(fid,'%i\n',Nsegs);

   for L=1:Nsegs
      fprintf(fid,'%20.10E %20.10E %20.10E  %20.10E %20.10E %20.10E \n',...
         PhysGrid.Geom(PhysGrid.Desc(L,1),:),PhysGrid.Geom(PhysGrid.Desc(L,2),:));
   end

   fprintf(fid,'%i\n',max(3,mode(PhysGrid.Desc_.NBases)));  % (*)

   if fclose(fid)<0,
      error(['Could not close file ',WireFile]);
   end

end


% write surface file
% ==================

if Npats~=0,
   
   SurfFile=fullfile(WorkingDir,Atta_Concept_Surf1);

   fid=fopen(SurfFile,'wt');
   if fid<0,
      error(['Could not open/create file ',SurfFile]);
   end

   fprintf(fid,'%i  %i\n',Nnodes,Npats);

   for L=1:Nnodes
      fprintf(fid,'%20.10E %20.10E %20.10E \n',PhysGrid.Geom(L,:));
   end

   for L=1:Npats
      switch length(PhysGrid.Desc2d{L})
         case 3
            fprintf(fid,'%5i %5i %5i     0 \n',PhysGrid.Desc2d{L});
         case 4
            fprintf(fid,'%5i %5i %5i %5i \n',PhysGrid.Desc2d{L});
         otherwise
            error('ERROR...Concept accepts only patches with 3 or 4 nodes !');
      end
   end

   if fclose(fid)<0,
      error(['Could not close file ',SurfFile]);
   end

end
    

% write Concept main input file
% =============================

epsr=EvaluateFun(PhysGrid.Exterior.epsr,Freq);
epsr(epsr==0)=1;

if length(unique(epsr))>1,
  warning(['Different relative dielectric constants cannot be handled',...
    'in multi-frequency call; epr of the first frequency is used for all.']);
end

% open file
% ---------

CIF=fullfile(WorkingDir,Atta_Concept_In);

fid=fopen(CIF,'wt');
if fid<0,
  error(['Could not open/create file ',CIF]);
end

% Title
% -----

if ~exist('Titel','var')||isempty(Titel),
  Titel='';
end
if ~ischar(Titel),
  Titel=char(Titel);
end
if size(Titel,1)~=0,
  Titel=Titel.';
  Titel=Titel(:).';
end
Titel=Titel(1:min(69,length(Titel)));  % max 69 characters are allowed

fprintf(fid,'1.1  characterization of the structure\n');
fprintf(fid,' %s\n',Titel);

% symmetry (0=no symmetry assumed here)
% -------------------------------------

fprintf(fid,'2.1   symmetry with respect to the xz plane, yz plane or both\n');
fprintf(fid,'%6d\n',0);

% wires
% -----

fprintf(fid,'2.2   number of wires, id. ground, segments per wavelength, coating\n');
if epsr~=1,
  fprintf(fid,'%5i %5i %5i %5i\n',Nsegs, 7,8,0);
else
  fprintf(fid,'%5i %5i %5i %5i\n',Nsegs, 0,8,0);
end

for L=1:Nsegs,
  
  fprintf(fid,'2.30  wire %i   : coordinates\n', L);
  fprintf(fid,'%10.5f %10.5f %10.5f %10.5f %10.5f %10.5f \n',...
    [PhysGrid.Geom(PhysGrid.Desc(L,1),:),PhysGrid.Geom(PhysGrid.Desc(L,2),:)]);

  fprintf(fid,'2.31  wire %i   : radius, no. of basis functions, RB, EP, MY\n', L);
  % anscheinend braucht man nur die ersten 2
  fprintf(fid,'%10.6f    %i\n', ...
    PhysGrid.Desc_.Diam(L)/2*1000,PhysGrid.Desc_.NBases(L)); 
    % radius in mm, and number of bases
  
end

fprintf(fid,'2.6   check wire grid\n');
fprintf(fid,'%6i\n',1);
     

% exterior medium
% ---------------

if epsr~=1,
  fprintf(fid,'2.5   tan_delta, rel. permittivity\n');
  fprintf(fid,'  %12.6E  %12.6E\n', ...
    imag(epsr)/real(epsr),real(epsr));
end 

% always require output of wire currents
% --------------------------------------

fprintf(fid,'3.1  print of currents\n');
fprintf(fid,'%6d\n',1);

% Excitation 
% ----------

if ~exist('FeedNum','var')||isempty(FeedNum),
  FeedNum='all';
end
  
[V,Feeds0,Feeds1,Pos]=GetFeedVolt(PhysGrid,FeedNum);

if length(Feeds0)~=0,
  error('Feed nodes cannot be used with CONCEPT.');
end

if isnumeric(FeedNum),
  
  fprintf(fid,'3.2  excitation\n');
  fprintf(fid,'%6d\n',1);
  % (1=one volt and no phase specified)
  
  fprintf(fid,'3.3  generator position, internal resistance (excitation=1)\n');
  fprintf(fid,' %c%-3d    %f\n',Pos(FeedNum),Feeds1(FeedNum),0);
  
else
  
  fprintf(fid,'3.2  excitation\n');
  fprintf(fid,'%6d\n',2);
  % (2=Volts and phases specified)
  
  fprintf(fid,'3.4  lumped/continuous gen. ,no. of voltage gen., ampl./phase (excitation=2)\n');
  fprintf(fid,'%6d %6d %6d\n',1,length(Feeds1),2);
  
  for n=1:length(Feeds1),
    if mod(n,5)==1,
      if n~=1,
        fprintf(fid,'\n');
      end
      fprintf(fid,'3.41 generator positions (max. 5 per line)\n');
    end
    fprintf(fid,' %c%-5d',Pos(n),Feeds1(n));
  end
  fprintf(fid,'\n');

  for n=1:length(Feeds1),
    fprintf(fid,'3.44 amplitude(%-4d), phase(%-4d)\n',n,n);
    fprintf(fid,' %15.6f %15.6f\n',abs(V(n)),angle(V(n))/deg);
  end
  
end

% frequency representation
% ------------------------

if length(Freq)==1,  % 1 .. single frequency
  
  fprintf(fid,'4.1  representation of frequency(ies) (1-6)\n');
  fprintf(fid,'%6d\n',1);

  fprintf(fid,'4.2  basic frequency\n');
  fprintf(fid,'%12.3E\n',Freq/1e6);
  
else  % 2 .. frequency loop
  
  fprintf(fid,'4.1  representation of frequency(ies) (1-6)\n');
  fprintf(fid,'%6d\n',2);

  fprintf(fid,'4.3  basic frequency, frequency step width, number of frequencies\n');
  fprintf(fid,'%12.3E %12.3E %i\n',...
    Freq(1)/1e6, (Freq(end)-Freq(1))/((length(Freq)-1)*1e6), length(Freq));
  
end

% skin effect, conductivity
% -------------------------

if (epsr==1)&&~all(isinf(PhysGrid.Desc_.Cond)),

  Co=PhysGrid.Desc_.Cond;
  Co(isinf(Co))=InfiniteCond;
  
  % check if each object has a unique conductivity:
  if any(diff(Co(:))&~diff(PhysGrid.Desc_.ObjNum(:))),
    warning('For the following objects there are several conductivities found:');
    ob=unique(PhysGrid.Desc_.ObjNum);
    fprintf('Object-number  conductivities [MS/m]\n');
    for n=ob(:).',
      cc=unique(Co(PhysGrid.Desc_.ObjNum==n)/1e6);
      if length(cc)>1,
        fprintf('%10d    ',n);
        fprintf('%12.3E',cc);
        fprintf('\n');
      end
    end
    fprintf('\n');
  end
      
  la=find(diff(Co(:))|diff(PhysGrid.Desc_.ObjNum(:)));
  la(end+1)=Nsegs;    
      
  fprintf(fid,'5.1  skin effect (1/0)\n');
  fprintf(fid,'%6d\n',1);

  fprintf(fid,'5.2  number: conductivity value(s), observation point(s) E tang\n');
  fprintf(fid,'%6d     %i\n',length(la),0);
  
  for n=1:length(la),
    if mod(n,3)==1,
      if n~=1,
        fprintf(fid,'\n');
      end
      fprintf(fid,'5.3  conductivity value(s) in S/m (max. 3 per line)\n');
    end
    fprintf(fid,'%15.5E',Co(la(n)));
  end
  fprintf(fid,'\n');

  for n=1:length(la),
    if mod(n,5)==1,
      if n~=1,
        fprintf(fid,'\n');
      end
      fprintf(fid,'5.4  conductivity domain(s)\n');
    end
    fprintf(fid,'%6d',la(n));
  end
  fprintf(fid,'\n');
  
else  % epsr~=1 or all ideal conductors

  % It seems that Concept cannot handle skin effect
  % when external relative epsilon ~= 1
  
  if ~all(isinf(PhysGrid.Desc_.Cond)),
    warning(['Conductivity of all conductors is altered to infinity, ',...
      'otherwise CONCEPT could not handle epsr~=1.']);
  end
  
  fprintf(fid,'5.1  skin effect (1/0)\n');
  fprintf(fid,'%6d\n',0);     
  
end 

% loads
% -----

try 
  Lo=PhysGrid.Desc_.Loads.Elem;
  LoPosi=PhysGrid.Desc_.Loads.Posi;
  RL=real(PhysGrid.Desc_.Loads.Z);
  LL=imag(PhysGrid.Desc_.Loads.Z)/(2*pi*Freq(1));
  if numel(unique(Freq))~=1,
    warning(['Inconsistency: There are different frequencies to be operated,\n',...
      'but load inductances can only be determined once,\n',...
      'so they are calculated on the basis of the first frequency!\n']);
  end
catch
  Lo=[];
end  

if length(Lo)~=length(LL),
  error('Inconsistent load information in antenna Desc_ field.');
end

fprintf(fid,'6.1  number of load impedances\n');
fprintf(fid,'%6d\n',length(Lo));

if ~isempty(Lo),

  for n=1:length(Lo),
    if mod(n,5)==1,
      if n~=1,
        fprintf(fid,'\n');
      end
      fprintf(fid,'6.2  loaded wires (max. 5 per line)\n');
    end
    fprintf(fid,' %c%-7d',LoPosi(n),Lo(n));
  end
  fprintf(fid,'\n');

  for n=1:length(Lo),
    if mod(n,5)==1,
      if n~=1,
        fprintf(fid,'\n');
      end
      fprintf(fid,'6.3  circuitry identifiers (max. 5 per line)\n ');
    end
    fprintf(fid,'%8d',1);
  end
  fprintf(fid,'\n');

  for n=1:length(Lo),
    if mod(n,5)==1,
      if n~=1,
        fprintf(fid,'\n');
      end
      fprintf(fid,'6.4  lumped load: 1, continuous load: 2 ( max. 5 je Zeile)\n ');
    end
    fprintf(fid,'%8d',1);
  end
  fprintf(fid,'\n');

  for n=1:length(Lo),
    fprintf(fid,'6.50 load elements  (R-L-C)\n');
    fprintf(fid,'%15.5f %15.5f\n',RL(n),LL(n)*1e6);
    % Concept expects R in Ohms, L in microhenrys !!
  end

  fprintf(fid,'6.6  number of voltage reference points\n');
  fprintf(fid,'%6d\n',0);

end % if loads exist

% etc.
% ----

fprintf(fid,'7.1  current distribution on wires\n');
fprintf(fid,'%6d\n',0);
fprintf(fid,'7.3  number of currents at discrete points\n');
fprintf(fid,'%6d\n',0);
fprintf(fid,'9.0  rcs (0/1)\n');
fprintf(fid,'%6d\n',0);
fprintf(fid,'9.1  number of field points\n');
fprintf(fid,'%6d\n',0);
fprintf(fid,'10.3  total number of "cable wires"\n');
fprintf(fid,'%6d\n',0);

fprintf(fid,'11.1  surface currents (0/1/2)\n');   % declare surfaces
if Npats==0,
  fprintf(fid,'%6d\n',0);
else
  fprintf(fid,'%6d\n',1);
end

fprintf(fid,'11.10   check surface grid (0/1)\n');
fprintf(fid,'%6i\n',1);

fprintf(fid,'11.11  physical optics (0/1)\n');
fprintf(fid,'%6d\n',0);

fprintf(fid,'12.1  direct: 11,12,13, special direct solv. 21,22, iter. solver: 31,32,33\n');
fprintf(fid,'%6d\n',12);

% close Concept input file
% ------------------------
  
if fclose(fid)<0,
  error(['Could not close file ',CIF]);
end


