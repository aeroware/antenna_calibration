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

load('testcube.mat');

%------------------------------------------------------------------------

Freqs = [1 5]*1e6;

% directions
er = [1,0,0;0,1,0;0,0,1;-1,0,0;0,-1,0;0,0,-1;...
      1,1,1;-1,1,1;1,-1,1;1,1,-1;-1,-1,1;-1,1,-1;1,-1,-1;-1,-1,-1];

% calculate:
Solver='Nec';
WireOption={};            % {}=keep patches
FarFieldCalc='Solver';
Titel = 'Testcube - V0 mesh';

% PhysGrid=GetPhysGrid(ant,Solver,WireOption,WorkingDir);
% Concept_CreateIn(PhysGrid,Freqs,FeedNum,Titel,WorkingDir)

% CalcAnt(PhysGrid,WorkingDir,Solver,Freqs,er,Titel,WireOption,FarFieldCalc);

CalcAnt(ant,WorkingDir,Solver,Freqs,er,Titel,WireOption,FarFieldCalc);
%CalcAnt(ant,WorkingDir,'Concept',Freqs,er,Titel,WireOption,FarFieldCalc);
%CalcAnt(ant,WorkingDir,'Feko',Freqs,er,Titel,WireOption,FarFieldCalc);