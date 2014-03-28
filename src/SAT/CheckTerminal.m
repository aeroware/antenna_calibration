
function [TC,TA]=CheckTerminal(Desc,T);

% [TC,TA]=CheckTerminal(Desc,T)
% Checks an array of terminals given in T, where each terminal 
% is represented by a complex number, Node+i*Segm, which 
% gives the node and/or the segment between which the feed/load 
% is situated, thereby defining the positive pole on the side 
% of the segment, the negative pole on the node. 
% If only the node is given (real number), two segments must meet 
% at this node, one segment starting and one ending at the node.
% If only the segment is given (imaginary number), the terminal 
% is at the start node or end node of the segment according to  
% the sign of the given value, e.g. -5*i defines a terminal at
% the end node of segment 5. 
% The function calculates the segment or node, whichever is missing,
% and returns in TC the complete terminal description. If both, 
% segment and node, are given for a terminal in T, the function just 
% changes the sign of the segment, if necessary, according to the 
% above definition.
% Each terminal of T which is not valid or ambiguous is set to 0 in 
% TC. TA returnes the possible terminal definitions that can be used
% with ASAP: non-zero real parts give nodes which can be used for 
% FEED/LOAD definitions, non-zero imaginary parts (always positive) 
% are segment numbers which can be used for GENE/IMPE definitions.

TC=zeros(size(T));
TA=TC;

if isempty(T), 
  return
end

T(find(abs(imag(T))>size(Desc,1)))=0;

% nodes -> segments:

n=find(real(T)~=0 & imag(T)==0);
for k=1:length(n),
  s=FindSegs(Desc,T(n(k)),inf); 
  if length(s)==2,
    if s(1)<0 & s(2)>0,
      TC(n(k))=T(n(k))+i*s(2);
    end
    if s(1)>0 & s(2)<0,
      TC(n(k))=T(n(k))+i*s(1);
    end
    TA(n(k))=TC(n(k));
  end
end
 
% segments -> nodes:
 
n=find((real(T)==0) & (imag(T)~=0));
for k=1:length(n),
  seg=imag(T(n(k)));
  nod=Desc(abs(seg),1+(seg<0));
  s=FindSegs(Desc,nod,inf);
  if length(s)>1,
    TC(n(k))=nod+i*seg;
    if seg>0,
      TA(n(k))=i*seg;
      if length(s)==2,
        if s(1)*s(2)<0,
          TA(n(k))=nod+i*seg;
        end
      end
    end
  end
end

% nodes, segments -> nodes, +-segments

n=find((real(T)~=0) & (imag(T)~=0));
for k=1:length(n),
  nod=real(T(n(k)));
  seg=imag(T(n(k)));
  s=FindSegs(Desc,nod,inf);
  q=find(abs(s)==abs(seg));
  if ~isempty(q) & (length(s)>1),
    seg=s(q);
    TC(n(k))=nod+i*seg;
    if seg>0,
      TA(n(k))=i*seg;
      if length(s)==2,
        if s(1)*s(2)<0,
          TA(n(k))=nod+i*seg;
        end
      end
    end
  end
end
 
