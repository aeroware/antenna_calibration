function Curr=CurrSource(Ant,Op,I)

% Curr=CurrSource(Ant,Op,I) 
% CurrSysI=CurrSource(Ant,Op,'I',)
% CurrSysV=CurrSource(Ant,Op,'V',V);

[Z,Y]=AntImpedance(Ant,Op);

f=size(Z,1);

if (nargin<3)|isempty(I),
  I=eye(f);
end

if  ischar(I),
  if isequal(upper(I(1)),'V'),
    I=diag(1./diag(Z));
  else
    I=eye(f);
  end
end

CurrSysI=Op.CurrSys;

CurrSysI(:)=Z.'*Op.CurrSys(:,:);

if 