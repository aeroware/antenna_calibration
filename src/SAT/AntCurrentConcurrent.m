
function Op1=AntCurrentConcurrent(ant,Op,Calc,solver,asapexe,titl,...
    patches,nec2bin)

% function Op1=AntCurrentConcurrent(ant,Op,Calc, solver,asapexe,titl,...
%   patches, nec2bin) is the multithreaded version of AntCurrent
% It calculates antenna current distribution. Op1 returns Op extended by 
% the determined currents. Calc controls how and which 
% currents are calculated:
%
% Calc=0 .. Op1.Curr is calculated from Op.CurrSys and Op.Feed //obsolete
% Calc=1 .. Op1.Curr is calculated by one ASAP/CONCEPT call (default)
% Calc=2 .. Op1.Curr is calculated by calling ASAP/CONCEPT 
%           several times 
%
% The current system (field Curr) is defined to be the 
% currents excited by single voltage sources at the given 
% feeds (field Feed): Curr(k,:,:) is excited by a 
% voltage source of 1 Volt at Feed k (k=1..number of feeds).
% The field Curr contains the currents obtained when all
% given voltage sources are active at the same time, with 
% the corresponding voltages given in Feed(:,2).
%
% Curr=StereoCurrent(Op) is a short form returning the current 
% field (not embedded in an Op1-structure) and presuming 
% Calc=0, so the fields Op.CurrSys and Op.Feed must exist.
%
% Only Calc=2 is implemented for Concept
%
% Revision:12.6.7 by Thomas Oswald
% Flexible length of Op.Excit
%
% Revision:01.08 by Thomas Oswald
% AIF and AOF and AIFC functionality removed
%
% Revision:09.10 by Thomas Oswald
% NEC2 and concurrent functionality added

if nargin<6
    error('Not enough parameters !');
end

if nargin<7
    patches=0;
end


%-------------------------------------------------------------------------

if solver==1 % asap
    if nargin==1,
        [ant,Op]=deal([],ant);
        Calc=0;
    else
        Op1=Op;
        if (nargin<3)|isempty(Calc),
            Calc=1;
        end  % if
    end % else

    % Calculate CurrSys and/or Curr with the help of ASAP:

    if Calc==2, % calculate CurrSys and Curr

        n=size(Op.Feed,1);
        s=size(ant.Desc,1);
        
        Op1.Curr=zeros(n,s,2);
        Op1.Feed=Op.Feed;
        Op1.Exte=Op.Exte;
        Op1.Excit=zeros(1,n);
        
        OpConn(1:n)=Op1;
        
        C={'Current system calculation requested by function AntCurrent,',
            'this file for current excited by 1 Volt voltage source at'};
        for k=1:n,
            C{3}=['Feed number ',num2str(k),'. \n'];
            fprintf(C{3});
          
            d=sprintf('A%i',k);
            cd(d);
            
            %OpConn(k)=Op1;
            OpConn(k).Feed=[Op.Feed(k,1),1];
            OpConn(k).Excit(k)=1;
            
            AsapWrite(ant,OpConn(k));
            cd('..');
        end %for
        
        
            [stat,result]=AsapCallConcurrent();
            
            if stat == 1
                fprintf('...failed...');
                fprintf(result);
            else
                fprintf('...finished');
            end
                
                
            for(k=1:n)
                d=sprintf('A%i',k);
                cd(d);
                
                [ant, OpConn(k)]=AsapRead(ant,OpConn(k),k);
                Op1.Curr(k,:,:)=OpConn(k).Curr(k,:,:); 
                Op1.Excit=Op1.Excit+OpConn(k).Excit;
            %Op1.Curr(k,:,:)=AsapRead();
           % Op1.Curr=Op1.Curr+shiftdim(Op1.CurrSys(k,:,:))*Op.Feed(k,2);
                cd('..');
            end % for all feeds
    
         Op1.Feed=Op.Feed;
       
    else % Calc==1: calculate Curr with one ASAP call

        C={'Current calculation requested by function AntCurrent'};
        AsapWrite(ant,Op,'OUTPUT(CURRENT)');
        AsapCall(asapexe);
       % Op1.Curr(1,:,:)=AsapRead();
        [ant, Op1]=AsapRead(ant,Op1,1);
        Op1.Excit(1:length(Op.Feed))=1;
        Op1.Feed=Op.Feed;
    end

    %---------------------------------------------------------------------
else % concept
    %---------------------------------------------------------------------
  

    % Calculate CurrSys and/or Curr with the help of Concept II:


        n=size(Op.SegFeeds,1);
        s=size(ant.Desc,1);
   
        Op1=Op;
        Op1.Curr=zeros(n,s,2);
        Op1.ConceptCurr=zeros(n,s,3);
        
        OpConn(1:3)=Op1;
        
        for k=1:n,
            C{3}=['Feed number ',num2str(k),'. \n'];
            fprintf(C{3});
            
            d=sprintf('A%i',k);
            cd(d);
            
            if patches
                ConceptWrite('concept.in',ant,Op1,8,3,k,titl);
            else
                ConceptWrite('concept.in',ant,Op1,8,2,k,titl);
            end
            
            rval=ConceptPreCallConcurrent();
            
            cd('..');
        end % for
            
        rval=ConceptCallConcurrent(n);
        
        for k=1:n
            d=sprintf('A%i',k);
            cd(d);
        
            [ant, Op1]=ConceptRead(ant,Op1,k); 
            
            cd('..');
        end % for
        Op1.SegFeeds=Op.SegFeeds;
        Op1.Excit=zeros(length(Op1.SegFeeds),1)+1;
        Op1.Freq=Op.Freq;
end % concept
