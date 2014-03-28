
% create matrices containing the coordinates of the
% effective axes
% ==========================================================


% parameters:
% -----------

% close all
clear all

LoadPath='Feko';  % where PhysGrid is to be expected

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




[Points,Wires,Surfs]=FindGridObj(PhysGrid);


a=[FindGridObj(PhysGrid,'Name','antenna 1'),...
   FindGridObj(PhysGrid,'Name','antenna 2')];
 

% find the feed positions and coordinates
% ----------------------------------------

f=FindGridObj(PhysGrid,'Name','Feeds');


FeedSeg=PhysGrid.Obj(f).Elem;

FeedPos=(PhysGrid.Geom(PhysGrid.Desc(FeedSeg,1),:)+...
         PhysGrid.Geom(PhysGrid.Desc(FeedSeg,2),:))/2;
       

% load transfer matrix and determine heff
% ----------------------------------------

Freq = 3e5;

Solver='Feko';
DataRootDir='';

[T,er,Z] = LoadT(DataRootDir,Solver,Freq,'To.mat');

% capacitance matrix

Ca = inv(Z)./(j*2*pi*Freq)

% effective antenna vectors
heff = real(mean(T,3));

heff_sph = car2sph(heff,2);
heff_sph_d = [heff_sph(:,1),heff_sph(:,2:3)*180/pi];

fprintf('A1: length= %.2fm theta= %.2f° phi= %.2f°\n',...
    heff_sph_d(1,1),heff_sph_d(1,2),heff_sph_d(1,3))
fprintf('A2: length= %.2fm theta= %.2f° phi= %.2f°\n',...
    heff_sph_d(2,1),heff_sph_d(2,2),heff_sph_d(2,3))
