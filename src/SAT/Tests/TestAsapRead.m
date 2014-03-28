
load TestAntOp;

iFile='asapinx.dat';
oFile='asapoutx.dat';
C='';

AsapWrite(iFile,C,Ant,Op);

AsapCall(iFile,oFile);

[Ant1,Op1]=AsapRead(iFile,oFile);

