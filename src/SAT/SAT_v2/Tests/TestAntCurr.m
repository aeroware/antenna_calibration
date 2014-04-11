
load TestAntOp;

Op.Feed=[195,0; 245,0; 295,0];
f=size(Op.Feed,1);
Op.Feed(:,2)=rand(f,1)+i*rand(f,1);

Op=AntCurrent(Ant,Op,2)

C0=Op.Curr;

C1=AntCurrent(Op);

C2=AntCurr(Ant,Op,'V',Op.Feed(:,2));

max(abs(C1-C0)./abs(C0))

max(abs(C2-C0)./abs(C0))
max(abs(real(C2-C0)./real(C0)))
max(abs(imag(C2-C0)./imag(C0)))


I=rand(f,1)+i*rand(f,1);
[Z,Y]=AntImpedance(Ant,Op);
V=Z*I;
C3=AntCurr(Ant,Op,'V',V);
C4=AntCurr(Ant,Op,'I',I);

max(abs(C3-C4)./abs(C4))
max(abs(real(C3-C4)./real(C4)))
max(abs(imag(C3-C4)./imag(C4)))


er=rand(50,3)-0.5;

[T,Ts]=AntTransfer(Ant,Op,er);

Op.CurrSys=AntCurr(Ant,Op);
[T1,Ts1]=AntTransfer(Ant,Op,er);

max(abs(T-Ts1)./abs(T),[],3)


