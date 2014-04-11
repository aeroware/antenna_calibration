
function g=Gather(c)

% g=Gather(c) gathers (collects) all numbers found in c and
% arranges it in one column vector. c may be a cell array of
% cell arrays and double arrays. The arrangement of numbers
% is found by recursively expanding cell arrays into column 
% cell vectors (e.g. the outermost is expamded by c{:}), and 
% double arrays into column vectors using (:).
% For instance, g=Gather({3:5,(4:7)',{1,10;[5;7],0}}) yields
% g=[3;4;5;4;5;6;7;1;5;7;10;0].

if iscell(c),

  for n=1:prod(size(c));
    c{n}=Gather(c{n});
  end
  
  g=cat(1,c{:});

else
  
  g=c(:);
  
end

