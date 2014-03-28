
function Ant1=GridAnalyse(Ant,Freq)


[Points,Wires,Surfs]=FindGridObj(Ant);

% check segments:
% ----------------

Isactive=zeros(size(Desc,1),1);

Tag=nan(size(Desc,1),1);

try
  Cond=Ant.Phys.Wire.Cond;
  if isempty(Cond),
    Cond=nan;
  end
catch
  Cond=nan;
end
Cond=repmat(Cond,size(Desc,1),1);

try
  Radius=Ant.Phys.Wire.Radius;
  if isempty(Radius),
    Radius=nan;
  end
catch
  Radius=nan;
end
Radius=repmat(Radius,size(Desc,1),1);

Objnum=cell(size(Desc,1),1);

for w=numel(Wires),
  s=abs(Obj(Wires(w)).Elem);
  Isactive(s)=1;
  for sn=1:length(s),
    Objnum{s(sn)}=unique([Objnum{s(sn)}(:).',w]);
  end
  try 
    t=Ant.Obj(Wires(w)).Phys.Tag;
    if isempty(t),
      t=nan;
    end
  catch
    t=nan;
  end
  ss=s(isnan(Tag(s)));
  Tag(ss)=t;
  
  
    
end





  
