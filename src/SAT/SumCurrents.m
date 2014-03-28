
function S=SumCurrents(Desc,Curr);

s=FindSegs(Desc);

S=zeros(length(s),1);

for m=1:length(s),
  sm=s{m}(:);
  S(m)=sum(sign(sm).*Curr(sub2ind(size(Curr),abs(sm),1+(sm<0))));
end
