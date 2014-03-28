
function V=Vproj2V(er,Vp,Method)

% V=Vproj2V(er,Vp)
% calculates vectors V from its provections Vp othogonal to er.
% er, Vp and V are 2-dim arrays, the rows of er giving the directions
% to which the fields Vp (respective rows) are radiated.
% So er, Vp and V are size nx3, n being the number of directions.
% Since V cannot be determined from Vp uniquely, it is done in 
% such a way that the variation of V over the directions is minimal.

if ~exist('Method','var'),
  Method=1;
end

n=size(er,1);   % number of radiation/incidence directions

er=er./repmat(Mag(er,2),[1,3]);

V=cross(cross(er,Vp,2),er,2);

if n<2,
  warning('At least 2 projections are necessary to retrieve er-components.')
  return
end

if Method==1

  sV=sum(V,1);
  
  if 1==0,
    lam=(n*eye(n)-er*er.')\(er*sV.');
  else
    een=er.'*er/n;
    lam=er*(eye(3)+(eye(3)-een)\een)*sV.'/n;
  end
  
else
  
  ediff=zeros(3*(n-1),n);
  for m=1:n-1,
    ediff(3*(m-1)+1:3*m,m:m+1)=[er(m,:).',-er(m+1,:).'];
  end

  Vdiff=reshape(V(2:end,:).'-V(1:end-1,:).',3*(n-1),1);
  lam=ediff\Vdiff;

end

for mm=1:n,
  V(mm,:)=V(mm,:)+lam(mm)*er(mm,:);
end

