
% create and save plots containing various views of PhysGrid
% and the respective effective axes
% ==========================================================


% parameters:
% -----------

% close all
% clear all

LoadPath='Feko';  % where PhysGrid is to be expected
% 
% SavePath=fullfile(LoadPath,'');  % where plots are saved
% 
% FileName='Gridheff';  % name of plot files (apart of indicator and extension)
% 


% load PhysGrid, and generate plot directory if not existent
% ----------------------------------------------------------

AttaInit;

% if ~exist(SavePath,'dir')
%   succ=mkdir(SavePath);
%   if ~succ,
%     error(['Could not create directory ',SavePath]);
%   end
% end

load(fullfile(LoadPath,'PhysGrid'));


% set graphic properties:
% -------------------------

[Points,Wires,Surfs]=FindGridObj(PhysGrid);
for w=Wires(:).',
  PhysGrid.Obj(w).Graf.LineWidth=LineWidth;
end
for su=Surfs(:).',
  PhysGrid.Obj(su).Graf.LineWidth=EdgeWidth;
  PhysGrid.Obj(su).Graf.EdgeColor=EdgeColor;
end

a=[FindGridObj(PhysGrid,'Name','antenna 1'),...
   FindGridObj(PhysGrid,'Name','antenna 2'),...
   FindGridObj(PhysGrid,'Name','antenna 3')];

for aa=a(:).',
  PhysGrid.Obj(aa).Graf.Linewidth=aLinewidth;
  PhysGrid.Obj(aa).Graf.Color=aLinecolor;
end
% 

% find the feed positions and coordinates
% ----------------------------------------

f=FindGridObj(PhysGrid,'Name','Feeds');

PhysGrid.Obj(f).Graf.Linewidth=fLinewidth;
PhysGrid.Obj(f).Graf.Color=fLinecolor;


FeedSeg=PhysGrid.Obj(f).Elem;

FeedPos=(PhysGrid.Geom(PhysGrid.Desc(FeedSeg,1),:)+...
         PhysGrid.Geom(PhysGrid.Desc(FeedSeg,2),:))/2;
       

% load transfer matrix and determine heff
% ----------------------------------------

Freq=300e3;
Solver='Concept';
DataRootDir='';

[T,er,Z] = LoadT(DataRootDir,Solver,Freq,'To.mat');

% capacitance matrix
Ca = inv(Z)./(j*2*pi*Freq);

% effective antenna vectors
heff = real(mean(T,3));

heff_sph = car2sph(heff,2);
heff_sph_d = [heff_sph(:,1),heff_sph(:,2:3)*180/pi];

% oblique view:
% -------------

if ishandle(4), close(4), end
figure(4);

set(gcf,'renderer',Renderer);
set(gcf,'papertype','a4');

PlotGrid(PhysGrid,'')

% set(gcf,'position',([80 300 1150 450]));
% 
% set(gca,'outerposition',([-0.1 -0.05 1.18 1.18]));
% set(gca,'position',([0.08 0.08 0.88 0.88]));

% set(gcf,'colormap','grayscale')

axis equal;
hold on;
grid on;

hA=line([FeedPos(1:2,1).'; FeedPos(1:2,1).'+heff(1:2,1).'],...
        [FeedPos(1:2,2).'; FeedPos(1:2,2).'+heff(1:2,2).'],...
        [FeedPos(1:2,3).'; FeedPos(1:2,3).'+heff(1:2,3).'],...    
    hAStyle{:});

xlim([-4 3]);  xlabel('+X Axis [m]');
ylim([-10 6]);  ylabel('+Y Axis [m]');
zlim([-3 2]);   zlabel('+Z Axis [m]');
% 
view([60 10]);                           % camera azimuth,elevation

% fil=[fullfile(SavePath,FileName),'_o'];
%    
% for dd=Drivers(:).',
%   print(dd{1},Resolution,fil)
% end

% view from -X:
% -------------

if ishandle(1), close(1), end
figure(1);
set(gcf,'renderer',Renderer);

PlotGrid(PhysGrid,'')

hA=line([FeedPos(1:2,1).'; FeedPos(1:2,1).'+heff(1:2,1).'],...
        [FeedPos(1:2,2).'; FeedPos(1:2,2).'+heff(1:2,2).'],...
        [FeedPos(1:2,3).'; FeedPos(1:2,3).'+heff(1:2,3).'],...    
    hAStyle{:});

axis equal;
hold on;
grid on;

% xlim([-7 7]);  xlabel('+X Axis [m]');
ylim([-10 10]);  ylabel('+Y Axis [m]');
zlim([-2.5 2.5]);   zlabel('+Z Axis [m]');

% set(gcf,'papertype','a4');
% set(gcf,'position',([80 300 1150 350]));
% 
% set(gca,'units','pixels','outerposition',([-115 -4 1360 368]));
% set(gca,'units','pixels','position',([58 36 1060 300]));

view([90 0]);    

% fil=[fullfile(SavePath,FileName),'_x'];
% 
% for dd=Drivers(:).',
%   print(dd{1},Resolution,fil)
% end

% view from -Y:
% -------------

% view([0 0]);    

% fil=[fullfile(SavePath,FileName),'_y'];
% 
% for dd=Drivers(:).',
%   print(dd{1},Resolution,fil)
% end


% view from Z:
% -------------

if ishandle(3), close(3), end
figure(3);
set(gcf,'renderer',Renderer);

PlotGrid(PhysGrid,'')

hA=line([FeedPos(1:2,1).'; FeedPos(1:2,1).'+heff(1:2,1).'],...
        [FeedPos(1:2,2).'; FeedPos(1:2,2).'+heff(1:2,2).'],...
        [FeedPos(1:2,3).'; FeedPos(1:2,3).'+heff(1:2,3).'],...    
    hAStyle{:});

axis equal;
hold on;
grid on;

view([0 0]);      

xlim([-7 12]);  xlabel('+X Axis [m]');
ylim([-10 10]);  ylabel('+Y Axis [m]');
zlim([-2.5 2.5]);   zlabel('+Z Axis [m]');
% 
% set(gcf,'papertype','a4');
% set(gcf,'position',([80 80 800 800]));
% 
% set(gca,'units','pixels','outerposition',([-50 -30 950 850]));
% set(gca,'units','pixels','position',([54 58 770 702]));
    
% fil=[fullfile(SavePath,FileName),'_z'];
% 
% for dd=Drivers(:).',
%   print(dd{1},Resolution,fil)
% end


