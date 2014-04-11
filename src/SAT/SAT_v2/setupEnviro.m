% setupEnviro sets up the environment for an antenna calculation

global f;
global solver;
global ca;     
global baseCaps;
global force;
global forcegain;
global forcegridcreate;
global patches;
global er;
global rad

f=3e5;                   % frequency
solver='CONCEPT';
ca=0;                    % include capacitances ?
force=1;                 % force calculation
forcegain=0;             % force gain calculation 
forcegridcreate=0;       % create the grid ?
patches=0;  
er=[0,0,1];              % direction of the incident radiation
baseCaps=70e-12;         % base capacitances
rad=pi/180;

% plasma 

global f_pe;
global epsilonr;

f_pe=1e5;                % plasma electron frequency
epsilonr=1;              % relative permittivity
% global epsilonr=1-(f_pe/f)^2;

% solver

global concurrent;                 
global asapexe;
global nec2bin;

concurrent=0;                   % concurrent computation ?
asapexe='/home/tho/bin/asap2d.bin';
nec2bin='nec2++';

% setup file structure

global CurrentFile;
global GainFile;
global baseDir;
global solvDir;

baseDir='/home/tho/src/Wiregrid/work/L-Depp/';
cd(baseDir);

switch(solver)
    case 'ASAP' 
        CurrentFile='ASAPCurrents.mat';
        GainFile='ASAPGain.mat';
        solvDir='asap';
    case 'CONCEPT'
        if(patches)
            CurrentFile='CurrentsPatches.mat';
            GainFile='GainPatches.mat';
            solvDir='concept_pat';
        else
            CurrentFile='Currents.mat';
            GainFile='Gain.mat';
            solvDir='concept';
        end % else
    case 'NEC2'
        CurrentFile='NEC2Currents.mat';
        GainFile='NEC2Gain.mat';
        solvDir='nec2';
    case 'NEC4'
        CurrentFile='NEC4Currents.mat';
        GainFile='NEC4Gain.mat';
        solvDir='nec4';
end % switch