
function result = ConceptCallConcurrent(nAnts)

%   function result = ConceptCallConcurrent() calls the ceclauncher of the
%   concept software package to perform the current calculation. There are
%   no input parameters and the only output parameter is result which holds
%   a value that indicates whether the calculation was successful. Since
%   the program concept.fe.exe needs some input to be executed, an
%   indirection file is created and used instead of the manual input via
%   keyboard.
%
%   Revision 12.2010... variable number of antennas
 
  
  
  
   fprintf('Calling neclauncher... ');
  [Status,Result]=unix(sprintf('neclauncher 2 %d',nAnts));
  
  if Status ~=0
      error('failed\n');
  else
      fprintf('done\n');
  end
 
  result=Status;
 
  

