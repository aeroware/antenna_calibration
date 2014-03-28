
function [k,eps,mu]=Kepsmu(w,epsrel,sigma)

% [k,eps,mu]=Kepsmu(w,epsrel,sigma) calculates complex dielectric 
% constant eps and propagation constant k from relative 
% permittivity epsrel and conductivity sigma at circular 
% frequency w. Also the permeability mu=4e-7*pi for non-magnetic
% material is returned. 
% All parameters may be arrays of same size or scalars.
%
% [k,eps,mu]=Kepsmu(Op) calculates the same parameters for the
% given antenna operation structure Op, i.e. for the operation 
% frequency Op.Freq and the external medium Op.Exte.

c=2.99792458e8;

mu=4e-7*pi;
eps0=1/c^2/mu;

if isstruct(w),
  w=2*pi*GatherMat({w.Freq});
  Exte=[0,1];
  if isfield(w,'Exte'),
    Exte=GatherMat({w.Exte});
    if isempty(Exte),
      Exte=[0,1];
    end
  end
  sigma=Exte(:,1);
  epsrel=Exte(:,2);
  epsrel(find(epsrel==0))=1;
end

eps=eps0*epsrel+sigma./(j*w);

k=sqrt(eps.*mu).*w;
m=find(real(k)<0);
k(m)=-k(m);

