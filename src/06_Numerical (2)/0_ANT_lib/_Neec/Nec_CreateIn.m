
function NecCreateIn(ant,Freq,FeedNum,Titel,WorkingDir, er)

% NecCreateIn(ant, Comment,Trailer,Freq,FeedNum,Titel,WorkingDir, er) 
% creates NEC input file (filename expected
% to be in Atta_nec) by translating given data into NEC input format.
% ant defines the antenna system struct, the following fields of which 
% are used to create the NEC input file:
%   Ant. Geom, Desc, Desc2d, Obj, Phys, Freq, Solver
% 
% Field description:
%   Geom    N x 3, coordinates of grid nodes (x,y,z) 
%   Desc    S x 2, grid segments (start node, end node)
%   Desc2d  cell(P,1), nodes of P patches 
%   Obj     objects, a structure array with the fields
%           Type, Elem, Name, Graf, Phys 
%   Phys    physical properties, in particular default values; 
%           it is a structure with at least the following fields:
%           Exterior.epsr relative permittivity of exterior medium
%           Wire.Cond   conductivity of wires (inf for perfect conductors)
%           Wire.Radius radius of wires
%   Title   title or name of antenna system (optional)
%
% Note that the ant structure contains a field Phys which defines the 
% default physical properties of the objects. In addition there is a field
% Phys in the objects (Ant.Obj.Phys) defining properties specific to the
% respective objects. If no definition of a specific object property is
% given, the respective default property in Ant.Phys is used. Further
% possible properties which can be defined in Ant.Obj.Phys:
%           Load        impedance of a connected load
%           Tag         tag, has to be nonnegative for active elements, 
%                       for Tag<0 only grafical depiction but no relevance 
%                       for calculations
%
%   Freq    operation frequency
%   Solver  defines the solver and solver-specific parameters:

% All physical quantities are supposed to be in SI-units!

global Atta_Nec_In;

rad=pi/180;

% open/create NEC input file:

CIF=fullfile(WorkingDir,Atta_Nec_In);

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


% header

fprintf(fid,'CM %s\n',Titel);


% wires  

for nF=1:length(ant.Desc_.Feeds.Elem)
    [ant,addN,addS]=GridSplitSegs(ant,ant.Desc_.Feeds.Elem(nF),0.33);
    ant.Desc_.Diam(addS)=ant.Desc_.Diam(ant.Desc_.Feeds.Elem(nF));
    ant.Desc_.Cond(addS)=ant.Desc_.Cond(ant.Desc_.Feeds.Elem(nF));

	ant.Desc_.Feeds.Elem(nF)=addS;
    [ant,addN,addS]=GridSplitSegs(ant,addS);
    ant.Desc_.Diam(addS)=ant.Desc_.Diam(ant.Desc_.Feeds.Elem(nF));
    ant.Desc_.Cond(addS)=ant.Desc_.Cond(ant.Desc_.Feeds.Elem(nF));
end
Nsegs=length(ant.Desc);

 for L=1:Nsegs
     fprintf(fid,'GW 1 1 %f %f %f %f %f %f %f\n'...
         ,ant.Geom(ant.Desc(L,1),:),ant.Geom(ant.Desc(L,2),:), ant.Desc_.Diam(L)); 
 end %for all wires

    
% patches

Npats=length(ant.Desc2d);

% patches umformatieren
found= false;
toberemoved=[];
joiningpoint=[];

for L=1:Npats
    
    
    for q=1:length(ant.Desc)
        if sum(ant.Desc2d{L}(:)==ant.Desc(q,1))>0
            found=true;
            toberemoved(end+1)=L;
            joiningpoint(end+1)=ant.Desc(q,1);
        elseif sum(ant.Desc2d{L}(:)==ant.Desc(q,2))>0
            found=true;
            toberemoved(end+1)=L;
            joiningpoint(end+1)=ant.Desc(q,2);
        end %if
    end % for
    
    
end

if (found==true)
     % patch kübeln
        
     s1=zeros(3,1);
     s2=s1;
     s3=s1;
     A=zeros(length(toberemoved),1);
     center=zeros(length(toberemoved),3);
     
     un=center;
     
     for(index=1:length(toberemoved))
         s1=ant.Geom(ant.Desc2d{index}(2),:)-ant.Geom(ant.Desc2d{index}(1),:);
         s2=ant.Geom(ant.Desc2d{index}(3),:)-ant.Geom(ant.Desc2d{index}(1),:);
         s3=ant.Geom(ant.Desc2d{index}(3),:)-ant.Geom(ant.Desc2d{index}(2),:);
         
         l1=sqrt(dot(s1',s1'));
         l2=sqrt(dot(s2',s2'));
         l3=sqrt(dot(s3',s3'));
         
         u=(l1+l2+l3)/2;
         
         % satz des heron
         
         A(index)=sqrt(u*(u-l1)*(u-l2)*(u-l3));
         center(index,:)=(s1+s2+s3)/3;
         
         normv=cross(s2,s1);
         un(index,:)=normv/norm(normv);
         
         if(index>1)
            for(index2=1:index-1)
                if(joiningpoint(index)==joiningpoint(index2))
                    A(index2)=A(index)+A(index2);
                    A(index)=0;
                end
            end
         end
             
     end
     
     ant2=GridRemove(ant,[],[],[],toberemoved);
end 
    
Npats=length(ant2.Desc2d);

for L=1:Npats
    if(length(ant2.Desc2d{L})==3)    % dreieck
        fprintf(fid,'SP 0 2 %f %f %f %f %f %f\n'...
            ,ant2.Geom(ant2.Desc2d{L}(1),:),ant2.Geom(ant2.Desc2d{L}(2),:)); 
     
        fprintf(fid,'SC 0 0 %f %f %f\n'...
           ,ant2.Geom(ant2.Desc2d{L}(3),:)); 
    elseif (length(ant2.Desc2d{L})==4)   % 4-eck
        fprintf(fid,'SP 0 2 %f %f %f %f %f %f\n'...
        ,ant2.Geom(ant2.Desc2d{L}(1),:),ant2.Geom(ant2.Desc2d{L}(2),:));  
     
        fprintf(fid,'SC 0 0 %f %f %f %f %f %f\n'...
            ,ant2.Geom(ant2.Desc2d{L}(3),:),ant2.Geom(ant2.Desc2d{L}(4),:)); 
    end % if 4 eck
end %for all patches

Npats2=length(toberemoved);

for L=1:Npats2
    if(A(L)>0)   
        elev=atan2(un(L,3),sqrt(un(L,1)^2+un(L,2)^2))/rad;
        azi=atan2(un(L,2),un(L,1))/rad;
        
        fprintf(fid,'SP 0 0 %f %f %f %f %f %f\n'...
            ,center(L,1),center(L,2),center(L,3)...
            , elev, azi, A(L)); % elevation and azimut of the unit vector
    end
end %for all patches

fprintf(fid,'GE 0 0\n');    % end of geometry

%   frequency 

fprintf(fid,'FR 0 1 0 0 %f 0\n',Freq);

%   excitation
[V,Feeds0,Feeds1,Pos]=GetFeedVolt(ant,FeedNum);

for nF=1:length(V)
    if(V(nF)==0)
        fprintf(fid,'EX 0 0 %d 0 %d 0 0\n',ant.Desc_.Feeds.Elem(nF),0.000001); 
    else
        fprintf(fid,'EX 0 0 %d 0 %d 0 0\n',ant.Desc_.Feeds.Elem(nF),V(nF)); 
    end
end 


% execute

fprintf(fid,'XQ 0\n');    

% end statement

fprintf(fid,'EN');
fclose(fid);

