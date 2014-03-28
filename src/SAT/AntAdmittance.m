
function Y=AntAdmittance(Ant,Op,solver, antennalength,diameter);

%   Y=AntAdmittance(Ant,Op,solver,antennalength,diameter) calculates 
%   admittances Y from Op.Curr or Op.ConceptCurr.
%
%   Input parameters :
%
%       ant...          antenna structure
%       Op...           structure describing the antenna operation
%       solver...       which solver is to be used  - 1...ASAP
%                                               - 2...Concept    
%       antennalength...length of antenna for radius correction
%                       0 --> no radius correction
%       diameter...     mean diameter of antenna
%
%   Output parameters:
%
%       Y...    admittance matrix




NB=3;   % number of base functions for concept

if(nargin<3)
    solver='ASAP';   % default ASAP
end %if

% Feed voltages:

    V=Op.Excit;
    Y=[];

switch solver
    case 'ASAP'  % ASAP
    
        % Determine feed segments and at which end they are driven:

        TC=CheckTerminal(Ant.Desc,Op.Feed(:,1));

        % if any(TC==0),
        %    error('Invalid Op.Feed passed.');
        % end

        SegNum=abs(imag(TC));
        SegEnd=1+(imag(TC)<0);

    % Admittance matrix Y from Op.CurrSys or vector Y from Op.Curr:

        s=size(Op.Curr);
        Y=Op.Curr(:,sub2ind(s(2:end),SegNum,SegEnd)).';
   
    case 'CONCEPT' % concept  
        
        % Admittance matrix Y from Op.CurrSys or vector Y from Op.Curr:

        Y=Op.ConceptCurr(:,Op.SegFeeds(:,1),(NB+1)/2);
        
    case 'CONCEPT_PATCHES' % concept  with patches
        
        % Admittance matrix Y from Op.CurrSys or vector Y from Op.Curr:

        Y=Op.ConceptCurr(:,Op.SegFeeds(:,1),(NB+1)/2);
    case 'NEC2'  % nec2
        % Admittance matrix Y from Op.CurrSys or vector Y from Op.Curr:

        Y=Op.NecCurr(:,Op.SegFeeds(:,1));
end %switch

% antenna radius correction

if antennalength ~= 0,  
    [k,epsi,mu]=Kepsmu(Op);
    ZA=inv(Y);
    ZA=ZA-eye(size(ZA))*log(diameter/2/Ant.wire(1))/antennalength/(4*pi^2)/epsi/j/Op.Freq;
    Y=inv(ZA);
end