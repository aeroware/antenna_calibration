
function [dr,Curr1e]=Concept_Curr1(Desc,Curr1,Curr1b)

% [dr,Curr1e]=Concept_Curr1(Desc,Curr1,Curr1b)
% determines relative distances dr of the maxima of the Concept basis  
% functions (triangles) within the respective segments (measured from
% 1st end towards 2nd end); furthermore, calculates the currents Curr1e 
% at the segment ends. 
%
% Curr1 is a cell array of vectors, each vector containing the 
% current amplitudes associated to the respective basis functions.
% Curr1b contains the connection identification numbers of the wires, which
% establishes the arrangement of basis functions along the wire segments.
%
% dr is a cell array of the same size as Curr1, with the same internal structure.
% Curr1e is a nsegs x 2 array, with nsegs being the number of segments.
% The first column of Curr1e contains the currents at the beginning (1st end) 
% of the segments, the second column the currents at the (2nd) end of the segments.

% wire identifiers (in Curr1b):
%
% 1:      1st end of segment connected to ground (z=0), 
%           the 2nd end being free (no connections);
% 3,4:    one connection to ground (z=0), at 1st end (3) or at 2nd end (4), 
%           the other end connected to further wire(s);
% 5,-5:   one connection to other wires, at 1st end (5) or 2nd end (-5),
%           the other segment end free
% 6:      wire connections at both segment ends (6)
% 7:      both segment ends free (7)
% 15,-15: 1st end (15) or 2nd end (-15) is connected to a patch,
%           with no connections at the other end
% 16,-16: 1st end (16) or 2nd end (-16) is connected to a patch,
%           with wire connections at the other end
% 26:     both ends connected to patches (26)


nsegs=size(Desc,1);
if (length(Curr1)~=nsegs)||(length(Curr1b)~=nsegs),
  error('Inconsistent size of input arrays.');
end

nb=cellfun('length',Curr1);   % number of basis functions

% trailing lengths n1 and n2 of basis functions at 1st and 2nd end of segments: 

n1=zeros(nsegs,1);
n2=zeros(nsegs,1);

n1((Curr1b==1)|(Curr1b==3)|(Curr1b==-5)|(Curr1b==7)|...
  (Curr1b==15)|(Curr1b==-15)|(Curr1b==16)|(Curr1b==26))=1;
n1((Curr1b==4)|(Curr1b==5)|(Curr1b==6)|(Curr1b==-16))=0.5;

n2((Curr1b==1)|(Curr1b==4)|(Curr1b==5)|(Curr1b==7)|...
  (Curr1b==15)|(Curr1b==-15)|(Curr1b==-16)|(Curr1b==26))=1;
n2((Curr1b==3)|(Curr1b==-5)|(Curr1b==6)|(Curr1b==16))=0.5;

% is surface connection (path or ground) at 1st and 2nd end of segments:

s1=(Curr1b==1)|(Curr1b==3)|(Curr1b==15)|(Curr1b==16)|(Curr1b==26);
s2=(Curr1b==4)|(Curr1b==-15)|(Curr1b==-16)|(Curr1b==26);
 
% loop over segments:

dr=cell(nsegs,1);
Curr1e=zeros(nsegs,2);

ss=FindSegs(Desc,'all');

for n=1:nsegs,
  
  dr{n}=(n1(n)+(0:nb(n)-1))/(n1(n)+nb(n)-1+n2(n));
  
  % 1st end of segment:
  
  if s1(n),         % connection to patch or ground
    Curr1e(n,1)=Curr1{n}(1);
  elseif n1(n)==1,  % open wire end
    Curr1e(n,1)=0;
  else              % connection to other segment(s)
    Curr1e(n,1)=Curr1e(n,1)+Curr1{n}(1)/2;
    neigh=setdiff(ss{Desc(n,1)},n); % neighbours (segments met at start node)
    ind=sub2ind([nsegs,2],abs(neigh),1+(neigh<0));
    Curr1e(ind)=Curr1e(ind)-sign(neigh).*Curr1{n}(1)/2;
  end

  % 2nd end of segment:

  if s2(n),         % connection to patch or ground
    Curr1e(n,2)=Curr1{n}(end);
  elseif n2(n)==1,  % open wire end
    Curr1e(n,2)=0;
  else              % connection to other segment(s)
    Curr1e(n,2)=Curr1e(n,2)+Curr1{n}(end)/2;
    neigh=setdiff(ss{Desc(n,2)},-n); % neighbours (segments met at end node)
    ind=sub2ind([nsegs,2],abs(neigh),1+(neigh<0));
    Curr1e(ind)=Curr1e(ind)+sign(neigh).*Curr1{n}(end)/2;
  end
  
end

