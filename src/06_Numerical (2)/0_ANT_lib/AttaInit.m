
function AttaInit

% AttaInit initialized ATTA (Antenna Toolbox for Transfer Matrix
% Applications). It has to be called before working with the toolbox
% routines.


% ASAP parameters:
% ----------------

global Atta_Asap_Exe Atta_Asap_Inexe Atta_Asap_Outexe 
global Atta_Asap_In Atta_Asap_Out 

% Asap executable:

Atta_Asap_Exe='asap3g.exe';

% Asap input and output files used by Asap executable:

Atta_Asap_Inexe='asapin.dat';
Atta_Asap_Outexe='asapout.dat';

% Asap input and output files used by toolbox:

Atta_Asap_In='asap.in';
Atta_Asap_Out='asap.out';


% CONCEPT parameters:
% ----------------

global Atta_Concept_FE Atta_Concept_BG Atta_Concept_BE
global Atta_Concept_In Atta_Concept_Out Atta_Concept_Ili Atta_Concept_Ifl
global Atta_Concept_Surf0 Atta_Concept_Wire1 Atta_Concept_Surf1 
global Atta_Concept_EHIn Atta_Concept_EHOut Atta_Concept_EHExe
global Atta_Concept_EOutasc Atta_Concept_HOutasc Atta_Concept_EHOutasc
global Atta_Concept_DelEHFiles 

% Concept executables:

Atta_Concept_FE='concept.fe.exe';   % concept front end
Atta_Concept_BG='buildgeo.exe';     % concept geometry builder
Atta_Concept_BE='concept.be.exe';   % concept back end

% Concept input and output files:

Atta_Concept_In='concept.in';
Atta_Concept_Wire1='wire.1';
Atta_Concept_Surf1='surf.1';
Atta_Concept_Out='concept.out';
Atta_Concept_Ili='co_ili.bin';
Atta_Concept_Ifl='co_ifl.bin';
Atta_Concept_EHIn='eh1d.in';
Atta_Concept_EHOut='eh1d.out';
Atta_Concept_EHExe='eh1d.exe';
Atta_Concept_Surf0='surf.0';
Atta_Concept_EOutasc='co_edat.asc';
Atta_Concept_HOutasc='co_hdat.asc';

% etc.

Atta_Concept_EHOutasc=1; 
% if co_?dat.asc file shall be read instead of eh1d.out to get E or H

Atta_Concept_DelEHFiles=1; 
% if EH files shall be deleted after field calculations


% Feko parameters:
% ----------------

global Atta_PreFeko Atta_Feko;
global Atta_Feko_Pre Atta_Feko_Fek Atta_Feko_Bot;
global Atta_Feko_Out Atta_Feko_Os Atta_Feko_Of;

% Feko executables:

Atta_PreFeko='prefeko.exe';   % prefeko
Atta_Feko='feko.exe';     % feko

% Feko input and output files:

Atta_Feko_Pre='antfile.pre';
Atta_Feko_Fek='antfile.fek';
Atta_Feko_Bot='antfile.bot';
Atta_Feko_Out='antfile.out';
Atta_Feko_Os='antfile.os';
Atta_Feko_Of='antfile.of';

% NEC4 parameters:
% ----------------

global Atta_Nec;
global Atta_Nec_In Atta_Nec_Out;

% Feko executables:

Atta_Nec='nec4d_g95.exe';     % nec4

% Nec input and output files:

Atta_Nec_In='nec.in';
Atta_Nec_Out='nec.out';




% Directory, file and variable names, etc.:
% -----------------------------------------

global Atta_SolverDirFormat Atta_FreqDirFormat Atta_FeedDirFormat
global Atta_FeedDirAlldriven Atta_PhysGridFile Atta_TransferFile
global Atta_PhysGridName Atta_TsFileName Atta_ToFileName
global Atta_CalcAnt_Recalc

Atta_SolverDirFormat='%s';
Atta_FreqDirFormat='kHz_%06.0f';
Atta_FeedDirFormat='Feed_%d';
Atta_FeedDirAlldriven='Feed_alldriven';

Atta_PhysGridFile='PhysGrid';
Atta_TransferFile='Transfer';

Atta_PhysGridName='PhysGrid';

% set the following variables =[] to prevent auto-saving at calculation:
Atta_TsFileName=''; % save Ts and Y in this file when calculated by CalcTs
Atta_ToFileName='To'; % save To and Z in this file when calculated by CalcTo

Atta_CalcAnt_Recalc={'Curr','To'}; 
% Signify if 'Curr' or 'To' shall be recalculated by CalcAnt even if already 
% present, e.g. Atta_CalcAnt_Recalc={'To'} does calculate only those currents 
% which were not yet calculated, but always calculates To anew; 
% Atta_CalcAnt_Recalc={} recalculates only what is not yet present.


% Solver names (must be different, the solver-id is simply the index number):
% -------------------------------------------------------------------------

global Atta_Solver_Names 

Atta_Solver_Names={'Asap','Concept','Static','Feko', 'Nec'};

