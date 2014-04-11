
load TestAntOp; % loads variables Ant and Op

deg=pi/180;

Op.Feed=[195,1; 245,exp(i*pi/2); 295,exp(i*pi/4)];

AIF='asapinx.dat';
AOF='asapoutx.dat';

AsapWrite(AIF,'------ TestAntCurrent ------',Ant,Op);

AsapCall(AIF,AOF);

[Ant1,Op1]=AsapRead(AIF,AOF);

Op2=AntCurrent(Ant,Op,2,AIF,AOF,'***** TestAntCurrent ******');

