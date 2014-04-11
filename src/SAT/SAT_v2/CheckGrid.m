function CheckGrid(Ant,lambda)

% This functions checks if the wiregird for the evaluation
% with MATLAB/ASAP is correct with regard to the ASAP restrictions.
% CheckGrid(Ant,lambda) is the command, where Ant is the structure
% variable of the grid and lambda is the wavelength in m.

% Check dimensions of values

szgeom=size(Ant.Geom);szdesc=size(Ant.Desc);
szfeed=size(Ant.Feed);szwire=size(Ant.wire);
if szgeom(2)~=3
   disp('Matrix Geom has not 3 columns!')
end
if szdesc(2)~=2
   disp('Matrix Desc has not 2 columns!')
end
if szwire(2)~=2
   disp('Structure Wire has not 2 columns!')
end

% Check the values
if Ant.wire(1)<=0 
   disp('WireRadi must be greater than zero!')
end
if Ant.wire(2)<=0
   disp('Conductivity must be greater than zero!')
end
if min(min(Ant.Desc))<=0
   disp('One value of Desc-Matrix is not greater than zero!')
end
if max(max(Ant.Desc))>szgeom(1)   
   disp('One value of Desc-Matrix is greater than total number of nodes!')
end
if sum(Ant.Desc-round(Ant.Desc))~=0
   disp('Desc should contain only integer values!')
end
if (Ant.Init-round(Ant.Init))~=0
   disp('Inte should be an integer value!')
end
if Ant.Feed(:)<=0 | max(Ant.Feed(:))>szgeom(1)
   disp('Feeding point has a wrong index!')
end

% Are the values realistic?
if Ant.wire(1)>1e-1 | Ant.wire(1)<1e-7
   disp('WireRadi has not a realistic value.')
end
if Ant.wire(2)<10 | Ant.wire(2)>1e15
   disp('Conductivity has an unrealistic value.')
end

% Blank lines
blank=sprintf('\n');
disp(blank);

% ASAP-restrictions
% -----------------
% Which nodes are connected to how many segments?
for i=1:szgeom(1)		                    % loop over all nodes
   nrnodes(i)=length(find(Ant.Desc==i));	% How often is node i in Desc?
end
if max(nrnodes)>4 
   disp('The following node(s) are connected to more than four segments:')
   find(nrnodes>4)
end
%disp('The following nodes are connected to one segment:')
%find(nrnodes==1)
%disp('The following nodes are connected to two segments:')
%find(nrnodes==2)
%disp('Connected to three segments:')
%find(nrnodes==3)
%disp('Connected to four segments:')
%find(nrnodes==4)

% Check isolated wires
disp(blank);
v1s=find(nrnodes==1);
szv1s=length(v1s);
% Find row numbers of Desc of interesting nodes
for i=1:szv1s
   cs(i)=find(Ant.Desc==v1s(i));
   if cs(i)>szdesc(1)
      cs(i)=cs(i)-szdesc(1);
   end
end
isoseg=0;
for i=1:szv1s % Are there any equal row numbers?
   ccc=find(cs==cs(i));
   if length(ccc)==2
      isoseg=1;
      ccc1str=num2str(v1s(ccc(1)));
      ccc2str=num2str(v1s(ccc(2)));
      disp(['Node No. ' ccc1str ' and No. ' ccc2str ' form an isolated wire,'])
      disp('which consists only of one segment! Isolated wires should at')
      disp('least contain two segments!')
   end
end
if isoseg==0
   disp('There are no isolated wires consisting of only one segment.')
end
disp(blank);

% Calculate the length of all segments
for i=1:szdesc(1)			        % loop over all segments
   p1=Ant.Geom(Ant.Desc(i,1),:);    % x,y,z from first point in Desc
   p2=Ant.Geom(Ant.Desc(i,2),:);    % x,y,z from second point in Desc
   seglength(i)=sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2+(p1(3)-p2(3))^2);
end
longseg=max(seglength);			        % longest segment
shortseg=min(seglength);		        % shortest segment
longsegnr=find(seglength==longseg);		% number of longest segment
shortsegnr=find(seglength==shortseg);	% number of shortest segment

% Relations between Wireradius, Wavelength, shortest and longest segment
disp('Your model has the following characteristic values (in m):')
Wavelength=lambda
Wire_radi=Ant.wire(1)
Length_of_shortest_segment=shortseg
Length_of_longest_segment=longseg
disp('The longest segment is between the following nodes:')
Ant.Desc(longsegnr,:)
disp('The shortest segment is between the following nodes:')
Ant.Desc(shortsegnr,:)
disp(blank);
disp('These are the restrictions of ASAP:')
disp('* Wavelength/Wireradius > 100')
disp('* shortest segment/Wireradius > 60')
disp('* Wavelength/longest segment > 4')
disp('* longest segment/shortest segment < 100')
disp(blank);
r1=lambda/Ant.wire(1);
disp('The ratio Wavelength/Wireradius is:')
Ratio_1=r1
r2=shortseg/Ant.wire(1);
disp('The ratio shortest segment/Wireradius is:')
Ratio_2=r2
r3=lambda/longseg;
disp('The ratio Wavelength/longest segment is:')
Ratio_3=r3
r4=longseg/shortseg;
disp('The ratio longest segment/shortest segment is:')
Ratio_4=r4
if r1<100
   disp('The ratio Wavelength/Wireradius is smaller than 100.')
end
if r2<60
   disp('The ratio shortest segment/Wireradius is smaller than 60.')
end  
if r3<4
   disp('The ratio Wavelength/longest segment is smaller than 4.')
end
if r4>100
   disp('The ratio longest segment/shortest segment is greater than 100.')
end
if r1<100 | r2<60 | r3<4 | r4>100
   disp('You should change your model, the frequency or the wireradius.')
end

% Control all angles between segments
disp(blank);
disp('Patience...calculating all angles between all segments.')
isangle=0;
for i=1:szgeom(1)		% loop over all nodes
   vecnodes=FindNodes(Ant.Geom,Ant.Desc,i);
   jmax=length(vecnodes);
   vec=zeros(jmax,3);
   for j=1:jmax
      vec(j,:)=Ant.Geom(vecnodes(j),:)-Ant.Geom(i,:);
   end
   angles=zeros(jmax,jmax);
   istring=num2str(i);
   for j=1:(jmax-1)
      for k=(j+1):jmax
         angles(j,k)=angle2vec(vec(j,:),vec(k,:));
         vec1str=num2str(vecnodes(j));
         vec2str=num2str(vecnodes(k));
         if angles(j,k)<30
            angstr=num2str(angles(j,k));
            disp(['An angle at node ' istring ' is < 30�!'])
            disp(['It is the angle between the two nodes ' vec1str ])
            disp(['and ' vec2str ', and it is ' angstr '�.'])
            isangle=1;
         end
      end
   end
   clear vecnodes   
end
if isangle==0
   disp('All angles between all segments are greater than 30�.')
end
disp(blank);

% Feeding point(s) at a node with 2 neighbouring segments
helpvec=find(nrnodes==2);
for i=1:szfeed(2)			% loop over all feeding points
   var1=0;
   istr=num2str(Ant.Feed(i));
   helpnr=find(helpvec==Ant.Feed(i));
   if isempty(helpnr)
      disp(['Feeding point ' istr ' is not at a node with two neighbouring segments!'])
      var1=1;
   end
	[i1,i2]=find(Ant.Desc==Ant.Feed(i));   
   if var1==0
      if (i2(1)-i2(2))==0
         var1=1;
         disp(['The two segments at feeding point ' istr ' have opposite'])
         disp('directions! This is not allowed, change the Desc-Matrix!')
      end
   end
   if var1==0
      disp(['Everything is okay with the feeding point at node ' istr '.'])
   end
end

% clear all variables 
clear szgeom szdesc szfeed szwire blank i nrnodes vls szvls cs isoseg ccc ...
   ccc1str ccc2str p1 p2 seglength longseg isangle jmax vec j ...
   shortseg longsegnr shortsegnr Wavelength Wire_radi r1 r2 r3 r4 ...
   Ratio_1 Ratio_2 Ratio_3 Ratio_4 Length_of_shortest_segment helpvec ...
   Length_of_longest_segment var1 helpnr i1 i2 istr angles istring ...
   vec1str vec2str


   
      

