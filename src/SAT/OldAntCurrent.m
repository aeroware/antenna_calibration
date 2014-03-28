
function Op1=AntCurrent(Ant,Op,Calc,AIF,AOF,AIFC,solver,asapexe,titl)

% Op1=AntCurrent(ant,Op,Calc,AIF,AOF,AIFC, solver,asapexe,titl) 
% calculates antenna current distribution. Op1 returns Op extended by the
% determined currents. Calc controls how and which 
% currents are calculated:
%
% Calc=0 .. Op1.Curr is calculated from Op.CurrSys and Op.Feed //obsolete
% Calc=1 .. Op1.Curr is calculated by one ASAP/CONCEPT call (default)
% Calc=2 .. Op1.Curr is calculated by calling ASAP/CONCEPT 
%           several times 
%
% The current system (field Curr) is defined to be the 
% currents excited by single voltage sources at the given 
% feeds (field Feed): CurrSys(k,:,:) is excited by a 
% voltage source of 1 Volt at Feed k (k=1..number of feeds).
% The field Curr contains the currents obtained when all
% given voltage sources are active at the same time, with 
% the corresponding voltages given in Feed(:,2).
% The optional parameters AIF and AOF define asap input and 
% asap output file name(s), each given as a cell array of 
% strings or a string matrix. AIFC is an optional comment
% string or cell array of strings for AIF. 
%
% Curr=StereoCurrent(Op) is a short form returning the current 
% field (not embedded in an Op1-structure) and presuming 
% Calc=0, so the fields Op.CurrSys and Op.Feed must exist.

if nargin==1
    solver=1
end

%-------------------------------------------------------------------------

if solver==1 % asap
    if nargin==1,
        [Ant,Op]=deal([],Ant);
        Calc=0;
    else
        Op1=Op;
        if (nargin<3)|isempty(Calc),
            Calc=1;
        end  % if
    end % else

    % Calc==0: Calculate Curr from Op.CurrSys:

    if Calc==0,

        if isempty(Op.CurrSys),
            error('No CurrSys field in antenna Op(eration) structure.');
        end

        Op1.Curr=zeros(size(Op.CurrSys,2),2);
        for k=1:size(Op.CurrSys,1),
            Op1.Curr=Op1.Curr+shiftdim(Op.CurrSys(k,:,:),1)*Op.Feed(k,2);
        end

        if nargin==1,
            Op1=Op1.Curr;
        end

        return

    end % calc is 0

    % Check AIF, AOF and AIFC:

    AIFdefault='..\StereoData\AsapInputFileDummy.dat';
    AOFdefault='..\StereoData\AsapOutputFileDummy.dat';

    if (nargin<4)|isempty(AIF), AIF={}; end
    if ~iscell(AIF),
        AIF=cellstr(AIF);
    end % if
    for k=1:length(AIF(:)),
        if isempty(AIF{k}),
            AIF{k}=AIFdefault;
        end
    end
    AIF{end+1}=AIFdefault;

    if (nargin<5)|isempty(AOF), AOF={}; end
    if ~iscell(AOF),
        AOF=cellstr(AOF);
    end
    for k=1:length(AOF(:)),
        if isempty(AOF{k}),
            AOF{k}=AOFdefault;
        end
    end
    AOF{end+1}=AOFdefault;

    if (nargin<6)|isempty(AIFC), AIFC={}; end
    if ~iscell(AIFC),
        AIFC=cellstr(AIFC);
    end
    AIFC{end+1}='';

    % Calculate CurrSys and/or Curr with the help of ASAP:

    if Calc==2, % calculate CurrSys and Curr

        n=size(Op.Feed,1);
        s=size(Ant.Desc,1);
        Op1.Curr=zeros(s,2);
        Op1.CurrSys=zeros(n,s,2);
        C={'Current system calculation requested by function AntCurrent,',
            'this file for current excited by 1 Volt voltage source at'};
        for k=1:n,
            C{3}=['Feed number ',num2str(k),'. '];
            fprintf(C{3});
            ki=min(k,length(AIF(:)));
            ko=min(k,length(AOF(:)));
            Op1.Feed=[Op.Feed(k,1),1];
            AsapWrite(AIF{ki},[AIFC(:);C(:)],Ant,Op1);
            AsapCall(AIF{ki},AOF{ko},asapexe);
            Op1.CurrSys(k,:,:)=AsapRead([],AOF{ko});
            Op1.Curr=Op1.Curr+shiftdim(Op1.CurrSys(k,:,:))*Op.Feed(k,2);
        end %if Calc == 2
        Op1.Feed=Op.Feed;

    else % Calc==1: calculate Curr with one ASAP call

        C={'Current calculation requested by function AntCurrent'};
        AsapWrite(AIF{1},[AIFC(:);C(:)],Ant,Op,'OUTPUT(CURRENT)');
        AsapCall(AIF{1},AOF{1},asapexe);
        Op1.Curr=AsapRead([],AOF{1});

    end

    % delete eventual dummy files:

    if exist(AIFdefault,'file'),
        delete(AIFdefault);
    end

    if exist(AOFdefault,'file'),
        delete(AOFdefault);
    end
    %---------------------------------------------------------------------
else % concept
    %---------------------------------------------------------------------
  
    % Calc==0: Calculate Curr from Op.CurrSys:

    if Calc==0,

        if isempty(Op.ConceptCurrSys),
            error('No CurrSys field in antenna Op(eration) structure.');
        end

        Op1.ConceptCurr=zeros(size(Op.ConceptCurrSys,2),2);
        for k=1:size(Op.ConceptCurrSys,1),
            Op1.ConceptCurr=Op1.ConceptCurr+shiftdim(Op.ConceptCurrSys(k,:,:),1)*Op.SegFeeds(k,2);
        end

        if nargin==1,
            Op1=Op1.ConceptCurr;
        end

        return

    end % calc is 0

   

    % Calculate CurrSys and/or Curr with the help of Concept II:

    if Calc==2, % calculate CurrSys and Curr

        n=size(Op.Feed,1);
        s=size(Ant.Desc,1);
   
        Op1=Op;
        Op1.CurrSys=zeros(n,s,2);
        Op1.ConceptCurrSys=zeros(n,s,3);
        C={'Current system calculation requested by function AntCurrent,',
            'this file for current excited by 1 Volt voltage source at'};
        for k=1:n,
            C{3}=['Feed number ',num2str(k),'. \n'];
            fprintf(C{3});
            
           
            ConceptWrite('concept.in',Ant,Op,8,2,k,titl);
            rval=ConceptCall();
            [ant, Op1]=ConceptRead(Ant,Op1);
            
            Op1.CurrSys(k,:,:)=Op1.Curr(:,:);
            Op1.ConceptCurrSys(k,:,:)=Op1.ConceptCurr(:,:);
           
        end % for
        
        Op1.SegFeeds=Op.SegFeeds;
        Op1.Freq=Op.Freq;

    else % Calc==1: calculate Curr with one ASAP call

%         C={'Current calculation requested by function AntCurrent'};
%         AsapWrite(AIF{1},[AIFC(:);C(:)],Ant,Op,'OUTPUT(CURRENT)');
%         AsapCall(AIF{1},AOF{1},asapexe);
%         Op1.Curr=AsapRead([],AOF{1});

    end

    
end % concept
