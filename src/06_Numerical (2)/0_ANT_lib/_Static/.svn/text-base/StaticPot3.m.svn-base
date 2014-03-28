
function psi=StaticPot3(r1,r2,r3,rObs)

% psi=StaticPot3(r1,r2,r3,rObs) calcultaes static potential psi
% at the observations point rObs from a uniformly charged triangle
% with unit total charge. The corners of the triangle are given as 
% radius vectors r1, r2, and r3.

RelAcc=1e-8;  % relative accuracy

global IntPara_r31 IntPara_r21 IntPara_r01 IntPara_mr31 IntPara_n

IntPara_r31=reshape(r3(:)-r1(:),1,3);
IntPara_r21=reshape(r2(:)-r1(:),1,3);
IntPara_r01=reshape(rObs(:)-r1(:),1,3);
IntPara_mr31=Mag(IntPara_r31);

% normalization parameter roughly estimating result,
% used for proper tolerance handling:

c=2.99792458e8;
eps0=1/(4e-7*pi*c^2);
IntPara_n=1/(4*pi*eps0*max(IntPara_mr31,Mag(IntPara_r01)));

% integration:

psi=quadml(@IntegrandStaticPot3,0,1,RelAcc)*IntPara_n;
%psi=quadl(@IntegrandStaticPot3,0,1,RelAcc)*IntPara_n;


end % of main function


% ----------------------------------

function x=IntegrandStaticPot3(t)

global IntPara_r31 IntPara_r21 IntPara_r01 IntPara_mr31 IntPara_n

s=size(t);
t=t(:);

L=IntPara_mr31*(1-t);

r0r=repmat(IntPara_r01,length(t),1)-t*IntPara_r21;

z=r0r*(IntPara_r31/IntPara_mr31).';

rho=sqrt(max(0,sum(r0r.^2,2)-z.^2));

x=reshape((2./IntPara_n).*(1-t).*StaticPot1(L,rho,z),s);

end
