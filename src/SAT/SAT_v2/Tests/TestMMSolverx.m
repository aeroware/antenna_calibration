
% TestMMSolver.m

if 0==1,
  
  load('grids\tests\testantop');
  
  Op.Feed=[245,295,195; 1,1,1]';
  Op.Inte=200;
  
else
  
  Ant=GridInit;
  Ant.Geom=[];
  Ant.Geom(:,3)=[-5:5]';
  Ant.Geom(end+1,:)=[1,1,1];
  Ant.Geom(end+1,:)=[1,-1,1];
  Ant.Desc=[1:10]';
  Ant.Desc(:,2)=Ant.Desc(:,1)+1;
   Ant.Desc(end+1,:)=[11,12];
   Ant.Desc(end+1,:)=[11,13];
%   Ant.Desc(end+1,:)=[13,8];
   
  
  Ant.Wire=[2e-3,50e6];
  
  Op.Freq=500e3;
  Op.Feed=[size(Ant.Geom,1)/2+1/2,1];
  Op.Exte=[0,1];
  Op.Inte=200;
  
end

tic
[CurrSys,DescDip,CurrDip,K,V,W,Ep,r,c]=MMSolver(Ant,Op,4,2);
toc
C=shiftdim(CurrSys(1,:,:))

tic
Op1=AntCurrent(Ant,Op,2,'test.i','test.o');
toc
C1=shiftdim(Op1.CurrSys(1,:,:))

imag(C-C1)./imag(C)
real(C-C1)./real(C)
