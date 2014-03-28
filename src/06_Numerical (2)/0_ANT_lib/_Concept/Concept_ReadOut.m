 
function Op=Concept_ReadOut(WorkingDir)

% Op=Concept_ReadOut(WorkingDir)
% reads data from the concept output file COF, default is
% COF='concept.out'. The returned parameters are the currents for 
% the wires and surfaces, which are returned in the fields Curr1 and Curr2
% of the struct Op. If several frequencies are found in COF, Op is an 
% array where each element contains the respective loaded parameters 
% of the found frequencies.
%
% Op.Reread.Freq returns the frequency.
%
% Op.Curr1 is a cell vector of length s, s being the number of segments.  
% Each cell contains a vector of current amplitudes corresponding 
% to the wire basis functions of the respective segment. So the length of
% Op.Curr1{n} is the number of basis functions used to represent 
% the currents on the n-th segment.
% Op.Curr1b contains the segment type according to CONCEPT wire
% identification, i.e. a number which deines the connection types at
% the segment ends. This is essential since the arrangement of basis 
% functions along the wire depend on that.
%
% Op.Curr2 is a vector of current amplitudes corresponding to the surface 
% current basis functions defined in Op.Curr2b (which consists of 2
% columns giving the numbers of the patches from and to which the current 
% flows, respectively).


global Atta_Concept_Out

if ~exist('WorkingDir','var')||isempty(WorkingDir),
  WorkingDir='';
end

OutF=fullfile(WorkingDir,Atta_Concept_Out);
d=dir(OutF);
if isempty(d)||d.isdir,
  error(['File ',OutF,' not found.']);
end

% open file

fid=fopen(OutF,'rb');

% error function

ErrorInLine=@(x)(...
  error('Errorneous/incomplete declaration encountered, line %d in file.',x));



% Reread epsr of external medium
% ------------------------------

Ln=0;

epsr=1;
  
while ~feof(fid),
  
  x=fgetl(fid);
  Ln=Ln+1;

  m=strfind(x(~isspace(x)),'2.5tan_delta,rel.permittivity');

  if ~isempty(m),
    x=[];
    while ~feof(fid)&&isempty(x),
      x=fgetl(fid);
      Ln=Ln+1;
      x=strtrim(x);
    end
    tandeltaepsr=sscanf(x,'%e',inf);
    if length(tandeltaepsr)~=2,
      error('Incorrect permittivity declaration encountered.');
    end
    epsr=tandeltaepsr(2)+j*tandeltaepsr(1)*tandeltaepsr(2);
    break
  end
  
end    

if feof(fid),
  frewind(fid);
end


% determine number of segments and wire (segment connection) type:
% ----------------------------------------------------------------

[q,Ln]=FindAnnouncedNumbers(fid,Ln,'Wire types computed by the program:');
if iscell(q),
  ErrorInLine(Ln); 
end

fgetl(fid);
Ln=Ln+1;

WireNumberAnnouncement='wire number:';
WireTypeAnnouncement='identification:';

[q,Ln,x]=FindAnnouncedNumbers(fid,Ln,WireNumberAnnouncement);
if ~isequal(q,1),
  ErrorInLine(Ln); 
end

Nsegs=0;
WireType=zeros(2000,1);

m=strfind(x,WireNumberAnnouncement);
while ~isempty(deblank(x))&&~isempty(m),
  Nsegs=Nsegs+1;
  m=m(1)+length(WireNumberAnnouncement);
  q=sscanf(x(m:end),'%e',1);
  if ~isequal(q,Nsegs),
    error('Wire segment counting ?? in line %d.',Ln);
  end
  mm=strfind(x,WireTypeAnnouncement);
  mm=mm(1)+length(WireTypeAnnouncement);
  qq=sscanf(x(mm:end),'%e',1);
  if length(qq)~=1,
    error('Incorrect wire type in line %d.',Ln);
  end
  WireType(q)=qq;
  x=fgetl(fid);
  Ln=Ln+1;
  m=strfind(x,WireNumberAnnouncement);
end  

WireType=WireType(1:Nsegs);


% read currents for all frequencies:
% ----------------------------------

Nfreq=0;
Op=struct([]);

while ~feof(fid),   % Frequency loop
  
  [q,Ln]=FindAnnouncedNumbers(fid,Ln,'Frequency of step:');
  if length(q)~=2,
    break
  end
  Nfreq=Nfreq+1;
  Op(1,Nfreq).Reread.Freq=q(2)*1e6; % frequency in MHz -> in Hz
  
  Op(Nfreq).Reread.Exterior.epsr=epsr;
  
  Lnold=Ln;
  [q,Ln]=FindAnnouncedNumbers(fid,Ln,'Total number of wire current amplitudes:');
  if (length(q)~=1)||((Ln-Lnold)~=1),
    ErrorInLine(Ln); 
  end
  Op(Nfreq).WireBases=q;
  
  Lnold=Ln;
  [q,Ln]=FindAnnouncedNumbers(fid,Ln,'Total number of patch current amplitudes:');
  if (length(q)~=1)||((Ln-Lnold)~=1), 
    ErrorInLine(Ln); 
  end
  Op(Nfreq).SurfBases=q;
  
  % wire current amplitudes:
  
  Op(Nfreq).Curr1=cell(Nsegs,1);

  if Nsegs>0,

    m=0;
    for s=1:Nsegs,

      [q,Ln,x]=FindAnnouncedNumbers(fid,Ln,'Current distribution on');
      if iscell(q), ErrorInLine(Ln); end
      q=strfind(x,'(');
      if isempty(q), ErrorInLine(Ln); end
      q=sscanf(x(q+1:end),'%e',1);
      if isempty(q)||(q<1)||(q~=round(q)), ErrorInLine(Ln); end

      fgetl(fid);
      fgetl(fid);
      if feof(fid),
        error('Unexpected end of file.');
      end
      Ln=Ln+2;

      Op(Nfreq).Curr1{Nsegs}=zeros(1,q);
      for qq=1:q,
        x=fgetl(fid);
        Ln=Ln+1;
        if feof(fid),
          error('Unexpected end of file.');
        end
        ri=sscanf(x,'%e',2);
        if length(ri)~=2,
          error('Error during reading %d-th current amplitude of %d-th segment.',...
            qq,s);
        end
        Op(Nfreq).Curr1{s}(qq)=ri(1)+j*ri(2);
      end

      m=m+qq;

    end % segments loop

    if m~=Op(Nfreq).WireBases,
      error('Only %d wire current amplitudes found, %d expected.',...
        m,Op(Nfreq).WireBases);
    end

  end

  % wire types:
  
  Op(Nfreq).Curr1b=WireType(:);
  
  % surface current amplitudes and normal component of E-field:
  
  Op(Nfreq).Curr2=zeros(Op(Nfreq).SurfBases,1);
  Op(Nfreq).Curr2b=zeros(Op(Nfreq).SurfBases,2);
  Op(Nfreq).Ensurf=zeros(0,1);

  if Op(Nfreq).SurfBases>0,

    [q,Ln,x]=FindAnnouncedNumbers(fid,Ln,'Surface currents (A/m)');
    if iscell(q), ErrorInLine(Ln); end

    while ~feof(fid)&&isempty(strfind(x,'=>')),
      x=fgetl(fid);
      Ln=Ln+1;
    end

    if feof(fid),
      error('Announced %d surface current amplitudes not found.',...
        Op(Nfreq).SurfBases);
    end

    for s=1:Op(Nfreq).SurfBases,

      m=strfind(x,'=>')+2;
      if length(m)~=1,
        error('Error in reading %d-th surface current amplitude.',s);
      end

      q=sscanf(x,'%e',2);
      qq=sscanf(x(m:end),'%e',3);
      
      if (length(q)~=2)||(length(qq)~=3),
        error('Error in reading %d-th surface current amplitude.',s);
      end

      Op(Nfreq).Curr2(s)=qq(2)+j*qq(3);
      Op(Nfreq).Curr2b(s,:)=[q(2),qq(1)];
      
      if feof(fid),
        error(...
          ['Reached end of file while reading surface currents ',...
           'in line ',num2str(Ln),'.']);
      end
      
      x=fgetl(fid);
      Ln=Ln+1;
      
    end

   
    % read En (component of E-field normal to patches):
    
    [q,Ln,x]=FindAnnouncedNumbers(fid,Ln,'Normal component of E');
    if iscell(q), ErrorInLine(Ln); end

    q=sscanf(x,'%e',inf);
    while ~(feof(fid)||((length(q)==5)&&(1==q(1))));
      x=fgetl(fid);
      Ln=Ln+1;
      q=sscanf(x,'%e',inf);
    end

    Npats=max(Op(Nfreq).Curr2b(:));  % number of patches
    Op(Nfreq).Ensurf=zeros(Npats,1);
    
    p=1;  % next patch
    
    while (length(q)==5)&&(p==q(1)),

      Op(Nfreq).Ensurf(p)=q(2)+j*q(3);
      
      if feof(fid), break, end
      
      x=fgetl(fid);
      Ln=Ln+1;
      p=p+1;
      q=sscanf(x,'%e',inf);
      
    end
    
    if p==1,
      error('Surface normal E-field components not found.');
    end
    
    Npats=p-1;  % correct number of patches
    Op(Nfreq).Ensurf=Op(Nfreq).Ensurf(1:Npats);
    
  end % reading surface current amplitudes and En 
  
  
end  % frequency loop


Op=rmfield(Op,{'SurfBases','WireBases'});


% close file:

fclose(fid);

% reread surface patches (also needed to correct current values (below):

Grid=Concept_ReadSurf(WorkingDir);
Op.Reread.Geom=Grid.Geom;
Op.Reread.Desc2d=Grid.Desc2d;

if Npats~=length(Grid.Desc2d),
  error('Number of patches in Op.Reread.Desc2d and Op.Ensurf do not agree.')
end
  

% finally correct current amplitudes:
% the currents from path to wires are saved in Amperes, whereas the 
% the currents from patch to patch are saved as current per edge length
% in A/m (yes they are! - so there is a mixture of A and A/m values in 
% concept.out). This is in contrast to the data in the binary file ifl.bin,
% where all results are currents in Ampere!

if Npats>0,
  for b=1:size(Op.Curr2,1),
    pp=Op.Curr2b(b,:);
    if all(pp<=Npats),
      nn=intersect(Grid.Desc2d{pp});
      if length(nn)~=2,
        error(sprintf('Patches %d and %d dont have exactly 1 edge in common.',pp));
      end
      Op.Curr2(b,:)=Op.Curr2(b,:).*...
        Mag(Grid.Geom(nn(1),:)-Grid.Geom(nn(2),:),2);
    end
  end
end


end  % Concept_ReadOut


% --------------------------

function [FoundNumbers,Ln,x]=FindAnnouncedNumbers(fid,Ln,Announcement)

FoundNumbers={}; % in case no announcement found
x='';

while ~feof(fid),
  
  x=fgetl(fid);
  Ln=Ln+1;

  m=strfind(x,Announcement);

  if length(m)==1,
    m=m+length(Announcement);
    FoundNumbers=sscanf(x(m:end),'%e',inf);
    break
  end
  
end    
    
end

