
function [Ant,AddN,AddS]=GridSplitSegs(Ant0,Segs,Frac,AddN2Obj,AddS2Obj,AdaptPats);

% [Ant,AddN,AddS]=GridSplitSegs(Ant0,Segs,Frac,AddN2Obj,AddS2Obj,AdaptPats)
% inserts new points in the segments Segs. The new node 
% inserted in the k-th segment is the fraction Frac(k) 
% of the respective segment length away from the  
% start node of the segment. If Frac is a scalar, it 
% is applied to all segments. If Frac is not passed,
% a default value of 0.5 is assumed. AddN are the node 
% numbers of the inserted nodes, AddS the segment numbers 
% of the additional inserted segments.
%
% If a AddN2Obj=1 is passed, each inserted node is also
% added to the respective Point objects where both end nodes of 
% the respective splitted segment are contained.
% If a AddS2Obj=1 is passed, the inserted segments are also
% added to the respective Wire objects where the splitted segments 
% are contained. AdaptPats=1 causes all patches which have an edge 
% common with a splitted segment to be adapted by adding the 
% corresponding inserted nodes as new corners.

% REVISIONS
% 15.4.2003: 
% - additional feature AdaptPats implemented.
% - changed the line 
%     [s,m,k]=intersect(Ant.Obj(n).Elem,Segs);
%   into (see #1)
%     [s,m,k]=intersect(abs(Ant.Obj(n).Elem),Segs);
%   to respect potential negative segment elements in object definitions.
% June 07 by Thomas Oswald:
%   - adept pats==2 splits the patches

Ant=Ant0;

if (nargin<2)|ischar(Segs),
  Segs=1:size(Ant.Desc,1);
end
Segs=Segs(:);
old1=Ant.Desc(Segs(:),1);
old2=Ant.Desc(Segs(:),2);

if (nargin<3)|isempty(Frac),
  Frac=1/2;
end
Frac=Frac(:);
if length(Frac)~=length(Segs),
  Frac=repmat(Frac(1),[length(Segs),1]);
end
if any((Frac<=0)|(Frac>=1));
  warning(['There are fraction(s) not pointing inside segment(s).']);
end

Frac=[Frac,Frac,Frac];

% new geometry matrix:

Geomi=Ant0.Geom(Ant0.Desc(Segs,1),:).*(1-Frac)+...
      Ant0.Geom(Ant0.Desc(Segs,2),:).*Frac;

Ant.Geom=[Ant0.Geom;Geomi];

AddN=size(Ant0.Geom,1)+(1:size(Geomi,1))';

% new description matrix:

Desci=[AddN,Ant0.Desc(Segs,2)];

Ant.Desc=[Ant0.Desc;Desci];
Ant.Desc(Segs,2)=AddN;

AddS=size(Ant0.Desc,1)+(1:size(Desci,1))';

[P,W,S]=GridFindObj(Ant);

% add new segments to objects:

if (nargin<5)|isempty(AddS2Obj),
  AddS2Obj=0;
end

if AddS2Obj&~isempty(W),
  for n=W(:)',
    [s,m,k]=intersect(abs(Ant.Obj(n).Elem),Segs);  %#1
    if ~isempty(k),
      Ant.Obj(n).Elem=union(Ant.Obj(n).Elem,AddS(k));
    end
  end
end

% add new nodes to objects:

if (nargin<4)|isempty(AddN2Obj),
  AddN2Obj=0;
end

if AddN2Obj&~isempty(P),
  for n=P(:)',
    [s,m,k]=intersect(Ant.Obj(n).Elem,Ant0.Desc(Segs,1));
    [s,m,q]=intersect(Ant.Obj(n).Elem,Ant0.Desc(Segs,2));
    k=intersect(k,q);
    if ~isempty(k),
      Ant.Obj(n).Elem=union(Ant.Obj(n).Elem,AddN(k));
    end
  end
end

% adapt patches:

if (nargin<6)|isempty(AdaptPats),
  AdaptPats=0;
end

if (AdaptPats==1)&~isempty(Ant.Desc2d),
  [s,n,AdNodes]=FindSegs(Ant.Desc,AddN,2);
  k=size(AdNodes,1);
  for p=1:length(Ant.Desc2d),
    d=Ant.Desc2d{p}(:)';
    m=length(d);
    a=cell(m,1);
    for n=1:m,
      e=repmat([d(n),d(mod(n,m)+1)],k,1);
      q=AddN(find(prod(double(e==AdNodes),2)|prod(double(e==fliplr(AdNodes)),2)));
      [du,s]=sort(Mag(Ant.Geom(q,:)-repmat(Ant.Geom(d(n),:),length(q),1),2));
      q=q(s);
      a{n}=[d(n),q(:)'];
    end
    Ant.Desc2d{p}=[a{:}];
  end
end

if (AdaptPats==2)&~isempty(Ant.Desc2d)
    for n=1:length(Segs)
%         old1=Ant.Desc(Segs(n),1);
%         old2=Ant.Desc(Segs(n),2);
         
        p1=FindPats(Ant.Desc2d,old1(n));
        p2=FindPats(Ant.Desc2d,old2(n));
          
      % nur patches die an beide nodes grenzen werden verändert
          
        m=1;
        while m<=length(p1{1})
            if ismember(p1{1}(m),p2{1}(:))
                  % altes patch löschen
                  
                  %nodes speichern
                  
                oldnods=Ant.Desc2d(p1{1}(m));
                [Ant,dummy1,NewN,dummy3,NewP]=GridRemove(Ant,[],[],[],p1{1}(m));
                 
                newnods1=[]; 
                newnods2=[];
                newnods3=[]; 
                 
                for u=1:length(oldnods{1})
                    %umwandeln 
                    
                    if oldnods{1}(u)==old1(n)
                        newnods1{1}(1)=old1(n);
                        newnods1{1}(2)=length(Ant.Geom);
                        
                        if(u==1)% passt
                            if old2(n)==oldnods{1}(length(oldnods{1}))
                                newnods1{1}(3)=oldnods{1}(2);
                                
                                
                                 if length(oldnods{1})==3
                                    newnods2{1}(1)=length(Ant.Geom);
                                    newnods2{1}(2)=oldnods{1}(2);
                                    newnods2{1}(3)=oldnods{1}(3);
                                else
                                    newnods2{1}(1)=length(Ant.Geom);
                                    newnods2{1}(2)=oldnods{1}(2);
                                    newnods2{1}(3)=oldnods{1}(3);
                            
                                    newnods3{1}(1)=length(Ant.Geom);
                                    newnods3{1}(2)=oldnods{1}(3);
                                    newnods3{1}(3)=oldnods{1}(4);
                                 end % if length
                            
                                
                            else
                                newnods1{1}(3)=oldnods{1}(length(oldnods{1}));% old2 =2
                                
                                if length(oldnods{1})==3
                                    newnods2{1}(1)=length(Ant.Geom);
                                    newnods2{1}(2)=oldnods{1}(2);
                                    newnods2{1}(3)=oldnods{1}(3);
                                else
                                    newnods2{1}(1)=length(Ant.Geom);
                                    newnods2{1}(2)=oldnods{1}(3);
                                    newnods2{1}(3)=oldnods{1}(4);
                            
                                    newnods3{1}(1)=length(Ant.Geom);
                                    newnods3{1}(2)=oldnods{1}(2);
                                    newnods3{1}(3)=oldnods{1}(3);
                                end % if length
                            end % if old2
                            
                        end % if % u
                        
                        if(u==2)
                            if old2(n)==oldnods{1}(3)
                                newnods1{1}(3)=oldnods{1}(1);
                            else % old2 auf 1
                                newnods1{1}(3)=oldnods{1}(3);
                            end
                            
                            if length(oldnods{1})==3
                                newnods2{1}(1)=length(Ant.Geom);
                                newnods2{1}(2)=oldnods{1}(3);
                                newnods2{1}(3)=oldnods{1}(1);
                            else
                                newnods2{1}(1)=length(Ant.Geom);
                                newnods2{1}(2)=oldnods{1}(4);
                                newnods2{1}(3)=oldnods{1}(1);
                            
                                newnods3{1}(1)=length(Ant.Geom);
                                newnods3{1}(2)=oldnods{1}(3);
                                newnods3{1}(3)=oldnods{1}(4);
                            end
                        end
                        
                        if(u==3)
                            if old2(n)==oldnods{1}(2)
                                newnods1{1}(3)=oldnods{1}(1);
                                
                                newnods2{1}(1)=length(Ant.Geom);
                                newnods2{1}(2)=oldnods{1}(1);
                                newnods2{1}(3)=oldnods{1}(2);
                            
                                if(length(oldnods{1})==4)
                                    newnods3{1}(1)=oldnods{1}(3);
                                    newnods3{1}(2)=oldnods{1}(4);
                                    newnods3{1}(3)=oldnods{1}(1);
                                end
                            else
                                newnods1{1}(3)=oldnods{1}(2);
                                
                                newnods2{1}(1)=length(Ant.Geom);
                                newnods2{1}(2)=oldnods{1}(1);
                                newnods2{1}(3)=oldnods{1}(2);
                            
                                if(length(oldnods{1})==4)
                                    newnods3{1}(1)=length(Ant.Geom);
                                    newnods3{1}(2)=oldnods{1}(4);
                                    newnods3{1}(3)=oldnods{1}(1);
                                end
                            end
                        end
                        
                            
                        if(u==4)% das stimmt einmal
                            if old2(n)==oldnods{1}(1)
                                newnods1{1}(3)=oldnods{1}(3);
                            else
                                newnods1{1}(3)=oldnods{1}(1);
                            end
                            
                            newnods2{1}(1)=oldnods{1}(2);
                            newnods2{1}(2)=oldnods{1}(3);
                            newnods2{1}(3)=length(Ant.Geom);
                            
                            newnods3{1}(1)=length(Ant.Geom);
                            newnods3{1}(2)=oldnods{1}(1);
                            newnods3{1}(3)=oldnods{1}(2);
                        end % if
                    end % if
                 end % for
                 Ant.Desc2d(length(Ant.Desc2d)+1)=newnods1;
                 Ant.Desc2d(length(Ant.Desc2d)+1)=newnods2;
                 if ~isempty(newnods3)
                    Ant.Desc2d(length(Ant.Desc2d)+1)=newnods3;
                 end
                 
                p1=FindPats(Ant.Desc2d,old1);
                p2=FindPats(Ant.Desc2d,old2);
                m=0; 
             end % ismember
             m=m+1;
         end % while all cell arrays
    end % for
end % if
