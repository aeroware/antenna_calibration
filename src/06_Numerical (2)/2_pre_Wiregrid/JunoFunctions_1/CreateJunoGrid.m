function ant=CreateJunoGrid(config,deltaxi,zeta)

% CreateJunoGrid
% generate single Juno antenna grid
% ============================================================
%
%   config...configuration 1 or 2
%   deltaxi...angle between the two antennas
%   zeta...angle from the positive z-axis to the antennas
%
% generates Juno grid model for the analysis of the antennas, according to
% the instructions from bill kurth
%
% config 1: antennas below panel
% config 2: antennas between 2 panels
%
% Written by Thomas Oswald, March 2007
%
% Revised 10.05.07 by Thomas Oswald: Antenna length increased to 2.9m;
%   stabilizing connection for the solar panels fixed at bottom edge


deg=pi/180;
if(~exist('config'))
    config=1;
    deltaxi=90;
    zeta=90+0;
end

%------------------------------------------------------------------------

SP=struct(...
    'Length',8000,...      [mm]    Diameter of the Hull
    'Width',2000,...
    'Angle1',0, ...
    'Angle2',120,...
    'Angle3',240,...
    'RadialPos',sqrt(2000^2-1000^2));

ANTS=struct(...
    'RefP',[0,0,0],...     
    'FeedPos',[sqrt(2000^2-1000^2)+100,100,-1000;sqrt(2000^2-1000^2)+100,-100,-1000],...
    'Zeta',[zeta,zeta],...       % jetzt von der pos. xachse weg
    'Xi',[deltaxi/2,-deltaxi/2],...         % jetzt von der neg. zachse weg  
    'Length',2900,...
    'Nsegs',6,...
    'Wire',[2e-3,50e6]);

HighGainAntenna=struct(...
    'Radius',896, ...
    'Angle',0, ...
    'Pos', [-630,-1456,-1296]);
    
C=struct(...    % define grid configuration
  'HullDia',4000, ...     [mm]  
  'HullHeight',2000, ...     [mm]  
  'Panels',SP,...
  'HGA',HighGainAntenna, ...
  'Antennae',ANTS,...
  'Wire',[2e-3,50e6]);

%--------------------------------------------------------------------------

% conversion degrees->radians, m->mm:

C.Panels.Angle1=C.Panels.Angle1*deg;
C.Panels.Angle2=C.Panels.Angle2*deg;
C.Antennae.Zeta=C.Antennae.Zeta.*deg;
C.Antennae.Xi=C.Antennae.Xi.*deg;
C.Panels.Angle3=C.Panels.Angle3*deg;


% initialize model grid:

ant=GridInit;  

% --------------------------------------------------------------
% overall graphical properties of patches, segments and points
% --------------------------------------------------------------



SurfProp=struct('EdgeColor','none',...
  'DiffuseStrength',0.4,'AmbientStrength',0.6,...
  'SpecularStrength',0.3,'SpecularColorReflectance',1,'SpecularExponent',3,...
  'FaceAlpha',1,'FaceLighting','flat','BackFaceLighting','unlit');

WireProp=struct('LineWidth',0.5,'Color',[0,0,0]);

PointProp=struct('Marker','o','MarkerEdgeColor','r','MarkerFaceColor','r');

EdgeDarken=0.3;

% --------------------
% hull (central body)
% --------------------

% graphical properties:

HullPropWire=WireProp;
HullPropSurf=SurfProp;
HullPropSurf.FaceColor=[0.9,0.8,0.5]*0.8;

% geometrical specifications:


HullPos=[-C.HullDia/2,0,-C.HullHeight/2];    % position of hull wrt. origin,
                                
% -------------------


Hull=GridCylinder(C.HullDia/2,-C.HullHeight/2,C.HullHeight/2,8,[],6,[1,6,6,300],[1,6,6,300]);%nz,p,np,base,ceiling) 
Hull=GridMove(Hull,[0,0,pi/6]);
 
 % create wire and surface objects:
 

 
 n=1;
 while n<=length(Hull.Desc)
     if(norm(Hull.Geom(Hull.Desc(n,1),:)-Hull.Geom(Hull.Desc(n,2),:),'fro')>600)
         Hull=GridSplitSegs(Hull,n,[],[],[],2);
 
         
         n=0;
     end
     n=n+1;
 end

 Nnodes=length(Hull.Geom);
 for n=1:Nnodes
     rn=Hull.Geom(n,:);
     for m=(n+1):Nnodes
         rm=Hull.Geom(m,:);
         if abs(rn-rm)<300
                if norm(cross([rn(1:2),0],[rm(1:2),0]),'fro')<0.1
               %     Hull=AddSeg(Hull,n,m);
                end
         end % nahe zam
     end % for all other nodes
 end % for all nodes
 
 Hull=GridObj(Hull,'Wire','Hull','all',HullPropWire);
 Hull=GridObj(Hull,'Surf','Hull','all',HullPropSurf);
 Hull.Obj(1).forwire=1;
 Hull.Obj(1).forpat=0;
 Hull.Obj(2).forwire=0;
 Hull.Obj(2).forpat=1;
ant=GridJoin(ant,Hull);
 
% --------------------------------------------------------------------------------------------------------------------------------------------------
  
  % -----------------
  % solar panels
  % -----------------
    
 %   % graphical properties:
    
SolPropWire=WireProp;
SolPropSurf=SurfProp;
SolPropSurf.FaceColor=[0,0.2,0.8];
SolPropSurf.BackFaceLighting='reverselit';
SolConPointProp=struct('Marker','o','MarkerEdgeColor','b','MarkerFaceColor','b');
    
 %   % geometrical specifications:
         
% SolPos_1=[C.Panels.XAxis1,-C.HullY/2-C.Panels.Dist1,C.Panels.ZAxis1];  % position of +Y-panel axis/ panel 1
% SolPos_2=[C.Panels.XAxis2,C.HullY/2+C.Panels.Dist1,C.Panels.ZAxis2];  % position of +Y-panel axis/ panel2
    
% %   % -----------------
% 
     SolXNum=10;     % number of segments along long side
     SolYNum=6;       % number of segments along short side
  
   
   SolXSeg=C.Panels.Length/SolXNum;
   SolYSeg=C.Panels.Width/SolYNum;
   
 
   % generate surface of solar cells:
   
   Y=repmat((-SolYNum/2:SolYNum/2)*SolYSeg,SolXNum+1,1);
   X=repmat((0:SolXNum)'*SolXSeg,1,SolYNum+1);
   
   Sol_1=GridMatrix(X+C.Panels.RadialPos,Y,zeros(size(X))+C.HullHeight/2); 
   Sol_2=GridMatrix(X+C.Panels.RadialPos,Y,zeros(size(X))+C.HullHeight/2);
   Sol_3=GridMatrix(X+C.Panels.RadialPos,Y,zeros(size(X))+C.HullHeight/2);
   
 %   % move to final position:
   
   Sol_1=GridMove(Sol_1,[0,0,C.Panels.Angle1]);
   Sol_2=GridMove(Sol_2,[0,0,C.Panels.Angle2]);
   Sol_3=GridMove(Sol_3,[0,0,C.Panels.Angle3]);
   
   Sol_1=GridRemove(Sol_1,[],[12,23,45,56]);
   Sol_2=GridRemove(Sol_2,[],[12,23,45,56]);
   Sol_3=GridRemove(Sol_3,[],[12,23,45,56]);
   
   Sol_1=GridRemove(Sol_1,[],[],[-1,-29,-57]);
   Sol_2=GridRemove(Sol_2,[],[],[-1,-29,-57]);
   Sol_3=GridRemove(Sol_3,[],[],[-1,-29,-57]);
%   % join'em:
%   
   Sol=GridJoin(Sol_1,Sol_2);
   Sol=GridJoin(Sol,Sol_3);
   
%   % define wire and surface object:
   
   Sol=GridObj(Sol,'Wire','Solar Panels','all',SolPropWire);
   Sol=GridObj(Sol,'Surf','Solar Panels','all',SolPropSurf);
   Sol.Obj(1).forwire=1;
   Sol.Obj(1).forpat=0;
   Sol.Obj(2).forwire=0;
   Sol.Obj(2).forpat=1;
    
   ant=GridJoin(ant,Sol,[],'Solar Panels');
    
    % struts
    
    struts=GridInit;
    
    struts=GridObj(struts,'Wire','struts','all',WireProp);
    struts.Obj(1).forwire=1;
    struts.Obj(1).forpat=1;
    ant=GridJoin(ant,struts,[],'struts');
   % ant=AddSeg(ant,129,487);
    ant.Obj(length(ant.Obj)).Elem(1)=length(ant.Desc);
    %ant=AddSeg(ant,133,557);
    ant.Obj(length(ant.Obj)).Elem(2)=length(ant.Desc);
    %ant=AddSeg(ant,137,417);
    ant.Obj(length(ant.Obj)).Elem(3)=length(ant.Desc);
    
    % Connection 
    
    solcon=GridInit;
    
    solcon=GridObj(solcon,'Wire','solcon','all',WireProp);
    solcon.Obj(1).forwire=1;
    solcon.Obj(1).forpat=1;
    ant=GridJoin(ant,solcon,[],'struts');
    
    
%     %ant=AddSeg(ant,51,515);
%     ant.Obj(length(ant.Obj)).Elem(1)=length(ant.Desc);
%     %ant=AddSeg(ant,356,495);
%     ant.Obj(length(ant.Obj)).Elem(2)=length(ant.Desc);
%     %ant=AddSeg(ant,225,485);
%     ant.Obj(length(ant.Obj)).Elem(3)=length(ant.Desc);
%     %ant=AddSeg(ant,226,475);
%     ant.Obj(length(ant.Obj)).Elem(4)=length(ant.Desc);
%    % ant=AddSeg(ant,50,455);
%     ant.Obj(length(ant.Obj)).Elem(5)=length(ant.Desc);
%     
%    % ant=AddSeg(ant,54,385);
%     ant.Obj(length(ant.Obj)).Elem(6)=length(ant.Desc);
%   %  ant=AddSeg(ant,234,405);
%     ant.Obj(length(ant.Obj)).Elem(7)=length(ant.Desc);
%     ant=AddSeg(ant,233,415);
%     ant.Obj(length(ant.Obj)).Elem(8)=length(ant.Desc);
%     ant=AddSeg(ant,360,425);
%     ant.Obj(length(ant.Obj)).Elem(9)=length(ant.Desc);
%     ant=AddSeg(ant,49,445);
%     ant.Obj(length(ant.Obj)).Elem(10)=length(ant.Desc);
%     
%     ant=AddSeg(ant,52,525);
%     ant.Obj(length(ant.Obj)).Elem(11)=length(ant.Desc);
%     ant=AddSeg(ant,230,545);
%     ant.Obj(length(ant.Obj)).Elem(12)=length(ant.Desc);
%     ant=AddSeg(ant,229,555);
%     ant.Obj(length(ant.Obj)).Elem(13)=length(ant.Desc);
%     ant=AddSeg(ant,358,565);
%     ant.Obj(length(ant.Obj)).Elem(14)=length(ant.Desc);
%     ant=AddSeg(ant,53,585);
%     ant.Obj(length(ant.Obj)).Elem(15)=length(ant.Desc);
% -----------------------------------------------------------------------------------------------------------------------------------------
 
% ------------------
% WAVES antennas
% ------------------
 
 % graphical properties:
 
 AntPropWire=WireProp;
 AntPropWire.Color=[0,0,0];
 
 FeedPointProp=struct('Marker','o','MarkerEdgeColor','r','MarkerFaceColor','r');
 
% % geometrical specifications:
 
MonoLen=C.Antennae.Length;                 % length of monopole
MonoSegs=C.Antennae.Nsegs;                  % number of segments to be used for monopole
 
Mono1FeedPos=C.Antennae.FeedPos(1,:);    % position of monopole 1 feed
Mono2FeedPos=C.Antennae.FeedPos(2,:);    % position of monopole 2 feed
 
 % create and connect to hull:
 
 %direction of antenna
 
[z,y]=AntBend(MonoLen,0,MonoSegs);
x=zeros(size(z));

% setup rotation matrices

zeta=C.Antennae.Zeta(1);
xi=C.Antennae.Xi(1);

Monopole1=GridMove(GridMatrix(x,y,z),[-xi,0,0],[0,0,0]);            % azimuth
Monopole1=GridMove(Monopole1,[0,zeta,0],[0,0,0]);   % colatitude
 
zeta=C.Antennae.Zeta(2);
xi=C.Antennae.Xi(2);
Monopole2=GridMove(GridMatrix(x,y,z),[-xi,0,0],[0,0,0]);            % azimuth
Monopole2=GridMove(Monopole2,[0,zeta,0],[0,0,0]);   % colatitude

Monopole1=GridMove(Monopole1,[0,0,0],Mono1FeedPos); 
Monopole2=GridMove(Monopole2,[0,0,0],Mono2FeedPos); 

if(config==2)
    Monopole1=GridMove(Monopole1,[0,0,-60*deg],[0,0,0]);
    Monopole2=GridMove(Monopole2,[0,0,-60*deg],[0,0,0]);
end

 Monopole1=GridObj(Monopole1,'Wire','A1','all',AntPropWire);
 A1Object=length(ant.Obj);
 
 Monopole2=GridObj(Monopole2,'Wire','A2','all',AntPropWire);
 A2Object=length(ant.Obj);
 
 Monopole1.Obj(1).forwire=1;
 Monopole1.Obj(1).forpat=1;
 Monopole2.Obj(1).forwire=1;
 Monopole2.Obj(1).forpat=1;
 
 NearestPoint=GridNearest(ant.Geom,Monopole1.Geom);
 HullConMono1=NearestPoint(1);
 ant=GridJoin(ant,Monopole1,HullConMono1,1,[],'Con A1');
 ant.Obj(end).GraphProp=HullPropWire;
 A1ConObject=length(ant.Obj);
 ant.Obj(A1ConObject).forwire=1;
 ant.Obj(A1ConObject).forpat=1;
 
 NearestPoint=GridNearest(ant.Geom,Monopole2.Geom);
 HullConMono2=NearestPoint; 
 ant=GridJoin(ant,Monopole2,HullConMono2,1,[],'Con A2');
 ant.Obj(end).GraphProp=HullPropWire;
 A2ConObject=length(ant.Obj);
 ant.Obj(A2ConObject).forwire=1;
 ant.Obj(A2ConObject).forpat=1;
 
 % antenna properies for plotting
 
 ant.Antennae(1).Length=C.Antennae.Length;
 ant.Antennae(1).Zeta=C.Antennae.Zeta(1);
 ant.Antennae(1).Xi=C.Antennae.Xi(1);
 
 ant.Antennae(2).Length=C.Antennae.Length;
 ant.Antennae(2).Zeta=C.Antennae.Zeta(1);
 ant.Antennae(2).Xi=C.Antennae.Xi(1);

 
 n=[ant.Desc(ant.Obj(8).Elem,2),ant.Desc(ant.Obj(10).Elem,2)];         % <--- hier feed einstellen 

 ant=GridObj(ant,'Point','Feeds',n,FeedPointProp);
 FeedObject=length(ant.Obj);
 ant.Obj(FeedObject).forwire=1;
 ant.Obj(FeedObject).forpat=1;
 
  
 % concept feeds
 
 n=[ant.Obj(8).Elem,ant.Obj(10).Elem];                               % <--- hier seg-feed einstellen 
 
 ant=GridObj(ant,'Wire','SegFeeds',n,WireProp);
 SegFeedObject=length(ant.Obj);
 ant.Obj(SegFeedObject).forwire=1;
 ant.Obj(SegFeedObject).forpat=1;
 

%--------------------------------------------------------------------------------------------------------------------------------------------------------------
% 
% % ------------------
% % high gain antenna
% % ------------------
% 
% % graphical properties:
%   
%   HGAPropWire=WireProp;
%   HGAPropSurf=SurfProp;
%   HGAPropSurf.FaceColor=[0.7,0.7,0.7];
%   
%   % geometrical specifications:
%   
%   HGAinner=29.4*deg/2;        % inner half-opening angle 
%   HGAouter=83.1*deg/2;        % outer half-opening angle
%   
%   HGAParSegs=4;        % number of segments for parallels 
%   HGAMerSegs=3;         % number of segments for meridians
%     
%   
%   % -----------------
%   
%   HGA=GridSphere(C.HGA.Radius,HGAinner,HGAouter,HGAMerSegs,2*pi,HGAParSegs);
%   
%  % hga drehen und zurück in die mitte rücken
%  
%  
%    HGA=GridMove(HGA,[],C.HGA.Pos);
%  
%   HGA=GridObj(HGA,'Wire','HGA','all',HGAPropWire);
%   HGA=GridObj(HGA,'Surf','HGA','all',HGAPropSurf);
%   
%   %---------------------------------------------------------------------------------------------------------------------------------------
%   
%   % additional features of design 3
%   
%    mid=0.25*sum(HGA.Geom(1:4,:));
%    
%    HGA=AddSeg(HGA,1,mid-[0,0,490]);
%    HGA=AddSeg(HGA,2,length(HGA.Geom));
%    HGA=AddSeg(HGA,3,length(HGA.Geom));
%    HGA=AddSeg(HGA,4,length(HGA.Geom));
%   
%    HGA=AddSeg(HGA,1,mid+[0,0,204]);
%    HGA=AddSeg(HGA,3,length(HGA.Geom));
%   %-----------------------------------------------------------------------
%   
%   % Rotate HGA
%   
%   R=zeros(3);
%   t=zeros(3);
%   
%   R(:,3)=HGA.Geom(length(HGA.Geom),:);
%   t(:,3)=HGA.Geom(length(HGA.Geom),:);
%   
%   R(:,1)=[1,0,0];
%   t(:,1)=[cos(ang*pi/180) ,0,-sin(ang*pi/180)];
%   
%   R(:,2)=[0,0,1];
%   t(:,2)=[sin(ang*pi/180),0,cos(ang*pi/180)];
%   
%   HGA=GridMove(HGA,R,t,2);
%   
%   % Connection 
%   
%   ant=GridJoin(ant,HGA);
%   ant=GridSplitSegs(ant,213);
%   ant=AddSeg(ant,length(ant.Geom),length(ant.Geom)-1,2); 
% 
%   HGAObject=length(ant.Obj);
%   
% 
% % ------------------------------------------------------------------------
% % BOOM
% % ------------------------------------------------------------------------
% 
% 
%  BoomPropWire=WireProp;
%  BoomPropSurf=SurfProp;
%  BoomPropSurf.FaceColor=[0.7,0.7,0.7];
%    
% % change hull
% 
% [ant,AddN,AddS]=GridSplitSegs(ant,[199,313,319,325,331,337,271],0.5);
% ant=GridRemove(ant,[],[],[],[145,151,157,163,169,175]);
% ant=AddPat(ant,length(ant.Geom)-5,length(ant.Geom)-6,1,2);
% ant=AddPat(ant,length(ant.Geom)-4,length(ant.Geom)-5,2,3);
% ant=AddPat(ant,length(ant.Geom)-3,length(ant.Geom)-4,3,4);
% ant=AddPat(ant,length(ant.Geom)-2,length(ant.Geom)-3,4,5);
% ant=AddPat(ant,length(ant.Geom)-1,length(ant.Geom)-2,5,6);
% ant=AddPat(ant,length(ant.Geom),length(ant.Geom)-1,6,7);
% 
% firstrow=[(length(ant.Geom)-6):length(ant.Geom)];
% 
% ant.Obj(1).Elem=[ant.Obj(1).Elem AddS'];
% 
% NodesToMove = [length(ant.Geom)-6:length(ant.Geom)];
% ant.Geom(NodesToMove,2)=ant.Geom(NodesToMove,2)-150;
% 
% for(i=length(ant.Geom)-6:length(ant.Geom)-1)
%      ant=AddSeg(ant,i,i+1);
% end % for
%  
% ant.Obj(1).Elem=[ant.Obj(1).Elem (length(ant.Desc)-5):(length(ant.Desc))];
% 
% % % first boom segment
%  
% BeginOfBoom1=length(ant.Geom+1);
% ant=AddSeg(ant,length(ant.Geom)-6,ant.Geom(length(ant.Geom)-6,:)-[C.Boom.Length1,0,0],8);
% EndOfBoom1Nodes=length(ant.Geom);
% EndOfBoom1=length(ant.Geom);
% 
% BeginOfBoom2=length(ant.Geom+1);
% ant=AddSeg(ant,1,ant.Geom(1,:)-[C.Boom.Length1,0,0],8);
% EndOfBoom2Nodes=length(ant.Geom);
% EndOfBoom2=length(ant.Geom);
% 
% BeginOfBoom3=length(ant.Geom+1);
% ant=AddSeg(ant,99,ant.Geom(99,:)-[C.Boom.Length1,0,0],8);
% EndOfBoom3Nodes=length(ant.Geom);
% EndOfBoom3=length(ant.Geom);
% 
% N=EndOfBoom1Nodes-BeginOfBoom1;
% 
% for(i=1:N)
%    ant=AddSeg(ant,BeginOfBoom1+i,BeginOfBoom2+i);
%    ant=AddSeg(ant,BeginOfBoom2+i,BeginOfBoom3+i);
%    ant=AddSeg(ant,BeginOfBoom1+i,BeginOfBoom3+i);
% end %for all i
% 
% % part 2
% 
% vertex=(ant.Geom(BeginOfBoom1+1,:)+ant.Geom(BeginOfBoom2+1,:)+ant.Geom(BeginOfBoom3+1,:))./3-[300,0,0];
% 
% ant=AddSeg(ant,BeginOfBoom1+1,vertex);
% Index_v=size(ant.Geom);
% Index_v=Index_v(1);
% 
% ant=AddSeg(ant,BeginOfBoom2+1,Index_v);
% ant=AddSeg(ant,BeginOfBoom3+1,Index_v);
% 
% ant=AddSeg(ant,Index_v,vertex-[C.Boom.Length2,0,0],6);
% 

% -------------------------------
% finalize ant and save
% -------------------------------
 
% extract all objects and pack:
 
  ant=GridExtract(ant);
  ant=GridPack(ant,50,'all',[1,1]);

  % change scale mm->m:

 ant.Geom=ant.Geom/1e3;
 ant.Antennae(1).Length=ant.Antennae(1).Length/1e3;
 ant.Antennae(2).Length=ant.Antennae(2).Length/1e3;
 C.Antennae.FeedPos=C.Antennae.FeedPos/1e3;
 
%  % determine fields .Config, .Feed, .Load, .Wire:
%  
 ant.Config=C;
  
 FeedObj=GridFindObj(ant,'Name','Feeds');    
 ant.Feed=[ant.Obj(FeedObj).Elem];
 
 SegFeedObj=GridFindObj(ant,'Name','SegFeeds');    
 ant.SegFeeds=[ant.Obj(SegFeedObj).Elem];
 
 ant.Wire=C.Antennae.Wire;
 
 % define feeds as object: -------------
  
 [ant.Obj.Prop]=deal(struct('Radius',C.Wire(1),'Cond',C.Wire(2)));
 AntObj=[...
   GridFindObj(ant,'Name','A1'),...
   GridFindObj(ant,'Name','A2')];
 [ant.Obj(AntObj).Prop]=deal(struct('Radius',C.Antennae.Wire(1),'Cond',C.Antennae.Wire(2)));
 ant.Antennae(1).Obj=AntObj(1);
  ant.Antennae(2).Obj=AntObj(2);
% 
% 
% % save ant in GridFile:
% 
% filnam=strcat('..\JunoData\antJunoConfig',num2str(config),'.mat');
% %save(filnam,'ant');

% ------------
% plots
% ------------

h=[];

hold on;
PlotGrid(ant,'all',[],'all','all');
axis equal;
set(gcf,'renderer','opengl');

titl=strcat('Juno 2');
title(titl);

xlabel('X-Axis');
ylabel('Y-Axis');
zlabel('Z-Axis');

% set antenna radii
%ant=SetWireRadii(ant,(25.4/2)/1000);
ant=SetWireRadii(ant,2/1000);
ant=SetWiretype(ant);
return