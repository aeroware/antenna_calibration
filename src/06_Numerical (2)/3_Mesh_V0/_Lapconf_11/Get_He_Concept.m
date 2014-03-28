% *************************************************************************
% 0.50 - 27.05.2011:  
% 
% determines He from concept To.mat 
% 
% *************************************************************************

clear all

AttaInit;

LoadPath='Concept';  % where PhysGrid is to be expected
load(fullfile(LoadPath,'PhysGrid'));

Freq=300e3;
Solver='Concept';
DataRootDir='';

% load transfer matrix and determine heff
% ----------------------------------------

[T,er,Z] = LoadT(DataRootDir,Solver,Freq,'To.mat');

% capacitance matrix
Ca = inv(Z)./(j*2*pi*Freq);

% effective antenna vectors
heff = real(mean(T,3));

heff_sph = car2sph(heff,2);
heff_sph_d = [heff_sph(:,1),heff_sph(:,2:3)*180/pi]

save('he_Concept_300kHz.mat');
