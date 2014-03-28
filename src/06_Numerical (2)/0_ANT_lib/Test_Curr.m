
% Concept_Test.m
% ==============

OnlyReadCurr=1;  
% if =1, no current calculations are performed, but data are read from
% files in respective data directories

DataRootDir=...
'..\Datatest';

load('patch-concept-rA33_rB33_fseg2');

deg=pi/180;

% transform to new toolbox format
% -------------------------------

Ant_=GridInit;
Ant_.Geom=ant.Geom;
Ant_.Desc=ant.Desc;
Ant_.Desc2d=ant.Desc2d;
Ant_.Obj=ant.Obj;
Ant_.Init=ant.Init;

for n=1:numel(Ant_.Obj),
  Ant_.Obj(n).Graf=Ant_.Obj(n).GraphProp;
  Ant_.Obj(n).Phys=Ant_.Obj(n).Prop;
  Ant_.Obj(n).Phys.Act=1;
end
Ant_.Obj=rmfield(Ant_.Obj,'GraphProp');
Ant_.Obj=rmfield(Ant_.Obj,'Prop');
Ant_.Obj=rmfield(Ant_.Obj,'forwire');
Ant_.Obj=rmfield(Ant_.Obj,'forpat');

n=FindGridObj(Ant_,'Name','Feeds','Type','Wire');
el=Ant_.Obj(n).Elem;
Ant_.Obj(n).Phys.Posi=repmat('m',size(el));
Ant_.Obj(n).Phys.V=10+(1:length(el));

[P,W,S]=FindGridObj(Ant_);
for n=S(:).',
  Ant_.Obj(n).Graf.EdgeColor=[1,1,1]*0.8;
end
for n=W(:).',
  Ant_.Obj(n).Phys.Posi='';
  Ant_.Obj(n).Phys.Cond=[];
  Ant_.Obj(n).Phys.Radius=[];
  Ant_.Obj(n).Phys.Diam=[];
end

Ant_.Default.CONCEPT.Wire.NBases=3;
Ant_.Default.CONCEPT.Feeds.Posi='b';
Ant_.Default.CONCEPT.Loads.Posi='b';
 
Ant_.Default.Wire.Diam=2e-3;
Ant_.Default.Wire.Cond=inf;
% Ant_.Default.Surf.Thick=1e-2;
% Ant_.Default.Surf.Cond=50e6;
 
 Ant_.Exterior.epsr=1;


% add some loads and specifications for testing
% ---------------------------------------------

% n=FindGridObj(Ant_,'Name','A4','Type','Wire');
% Ant_.Obj(end+1)=Ant_.Obj(n);
% Ant_.Obj(end).Name='Loads';
% el=setdiff(Ant_.Obj(end).Elem,Ant_.Obj(n).Elem); % do not load feed segments
% Ant_.Obj(end).Elem=el;
% Ant_.Obj(end).Phys.Z=100*ones(size(el));
% Ant_.Obj(end).Phys.Posi=repmat('e',size(el));
% 
% n=FindGridObj(Ant_,'Name','A1','Type','Wire');
% Ant_.Obj(n).Phys.NBases=3;
% Ant_.Obj(n).Phys.Cond=1e5;
% 

Ant_.Obj=Ant_.Obj([2,7:end]);


% Solver-Independent parameters
% -----------------------------

Freq=[0.5]*1e6;

Titel='This is a test ';

FeedNum='sys';


% directions for T-calculations:

nth=9;  % intervals in theta
nph=9;  % ..in phi

th=(0:nth)/nth*pi;
ph=(0:nph)/nph*2*pi;
[th,ph]=meshgrid(th,ph);

er=sph2car([ones(numel(th),1),th(:),ph(:)],2);


% Solve with ASAP
% ---------------

if 1==0,
  
tic

Solver='ASAP';

Option={'ForceWires'};

PhysGrid1=GetPhysGrid(Ant_,Solver,Option,DataRootDir);

if OnlyReadCurr,
  Op1=LoadCurr(DataRootDir,PhysGrid1,Freq,FeedNum);
else
  Op1=CalcCurr(PhysGrid1,Freq,FeedNum,Titel,DataRootDir);
end

display(Op1)

% transfer matrices:

if 1==0,
  [To1,Z1]=CalcTo(er,PhysGrid1,Op1,DataRootDir,'Matlab');
else
  [To1,Z1]=CalcTo(er,Solver,Freq,DataRootDir,'Matlab');
end

if 1==1,
  [To1_,er_,Z1_]=LoadT(DataRootDir,Solver,Freq,'To');
  isequal(To1,To1_)
  isequal(er,er_)
  isequal(Z1,Z1_)
end

C1=Z1;
for n=1:size(Z1,3),
  C1(:,:,n)=inv(Z1(:,:,n))/(j*2*pi*Op1(1,n).Freq);
end
fprintf('\nC=\n')
disp(real(C1)*1e12)

fprintf('\nmean(To)=\n')
disp(mean(To1,3))
fprintf('\nstd(To)=\n')
disp(std(To1,[],3))

To1_=car2sph(real(To1),2);
To1_(:,2:3,:)=To1_(:,2:3,:)/deg;
nnn=(To1_(:)<-160);
To1_(nnn)=To1_(nnn)+360;

fprintf('\nmean(To_spherical)=\n')
disp(mean(To1_,3))
fprintf('\nstd(To_spherical)=\n')
disp(std(To1_,[],3))

toc

end


% Solve with CONCEPT
% -------------------

if 1==1,
  
tic

Solver='CONCEPT';

Option={'ForceWires'};

PhysGrid2=GetPhysGrid(Ant_,Solver,Option,DataRootDir);

if OnlyReadCurr,
  Op2=LoadCurr(DataRootDir,PhysGrid2,Freq,FeedNum);
else
  Op2=CalcCurr(PhysGrid2,Freq,FeedNum,Titel,DataRootDir);
end

display(Op2)

% transfer matrices:

if 1==0,
  [To2,Z2]=CalcTo(er,PhysGrid2,Op2,DataRootDir,'Matlab');
else
  [To2,Z2]=CalcTo(er,Solver,Freq,DataRootDir,'Matlab');
end

if 1==1,
  [To2_,er_,Z2_]=LoadT(DataRootDir,Solver,Freq,'To');
  isequal(To2,To2_)
  isequal(er,er_)
  isequal(Z2,Z2_)
end

C2=Z2;
for n=1:size(Z2,3),
  C2(:,:,n)=inv(Z2(:,:,n))/(j*2*pi*Op2(1,n).Freq);
end
fprintf('\nC=\n')
disp(real(C2)*1e12)

fprintf('\nmean(To)=\n')
disp(mean(To2,3))
fprintf('\nstd(To)=\n')
disp(std(To2,[],3))

To2_=car2sph(real(To2),2);
To2_(:,2:3,:)=To2_(:,2:3,:)/deg;
nnn=(To2_(:)<-160);
To2_(nnn)=To2_(nnn)+360;

fprintf('\nmean(To_spherical)=\n')
disp(mean(To2_,3))
fprintf('\nstd(To_spherical)=\n')
disp(std(To2_,[],3))

toc

end

% 