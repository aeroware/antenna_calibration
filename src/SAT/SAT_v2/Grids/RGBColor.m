
function RGB=RGBColor(Col,DefaultCol);

% RGB=RGBColor(Col) calculates RGB color values from arbitrary 
% color specification Col. Col may be a string array or a double
% column vector. Each row corresponds to a color specification.
% Valid Color characters are (default=DefaultCol or black):
%   y(ellow) m(agenta) c(yan) r(ed) g(reen) b(lue) w(hite) (blac)k
% Valid double values are indices into the current colormap, values
% outsise are mappeed onto the smallest or greatest index, resp.

if ischar(Col), 
  if ~isempty([strmatch('none',Col);strmatch('auto',Col)]),
    RGB=Col;
    return
  end
end

CM=colormap;
NC=size(CM,1);

% Color translation matrix:

c=-ones(127,3);
c(121,:)=[1 1 0];
c(109,:)=[1 0 1];
c(99,:)=[0 1 1];
c(114,:)=[1 0 0];
c(103,:)=[0 1 0];
c(98,:)=[0 0 1];
c(119,:)=[1 1 1];
c(107,:)=[0 0 0];
d=find(c(:,1)<0);

% determine default color:

if (nargin<2) | isempty(DefaultCol),
  DefaultCol=[0,0,0];
end
if ischar(DefaultCol),
  DefaultCol=c(min(max(double(DefaultCol(1)),1),127),:);
elseif size(DefaultCol,2)==1,
  DefaultCol=CM(min(max(round(DefaultCol(1)),1),NC),:);
end
if any(DefaultCol<0|DefaultCol>1),
  DefaultCol=[0,0,0];
end
c(d,:)=repmat(DefaultCol,[length(d),1]);  

% determine RGB colors for Col:

if ischar(Col),
  RGB=c(min(max(double(Col(:,1)),1),127),:);
elseif size(Col,2)==1,
  RGB=CM(min(max(round(Col),1),NC),:);
else
  RGB=Col;
end

