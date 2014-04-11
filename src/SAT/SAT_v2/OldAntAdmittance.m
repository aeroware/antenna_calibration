
function Y=AntAdmittance(Ant,Op,Calc,solver);

% Y=AntAdmittance(Ant,Op,Calc) calculates admittances Y from 
% Op.Curr or Op.CurrSys, according as Calc==1 or Calc==2.
% In the former case a vector Y returns the single feed 
% admittances from Op.Curr, i.e. the currents at the feeds 
% devided by the respective feed voltages. In the latter case
% an admittance matrix Y is calculated from Op.CurrSys.
% Default: Calc=2 (latter case).
% If Op.CurrSys is not defined, Op.Curr is automatically used.

NB=3;   % number of base functions for concept

if(nargin<4)
    solver=1;   % default ASAP
end %if

if(Calc==1)
    if(~isfield(Op,'Curr'))
        error('ERROR...Invalide structure of OP');
    end
end


if (solver==1)  % ASAP
    
    % Determine feed segments and at which end they are driven:

    TC=CheckTerminal(Ant.Desc,Op.Feed(:,1));

    if any(TC==0),
        error('Invalid Op.Feed passed.');
    end

    SegNum=abs(imag(TC));
    SegEnd=1+(imag(TC)<0);

    % Feed voltages:

    V=Op.Feed(:,2);

    Y=[];

    % Admittance matrix Y from Op.CurrSys or vector Y from Op.Curr:

    if (Calc==2)
        s=size(Op.CurrSys);
        Y=Op.CurrSys(:,sub2ind(s(2:end),SegNum,SegEnd)).';
    else
        Y=Op.Curr(sub2ind(size(Op.Curr),SegNum,SegEnd));
        Y=Y(:)./V;
    end
else % concept
    % check additionally concept fields
    
    if(Calc==1)
        if(~isfield(Op,'ConceptCurr'))
            error('ERROR...Invalide structure of OP');
        end
    else
        if(~isfield(Op,'ConceptCurrSys'))
            error('ERROR...Invalide structure of OP');
        end
    end

    % Determine feed segments and at which end they are driven:

    
    % Feed voltages:

    V=Op.SegFeeds(:,2);

    Y=[];

    % Admittance matrix Y from Op.CurrSys or vector Y from Op.Curr:

    if (Calc==2)
        Y=Op.ConceptCurrSys(:,Op.SegFeeds(:,1),(NB+1)/2);
    else
        Y=Op.ConceptCurr(Op.SegFeeds(:,1),(NB+1)/2);
        Y=Y(:)./V;
    end
end %concept
