
function NewInd=MapComp(NewInd1,NewInd2);

% NewInd=MapComp(NewInd1,NewInd2) calculate NewInd2 o NewInd1,
% i.e. the composition of two index maps. Signs are respected: 
% the sign of the final indices is the product of the signs of 
% the corresponding composed indices. 
% See also MapInd.

n=find(NewInd1&(abs(NewInd1)<=length(NewInd2)));

NewInd=zeros(size(NewInd1));

NewInd(n)=NewInd2(abs(NewInd1(n)));

m=find(NewInd1<0);
NewInd(m)=-NewInd(m);
