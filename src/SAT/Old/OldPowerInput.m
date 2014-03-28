
function P=PowerInput(Geom,Desc,Curr,Feed)

% PowerInput(Geom,Desc,Curr,Feed) calculates the total power 
% input to the antenna at the given Feed(s).

if length(Feed)==1,
  Feed=[Feed,1,0];
end

s=FindSegs(Desc,Feed(:,1),1);
I=Curr(s,1).*(s>0)+Curr(s,2).*(s<0);

V=Feed(:,2).*exp(i*Feed(:,3)*pi/180);

P=real(I' * V)/2;
