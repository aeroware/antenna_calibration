
function [varargout]=GridNearest(varargin) 
 
% Nodes=GridNearest(Geom,Geom1) finds to each point of Geom1
% the respective nearest node of Geom, so Geom(Nodes(k),:)
% is nearest to Geom1(k,:) among all nodes in Geom.
%
% [Segms,F]=GridNearest(Geom,Desc,Geom1) finds to each 
% point of Geom1 the nearest segment of the grid (Geom,Desc).
% F returns the fraction of the segment from start to end point 
% where the nearest point is found, so the segment which is 
% closest to Geom1(k,:) is Segms(k) and the nearest point on it is 
% Geom(Desc(Segms(k),1),:)*(1-F(k))+Geom(Desc(Segms(k),2),:)*F(k).
%
% [Nodes,F1]=GridNearest(Geom,Geom1,Desc1) finds to each 
% segment of the grid (Geom1,Desc1) the nearest node of Geom.
% F1 returns the fraction of the segment from start to end point 
% where the nearest point is found, so the node which is 
% closest to the segment Desc1(k,:) is Geom(Nodes(k),:) and 
% the nearest point of the segment itself is 
% Geom1(Desc1(k,1),:)*(1-F1(k))+Geom1(Desc1(k,2),:)*F1(k).
%
% Not implemented yet:
% [Segms,F,F1]=GridNearest(Geom,Desc,Geom1,Desc1) finds to each 
% segment of the grid (Geom1,Desc1) the nearest segment of the 
% grid (Geom,Desc). As defined above, F and F1 are the fractions 
% of the segments from start to end point where the respective 
% nearest points are found. F refers to grid (Geom,Desc) and F1
% to the grid (Geom1,Desc1). Segms(k) is the number of the 
% segment of (Geom,Desc) which is closest to the k-th segment 
% of grid (Geom1,Desc1).

if nargin==2, 
  
  % Nodes=GridNearest(Geom,Geom1) 
  
  n=size(varargin{1},1);
  n1=size(varargin{2},1);

  if n*n1==0,
    varargout={};
    return
  end

  varargout={zeros(n1,1)};

  for k=1:n1,
    [m,j]=min(Mag(varargin{1}-repmat(varargin{2}(k,:),n,1),2));
    varargout{1}(k)=j(1);
  end

elseif nargin==4,  % not implemented yet!
  
  % [Segms,F,F1]=GridNearest(Geom,Desc,Geom1,Desc1) 
  
  n=size(varargin{2},1);
  n1=size(varargin{4},1);

  if n*n1==0,
    varargout={};
    return
  end

  varargout={zeros(n1,1),zeros(n1,1)};

  for k=1:n1,
    
    
  end

elseif size(varargin{2},2)==2,
    
  % [Segms,F]=GridNearest(Geom,Desc,Geom1) 
  
  n=size(varargin{2},1);
  n1=size(varargin{3},1);

  if n*n1==0,
    varargout={};
    return
  end

  varargout={zeros(n1,1),zeros(n1,1)};

  ss=varargin{1}(varargin{2}(:,1),:);  % segment start point
  sv=varargin{1}(varargin{2}(:,2),:)-ss;  % segment vector
  
  for k=1:n1,
    G=repmat(varargin{3}(k,:),n,1);
    F=Bound(sum(sv.*(G-ss),2)./sum(sv.*sv,2),0,1);
    [m,j]=min(sum((ss+sv.*[F,F,F]-G).^2,2));
    varargout{1}(k)=j(1);
    varargout{2}(k)=F(j(1));
  end

else
  
  % [Nodes,F1]=GridNearest(Geom,Geom1,Desc1)
  
  n=size(varargin{1},1);
  n1=size(varargin{3},1);

  if n*n1==0,
    varargout={};
    return
  end

  varargout={zeros(n1,1),zeros(n1,1)};
  
  G=varargin{1};
  
  for k=1:n1,
    ss=repmat(varargin{2}(varargin{3}(k,1),:),n,1); 
    sv=repmat(varargin{2}(varargin{3}(k,2),:)-ss(1,:),n,1); 
    F=Bound(sum(sv.*(G-ss),2)./sum(sv.*sv,2),0,1);
    [m,j]=min(sum((ss+sv.*[F,F,F]-G).^2,2));
    varargout{1}(k)=j(1);
    varargout{2}(k)=F(j(1));
  end
   
end





