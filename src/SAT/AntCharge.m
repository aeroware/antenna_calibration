
function [Q,QSys]=AntCharge(Ant,Op)

% [Q,QSys]=AntCharge(Ant,Op) calculates the line charges at the 
% segment ends from the corresponding line currents Op.Curr.
% QSys returns the system of line charges corresponding to the
% current system Op.CurrSys.

Q=[];
QSys=[];

% determine QSys:

if (nargout>1)&isfield(Op,'CurrSys'),
  
  if ~isfield(Op,'Curr');
    Op.Curr=[];
  end
  CurrSave=Op.Curr;
  
  QSys=Op.CurrSys;

  for f=1:size(Op.CurrSys,1),
    Op.Curr=shiftdim(Op.CurrSys(f,:,:),1);
    QSys(f,:,:)=shiftdim(AntCharge(Ant,Op),-1);
  end
  
  Op.Curr=CurrSave;
  
end

% determine Q:

if ~isfield(Op,'Curr'),
  return
end

k=Kepsmu(Op);
w=2*pi*Op.Freq;

Q=Op.Curr;

for n=1:size(Op.Curr,1),
  L=Mag(Ant.Geom(Ant.Desc(n,1),:)-Ant.Geom(Ant.Desc(n,2),:));
  kL=k*L;
  Q(n,:)=Op.Curr(n,:)*[-cos(kL),-1;1,cos(kL)]*(j/w/L/sinq(kL));
end


