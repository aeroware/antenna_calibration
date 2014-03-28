
function q=CheckKirchhoff(Desc,Curr)

% q=CheckKirchhoff(Desc,Curr)
% Check Kirchhoff Law by calculating the sum q of the currents on all nodes.
% Curr contains the segment-end currents as required for ASAP, Desc the 
% segment definition.

ss=FindSegs(Desc,'a'); 
q=[];

for n=1:length(ss),
  q(n)=sum(sign(ss{n}).*Curr(sub2ind(size(Curr),abs(ss{n}),(ss{n}>0)+2*(ss{n}<0))));
end
