
function result = NecCall()

%   function result = NecCall() calls nec2++. There are
%   no input parameters and the only output parameter is result which holds
%   a value that indicates whether the calculation was successful.
 
  
  fprintf('Calling neclauncher... ');
  
  
 [Status,Result]=unix('neclauncher 3 3');
  if Status ~=0
      fprintf('failed\n');
  else
      fprintf('done\n');
  end
 
  result=Status;
 
  

