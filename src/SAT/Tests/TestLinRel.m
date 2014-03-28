
% TestLinRel.m

Y=rand(3,3,7,5);
s=size(Y);
Z=Y;
for k=1:prod(s(3:end)),
  Z(:,:,k)=inv(Y(:,:,k));
end

d=LinRel(LinRel(Y,1,[3,2]),[1],[],[3,2],[3])-Y([1],[2,3,1],:,:);
max(d(:))

d=LinRel(LinRel(Y,1,[3,2]),[3,2],[3],[1],[1,2])./Z([2,3,1],:,:,:)-1;
max(d(:))

Y=rand(4,4,7,50);
s=size(Y);
Z=Y;
for k=1:prod(s(3:end)),
  Z(:,:,k)=inv(Y(:,:,k));
end

d=LinRel(LinRel(Y,[1,3],[3,2],[4,2]),[2,1],[2,1],[4,3])./Y([3,1,2,4],[2,3,1,4],:,:)-1;
max(d(:))

