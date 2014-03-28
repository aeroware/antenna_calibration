WorkingDir=pwd;
Atta_Feko_out='antfile.out';
Freq=3e5;
Method = 'FEKO';


load('testcube.mat');

if isfield(ant,'Solver')&&isfield(ant,'Geom_'),
  PhysGrid=ant;
else
  PhysGrid=GetPhysGrid(ant,Solver,{},WorkingDir);
end

try
    q0=PhysGrid.Geom_.Feeds.Elem;
  catch
    q0=[];
  end
  
  try
    q1=PhysGrid.Desc_.Feeds.Elem;
  catch
    q1=[];
  end
  
  MaxFeedNum=length(q0)+length(q1);
  if MaxFeedNum<1,
    error('No feeds found.');
  end
  
  for nf=1:length(Freq),
    for FeedNum=1:MaxFeedNum
        [AA,f]=FEKO_get_A(Atta_Feko_out,WorkingDir, 1);
        [k,epsi,mu]=Kepsmu(f,PhysGrid) ;
        IA=getFekoFeedCurrent(WorkingDir,Atta_Feko_out);
        Ts=AA*(4*pi)/mu/IA;
    end  
  end
  
