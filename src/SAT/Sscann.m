
function [N,A]=Sscann(S,AsapFormat);
 
% [N,A]=Sscann(S,AsapFormat) splits the string S into several
% parts, which are returned in A and N, where A is a cell
% array containing the alpha- or non-numeric parts and 
% N is a vector containing the numbers found in S.
% If S starts with a number, A{1} is set to '' (empty
% string); similarly if S ends with a number, A(end)='';
% so length(A)=length(N)+1, and S is decomposed into A  
% and N in this way: A{1},N(1),...,A(nn),N(nn),A(nn+1), 
% where nn=length(N) is the number of numeric values found.
% Set the optional argument AsapFormat=1 in order to read 
% ASAP-formatted numbers, i.e. K, M and U can be used 
% as Kilo-, Mega- and Micro-postfix, respectively.

N=[];
A={};

AA=S;  % dummy for A{end}
k=0;   % length of AA-content
p=1;   % pointer into S

while p<=length(S),
  if any(S(p)=='+-.0123456789'),
    [q,c,e,pp]=sscanf(S(p:end),'%f',1);
    if isempty(q),
      k=k+1;
      AA(k)=S(p);
      p=p+1;
    else
      N(end+1)=q;
      A{end+1}=AA(1:k);
      k=0;
      p=p+pp-1;
    end
  else 
    k=k+1;
    AA(k)=S(p);
    p=p+1;
  end
end

A{end+1}=AA(1:k);

% take into account ASAP-formatted numbers:

if nargin>1,
  if isequal(AsapFormat,1),
    for p=1:length(N),
      pp=p+1;
      c=A{pp}(1:min(1,end));
      switch upper(c),
      case 'K',
        N(p)=N(p)*1e3;
        A{pp}=A{pp}(2:end);
      case 'M',
        N(p)=N(p)/1e3;
        A{pp}=A{pp}(2:end);
      case 'U',
        N(p)=N(p)/1e6;
        A{pp}=A{pp}(2:end);
      end 
    end
  end
end

        
  
