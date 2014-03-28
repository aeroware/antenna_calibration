% *************************************************************************
% 0.00 - 00.00.0000:  
% 
% dependend on ant struct
% 
% *************************************************************************
% determine values
% *************************************************************************

% clear all
% close all
% clc
                           
% initialize model grid
ant = GridInit();
AttaInit;   % toolbox initialization for global variables

WorkingDir= pwd;

%------------------------------------------------------------------------
% MODEL GENERATION

load('ant.mat');

%------------------------------------------------------------------------

Freqs = [20.5 21.5 22 22.5 23 23.5 24 24.5 25.5 26 26.5 27 27.5 28 28.5 ...
    29 29.5]*1e6;


% directions
er = [1,0,0;0,1,0;0,0,1;-1,0,0;0,-1,0;0,0,-1;...
      1,1,1;-1,1,1;1,-1,1;1,1,-1;-1,-1,1;-1,1,-1;1,-1,-1;-1,-1,-1];

% calculate:
Solver='Concept';
WireOption={};            % {}=keep patches
FarFieldCalc='Solver';
Titel = 'JUNO_nas_mesh_V1 - V1 mesh';

% PhysGrid=GetPhysGrid(ant,Solver,WireOption,WorkingDir);
% Concept_CreateIn(PhysGrid,Freqs,FeedNum,Titel,WorkingDir)

% CalcAnt(PhysGrid,WorkingDir,Solver,Freqs,er,Titel,WireOption,FarFieldCalc);

CalcAnt(ant,WorkingDir,'Concept',Freqs,er,Titel,WireOption,FarFieldCalc);
CalcAnt(ant,WorkingDir,'Feko',Freqs,er,Titel,WireOption,FarFieldCalc);
