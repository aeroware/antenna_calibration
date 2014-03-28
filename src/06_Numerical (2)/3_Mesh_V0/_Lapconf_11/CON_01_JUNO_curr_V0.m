% *************************************************************************
% 0.00 - 00.00.0000:  
% 
% dependend on ant struct
% 
% *************************************************************************
% determine values
% *************************************************************************

clear all
close all
clc
                           
% initialize model grid
ant = GridInit();
AttaInit;   % toolbox initialization for global variables

WorkingDir= pwd;

%------------------------------------------------------------------------
% MODEL GENERATION

load('LAPCONF_nas_mesh.mat');

Freqs = [300]*1e3;

% directions
er = [1,0,0;0,1,0;0,0,1;-1,0,0;0,-1,0;0,0,-1;...
      1,1,1;-1,1,1;1,-1,1;1,1,-1;-1,-1,1;-1,1,-1;1,-1,-1;-1,-1,-1];

WireOption={};            % {}=keep patches  
FarFieldCalc='Solver';

%------------------------------------------------------------------------
% calculate:
Solver='Concept';
Titel = 'Concept 300 kHz - JUNO_nas_mesh_V0';

CalcAnt(ant,WorkingDir,Solver,Freqs,er,Titel,WireOption,FarFieldCalc);

% PhysGrid=GetPhysGrid(ant,Solver,WireOption,WorkingDir);
% Concept_CreateIn(PhysGrid,Freqs,FeedNum,Titel,WorkingDir)

% CalcAnt(PhysGrid,WorkingDir,Solver,Freqs,er,Titel,WireOption,FarFieldCalc);

