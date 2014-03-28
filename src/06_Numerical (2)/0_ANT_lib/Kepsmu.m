
function [k,epsilon,mu,eps0,mu0]=Kepsmu(Freq,AntGrid,sigma)

% [k,epsilon,mu]=Kepsmu(Freq,AntGrid) returns the propagation constant k,  
% the complex dielectric constant epsilon and the permeability mu of 
% the exterior medium for frequency Freq. 
% (In this version it is still assumed that mu=mu0.)
%
% [k,epsilon]=Kepsmu(Freq,epsrel,sigma) calculates k and epsilon from 
% relative permittivity epsrel and conductivity sigma at frequency Freq.
% All parameters may be arrays of same size or scalars.


c=2.99792458e8;

mu0=4e-7*pi;
eps0=1/c^2/mu0;

% determine mu:

mu=mu0;

% determine epsilon:

if isstruct(AntGrid), % Kepsmu(Freq,AntGrid)

  if nargin>2,
    error('No 3. input argument allowed when 2. argument is a grid struct.');
  end
  
  try
    epsilon=eps0*EvaluateFun(AntGrid.Exterior.epsr,Freq);
    %mu=EvaluateFun(AntGrid.Exterior.mu,Freq);
  catch
    error('No exterior medium derfined in antenna grid struct.');
  end
  
else    % Kepsmu(Freq,epsrel,sigma)
  
  if nargin<3,
    error('No conductivity defined.');
  end
  
  epsilon=eps0*AntGrid+sigma./(j*2*pi*Freq);  
  
end

% determine k:

k=sqrt(epsilon.*mu).*(2*pi*Freq);
m=find(real(k)<0);
k(m)=-k(m);

