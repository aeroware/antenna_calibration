
function Asap_Call(WorkingDir)

% [Status,Result]=Asap_Call(WorkingDir)
% calls Asap in the given WorkingDir, using the Asap input file name 
% which is defined in the global variable Atta_Asap_In and outputs 
% the result to the file defined in Atta_Asap_Out. The Asap executable
% is Atta_Asap_Exe. If it is not find in the current directory, the
% Matlab search path is searched for this file.

global Atta_Asap_Exe Atta_Asap_In Atta_Asap_Out Atta_Asap_Inexe Atta_Asap_Outexe

% Determine Asap executable:

AsapExe=Atta_Asap_Exe; 

if isempty(AsapExe),
  error('No ASAP executable (file name) defined, set the global variable Atta_Asap_Exe.');
end

if isempty(dir(AsapExe)),
  d=FindOnPath(AsapExe);
  if isempty(d),
    error(['''',AsapExe,...
      ''' not found in current directory nor on MATLAB search path.']);
  end
  AsapExe=fullfile(d{1},AsapExe);
  if isempty(dir(AsapExe)),
    error(['Error locating Asap executable ''',AsapExe,'''']);
  end
end

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

% call ASAP:

Message='Asap calculations running ... ';

if ~isequal(upper(Atta_Asap_Inexe),upper(Atta_Asap_In)),
  copyfile(Atta_Asap_In,Atta_Asap_Inexe);
end

fprintf(Message);
[Status,Result]=dos(AsapExe);
  if Status~=0,
    fprintf('failed.\n');
    error([Result,'.']);
  else
    fprintf(repmat('\b',1,length(Message)));
  end

if ~isequal(upper(Atta_Asap_Outexe),upper(Atta_Asap_Out)),
  copyfile(Atta_Asap_Outexe,Atta_Asap_Out);
  delete(Atta_Asap_Outexe);
end

if ~isequal(upper(Atta_Asap_Inexe),upper(Atta_Asap_In)),
  delete(Atta_Asap_Inexe);
end

% go back to original directory:

if ~isempty(WorkingDir),
  cd(SaveDir);
end
