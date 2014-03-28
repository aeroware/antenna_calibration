
function CC=MMConvCurr(DescDip,C)

% Converts from segment currents to dipole currents or vice versa:
%
% CurrDip=MMConvCurr(DescDip,Curr) calculates dipole currents CurrDip 
% of the dipoles DescDip from the segment currents Curr.
%
% Curr=MMConvCurr(DescDip,CurrDip) calculates the segment currents Curr 
% from the dipole currents CurrDip of the dipoles DescDip.

if isequal(size(C,2),2),

  % Calculate dipole currents CC from segment currents C:

  s=DescDip(:,2);
  CC=sign(s).*C(sub2ind(size(C),abs(s),1+(s<0)));
  
elseif isequal(size(C,2),1),

  % Calculate segment currents CC from dipole currents C:
  
  CC=zeros(max(abs(DescDip(:))),2);
  
  nd=size(DescDip,1);
  
  n=zeros(nd,2);
  n(:,1)=sub2ind(size(CC),abs(DescDip(:,1)),1+(DescDip(:,1)>0));
  n(:,2)=sub2ind(size(CC),abs(DescDip(:,2)),1+(DescDip(:,2)<0));
  
  for d=1:nd,
    CC(n(d,:))=CC(n(d,:))+sign(DescDip(d,:))*C(d);
  end
  
else
  
  error('Invalid 2nd dimension of current variable.');
  
end
