
% TestMMSolver.m

if 0==1,
  
  load('testantop');
  
  Op.Feed=[245,295,195; 1,1,1]';
  
else
  
  Ant=GridInit;
  Ant.Geom=[];
  Ant.Geom(:,3)=[-10:2:10]';
  Ant.Geom(end+1,:)=[10,15,10];
  Ant.Geom(end+1,:)=[10,-7,10];
  Ant.Geom(end+1,:)=[5,-5,-5];
  
  Ant.Desc=[1:10]';
  Ant.Desc(:,2)=Ant.Desc(:,1)+1;
  Ant.Desc(end+1,:)=[11,12];
  Ant.Desc(end+1,:)=[13,11];
  Ant.Desc(end+1,:)=[8,14];
  
  Ant.Desc(end+1,:)=[13,14];
   
  Ant.Desc(end+1,:)=[13,8];
  Ant.Desc(end+1,:)=[14,3]; 
  Ant.Desc(end+1,:)=[12,13]; 
  
  Op.Feed=[9,1];
  
end

Ant.Wire=[2e-3,5e6];
Op.Freq=0.3e6;
Op.Exte=[0,1];
Op.Inte=200;

  
if 1==1,
tic
[CurrSys,DescDip,CurrDip,Z,K,V]=MMSolver(Ant,Op);
Op.CurrSys=CurrSys;
toc
end

tic
Op1=AntCurrent(Ant,Op,2,'test.i','test.o');
toc

save test Ant Op Op1

C=shiftdim(CurrSys(1,:,:))
C1=shiftdim(Op1.CurrSys(1,:,:))
real(C-C1)./real(C)
imag(C-C1)./imag(C)
abs((C-C1)./C)
max(abs((C-C1)./C))

if 1==0,
  CCdip=-(K+K.')\V*2;
  CC=MMConvCurr(DescDip,CCdip(:,1));
  max(abs((C1-CC)./CC))
  max(abs((C-CC)./CC))
%   real(C2-C1)./real(C2)
%   imag(C2-C1)./imag(C2)
%   abs((C2-C1)./C2)
%   real(C-C2)./real(C)
%   imag(C-C2)./imag(C)
%   abs((C-C2)./C)
end

