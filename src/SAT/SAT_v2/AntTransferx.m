
function [T,Ts,AA,EE,HH,SS]=AntTransferX(ant,op,...
    antennalength, diameter,ZL,YL)

% [T,Ts,AA,EE,HH,SS]=AntTransfer(Ant,Op,er,solver,antennalength, 
% ...diameter,ZL,YL) 
% calculates transfer matrices, which relate the incident E-field with the
% received voltages. The far fields are also computed and returned. 
%
%   Input parameters :
%
%       ant...          antenna structure
%       Op...           structure describing the antenna operation
%       er...           vector of unit vectors pointing to the direction 
%                       where the fields are calculated.
%       solver...       which solver is to be used  - 1...ASAP
%                                                   - 2...Concept    
%       antennalength...length of antenna for radius correction
%                       0 --> no radius correction
%       diameter...     mean diameter of antenna
%       ZL...           impedance matrix
%       YL...           admittance matrix
%
%   Output parameters:
%
%       T...    transfer matrix for the case of a connected load network 
%               described by the impedance matrix ZL, which may be a scalar 
%               or vector of loads, defining impedance values for each 
%               feed.
%       Ts...   transfer matrix for single open feeds.
%       AA...   vector potential far field without factor exp(-jkr)/r
%       EE...   electric far field without factor exp(-jkr)/r
%       HH...   magnetic far field without factor exp(-jkr)/r
%       SS...   poynting vector field without factor exp(-jkr)/r



% The calculations are based on the current system Op.Curr. er is the 
% radiation direction, several ones may be given by a 
% nx3 matrix. Accordingly T and Ts are 3-dimensional, size fx3xn
% for n requested directions, where f is the number of feeds. The transfer
% matrices are corrected for the real antenna radius. If the antennalength
% is set to 0, or the parameter is omitted, no correction is performed.
% 
% The following explanations use n=1, but analogous considerations
% hold for arbitrary n.
%
% The voltages at the antenna feeds are given by
%
%   V = T*E = ZA*I + To*E = -ZL*I,
%
% To being the open terminal transfer matrix, from which T is determined as
%
%   T = ZL*inv(ZA+ZL)*To
%
% Here I is the corresponding vector of feed currents, ZA the antenna
% impedance matrix, and To the transfer matrix in case of all open 
% terminals (feeds), i.e. ZL=inf*eye(f). 
%
% Default: ZL=inf*eye(f), so T=To is returned if ZL is omitted.
%
% Ts is the transfer matrix for single open feeds, i.e. V=Ts*E yields 
% a vector of voltages, where V(m) is the voltage at the m-th open feed
% when the respective remaining feeds are short-circuited.
% The relation between Ts and To is given by: To = ZA*diag(YA)*Ts.
%
% Omitting ZL, YL is used instead, which is advantageous in case of 
% infinite impedances (open terminals). 
% 
% Whe both matrices are given, ZL/YL is used asas impedance matrix which
% can be used to treat short-circuited as well as open terminals without
% being forced to use inf-values.
%
%   Revision:
%
% 4.7.07 Ensure that antenna radius correction is not performed when 
% solver==2
%
% March 2008: solver==4 -> Concept with patches
%
% Nov 2010: Plasma effect

% global vars

global er;
global solver;

% Check op.Curr

if ~isfield(op,'Curr'),
  error('Invalid op structure !');
end

%if(size(op.Curr,1)>1)
 %   if ~isequal(size(op.Feed,1),size(op.Curr,1)),
  %      error('Invalid specification of current and/or feed fields.');
   % end
%end

if size(er,2)~=3,
  error('Invalid specification of direction vectors.');
end

if nargin<4
    antennalength=0
    diameter=0
end

% Determine antenna impedance and admittance matrices:

%if solver == 4
 %   [ZA,YA]=AntImpedance(ant,op,2,0,0); 
%else
    [ZA,YA]=AntImpedance(ant,op,solver,0,0);    % keine korrektur, sonst doppelt
%end

% Matrix Q to transform from Ts to T by T=Q*Ts:

if size(ZA,1)==size(ZA,2) % sqare 
    Q=ZA*diag(diag(YA));
else
    Q=repmat(ZA,1,size(ZA,1))*diag(YA);
end

f=size(op.Feed,1);  % number of feeds;


n=size(er,1);          % number of radiation/incidence directions


% input parameters

if nargin<6
  YL=[];
end

if nargin<5
  ZL=[];
end

if isempty(YL)&isempty(ZL)
  ZL=eye(f);
  YL=zeros(f);
elseif isempty(ZL)
  ZL=eye(f);
elseif isempty(YL)
  YL=eye(f);
end

YL(find(isinf(YL)))=max(1,max(abs(YA(:))))*1e10;
if length(YL)==1,
  YL=eye(f)*YL;
elseif size(YL,1)~=size(YL,2),
  YL=diag(YL);
end

ZL(find(isinf(ZL)))=max(1,max(abs(ZA(:))))*1e10;
if length(ZL)==1,
  ZL=eye(f)*ZL;
elseif size(ZL,1)~=size(ZL,2),
  ZL=diag(ZL);
end

% save diag(YA)

I_feed=diag(YA);

% correction for antenna radii:

[k,epsi,mu]=Kepsmu(op);

% plasma effect:

epsilon_r=op.Exte(2);

epsi=epsi*epsilon_r;
k=k*sqrt(epsilon_r);

if antennalength ~= 0 && strcmp(solver,'ASAP')
  ZA=ZA-eye(length(ZA))*log(diameter/2/ant.wire(1))/antennalength/(4*pi^2)/epsi/j/op.Freq;
  YA=inv(ZA);
end

if size(ZA,1)==size(ZA,2) % sqare 
    Q=ZL*inv(ZA*YL+ZL)*Q;
else
    Q=ZL*inv(repmat(ZA,1,size(ZA,1))*YL+ZL)*Q;
end
    

% Calculate transfer matrices:

Ts=zeros([f,3,n]);
T=Ts;

if nargout>4,
  HH=T;
  EE=T;
  SS=zeros([f,n]);
end

if ~strcmp(solver,'CONCEPT_EH1D')
    for m=1:size(op.Curr,1) % for all feeds
       % if nargout>4,
            switch solver
                case 'ASAP'
                    [AA0,EE0,HH0,SS0]=FieldFar(ant,op,er,m);
                case 'CONCEPT'
                    [AA0,EE0,HH0,SS0]=FieldFarConcept(ant,op,er,m);
                case 'NEC2'
                    [AA0,EE0,HH0,SS0]=FieldFarNec2(ant,op,er,m);
            end % end switch
      
            EE(m,:,:)=permute(EE0,[3,2,1]);
            HH(m,:,:)=permute(HH0,[3,2,1]);
            SS(m,:)=SS0(:).';
       % else
        %    if(solver==1)
         %       AA0=FieldFar(ant,op,er,m);
          %  else
          %      AA0=FieldFarConcept(ant,op,er,m);
          %  end % if solver==1
       % end % if nargout >4
  
        AA(m,:,:)=permute(AA0,[3,2,1]);
  
        Ts(m,:,:)=AA(m,:,:)./I_feed(m)./1e-7;
%  Ts(m,:,:)=shiftdim(FieldFar(Ant,Op,er).',-1)/1e-7/YA(m,m);
  
    end % for all feeds
    
    for m=1:n,
        T(:,:,m)=Q*Ts(:,:,m);
    end  

else % solver==CONCEPT_EH1D
    for feed=1:f
        ConceptWrite('concept.in',ant,op,8,3,feed,'EH1D preparation');
        rval=ConceptCall();    

        clear er;
        
        N_theta=18;
        N_phi=18;
        
        NN=N_theta*N_phi;

        er=zeros(NN,3);
    
        N=length(ant.Desc);

         wavelength=3e8/op.Freq;
         omega=2*pi*op.Freq;

         theta=linspace(0,pi,N_theta);
         phi=linspace(0,2*pi,N_phi);
            

% vectors to points

dist=1000;

         for(t=1:N_theta)        
            for(p=1:N_phi)
     
            % direction of incident wave
                
                er((t-1)*N_phi+p,1)=dist*sin(theta(t))*cos(phi(p)); % kein einheitsvector !!!
                er((t-1)*N_phi+p,2)=dist*sin(theta(t))*sin(phi(p));
                er((t-1)*N_phi+p,3)=dist*cos(theta(t));
            end % for all theta
         end     % for all phi

             
   %----------------------------------------------------------------------
   
% make field calculation   

                [EE,HH,SS]=FieldFarConceptEH(ant,op,er);
                heffV=FarE2h(er,EE,op.Freq);
                heff_av(feed,:)=(mean(heffV,1));
     end
               
                T=Ts2T(heff_av,YA);
end % if solver >3

  

