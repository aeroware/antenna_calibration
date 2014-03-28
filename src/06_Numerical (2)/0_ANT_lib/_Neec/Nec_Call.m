
function [ResultFE,ResultBG,ResultBE]=Nec_Call(WorkingDir)

% Nec_Call(WorkingDir) calls nec,


global Atta_Nec;
global Atta_Nec_In Atta_Nec_Out;

% redirection file for keyboard input to concept front end:

% -------------------------------------------------------------------------

NecKeyIn='NecKeyinput.dat'; 

Atta_Nec_In ='nec.in'; 
Atta_Nec_Out ='nec.out'; 

% change to working directory if required:

if ~exist('WorkingDir','var')||isempty(WorkingDir),
  WorkingDir='';
end

if ~isempty(WorkingDir),
  SaveDir=pwd;
  try
    cd(WorkingDir);
  catch
    error(['Cannot change to working directory "',WorkingDir,'".']);
  end
end

% call front end:

Message='Calling Nec... ';
fprintf(Message);

% -------------------------------------------------------------------------

fd=fopen(NecKeyIn,'w+');
fprintf(fd,'%s\n%s\n',Atta_Nec_In,Atta_Nec_Out);
fclose(fd);

%   [Status,ResultFE]=dos([Atta_Concept_FE,' < ',ConceptfeKeyIn]);    
  [Status,ResultFE]=dos([Atta_Nec,' xxx ',Atta_Nec_In,' ', Atta_Nec_Out]);
% -------------------------------------------------------------------------    

if Status~=0
  fprintf('failed.\n');
  error([ResultFE,'.']);
else
  fprintf(repmat('\b',1,length(Message)));
end

% go back to original directory:

if ~isempty(WorkingDir),
  cd(SaveDir);
end
