
function [FF,AA]=FarField(Field,AntGrid,Op,er,WorkingDir,Method)

% FF=FarField(Field,AntGrid,Op,er,WorkingDir)
% calculates the far field for the driving situation given by the 
% operation struct array Op (may only be a 1x1 struct).
% er must be a matrix of size (d x 3), d being the number of 
% directions for which the field is to be calculated.
% The directory WorkingDir is that where the input and output files
% for the calculations are stored (at present only used for
% Concept solver calculations). 
% The returned field FF is determined by the string Field, which may
% be 'A','E','H' or 'S'. FF then returns the vector potential AA, 
% the electric (EE) or magnetic (HH) field strength apart from the 
% factor exp(-jkr)/r:
%
%   AA = mu/(4*pi) Int I(r') exp(j*k*er.r') ds'
%   EE = - k/(w*epsilon) * er x HH
%   HH = - j*k/mu * er x AA
%
% or it returns the Poynting flux amplitude (SS) apart from the factor 
% exp(2Im(k)r)/r^2:
%
%   SS = 1/2 EE x HH* = k/(2*w*epsilon) * |HH|^2 * er
%
% Therefore the proper complex field vectors can be determined from 
% the corresponding returned quantities as follows:
%
%   A = exp(-j*k*r)/r * AA
%   E = exp(-j*k*r)/r * EE
%   H = exp(-j*k*r)/r * HH
%   S = exp(2*Im(k)*r)/r^2 * SS
%
% The time-average power flow P through the unit solid angle is then
% easily calculated by (Im(k)<0 represents attenuation):
%
%   P = real(r^2 * S) = real(exp(2*Im(k)*r) * SS)
%
% [FF,AA]=FarField(...) additionally returns the vector potential AA.
% 
% [FF,AA]=FarField(Field,AntGrid,Op,er,WorkingDir,Method)
% determines the Method to be used:
%   Method='Matlab' uses Matlab funcions to calculate AA, EE, etc.
%          'Solver' calls the respective solver to determine EE and 
%                   therefrom other fields.
% The following methods are implemented at present:
%   'Matlab' for Asap wire grid,
%   'Solver' for Concept wire and patch grids.
%
% 04.2011...Feko implemented by Thomas Oswald

if ~exist('Method','var')||isempty(Method),
  Method='Matlab';
end
Method=upper(Method);
if isequal(Method(1),'M'),
  Method='Matlab';
else
  Method='Solver';
end

if ~exist('Field','var')||isempty(Field)||~ischar(Field),
  error('No Field name given.');
end
Field=deblank(Field);
Field=upper(Field(1));
if ~ismember(Field,{'A','E','H','S'}),
  error('Unknown field specification.');
end

er=er./repmat(Mag(er,2),[1,3]);  % ensure unit vectors

[k,epsilon,mu]=Kepsmu(Op.Freq,AntGrid);

w=2*pi*Op.Freq;


if isequal(CheckSolver(AntGrid.Solver),CheckSolver('ASAP')),
  
  AA=Asap_FarA(AntGrid,Op,er);
  
  switch Field,
    case 'A',
      FF=AA;
    case 'E',
      FF=(j*w)*cross(er,cross(er,AA,2),2);
    case 'H',
      FF=(-j*k/mu).*cross(er,AA,2);
    case 'S',
      FF=(w*conj(k/mu)/2)*Mag(cross(er,AA,2),2).^2;
  end
  
elseif isequal(CheckSolver(AntGrid.Solver),CheckSolver('CONCEPT')),
  
  if 1==0, % isempty(AntGrid.Desc2d)&&isequal(Method,'Matlab'),
    
    AA=Concept_FarA(AntGrid,Op,er);
    
    switch Field,
      case 'A',
        FF=AA;
      case 'E',
        FF=(j*w)*cross(er,cross(er,AA,2),2);
      case 'H',
        FF=(-j*k/mu).*cross(er,AA,2);
      case 'S',
        FF=(w*conj(k/mu)/2)*Mag(cross(er,AA,2),2).^2;
    end

  else % use Solver to calculate E first
    
    if 1==1,
      EE=Concept_Far(Op.Freq,AntGrid,er,WorkingDir,'E');
    else
      % The following is an alternative, but worse since Concept seems
      % to calculate Hp less accurate than Ep in the far zone
      % (where Hp and Ep are projections normal to er),
      % although there are large E-components parallel to er(!?).
      HH=Concept_Far(Op.Freq,AntGrid,er,WorkingDir,'H');
      EE=(-k/w/epsilon).*cross(er,HH,2);
    end
    
    switch Field,
      case 'A',
        FF=Vproj2V(er,EE/(-j*w));
      case 'E',
        FF=EE;
      case 'H',
        FF=(k/w/mu).*cross(er,EE,2);
      case 'S',
        FF=conj(k/2/w/mu)*Mag(EE,2).^2;
    end
    
    if (nargout>1)&&~exist('AA','var'),
      AA=Vproj2V(er,EE/(-j*w));
    end
    
  end % Concept-Solver  
  
elseif isequal(CheckSolver(AntGrid.Solver),CheckSolver('FEKO')),  
    AA=FEKO_get_A('feko.out',WorkingDir, 1);
    
    switch Field,
      case 'A',
        FF=AA;
      case 'E',
        FF=(j*w)*cross(er,cross(er,AA,2),2);
      case 'H',
        FF=(-j*k/mu).*cross(er,AA,2);
      case 'S',
        FF=(w*conj(k/mu)/2)*Mag(cross(er,AA,2),2).^2;
    end
    
  else
  
  error('Solver not recognized.');
  
end 



% if 0==1,   % check different ways of calculating fields and SS:
%   HH1=(-j*k/mu).*cross(er,AA,2); % =(k/w/mu).*cross(er,EE);
%   EE1=(-k/w/epsilon).*cross(er,HH1,2); % =(j*w)*cross(er,cross(er,AA,2),2);
%   SS1=(k/2/w/epsilon)*Mag(HH1,2).^2;
%   SS2=conj(k/2/w/mu)*Mag(EE1,2).^2;
%   SS3=(w*conj(k/mu)/2)*Mag(cross(er,AA,2),2).^2;
%   max(abs(1-SS(:)./SS1(:)))
%   max(abs(1-SS(:)./SS2(:)))
%   max(abs(1-SS(:)./SS3(:)))
% end

