
% TestAntImped.m

load TestAntOp;

Op.Feed=[195,1; 245,exp(i*pi/2); 295,exp(i*pi/4)];

AIF='asapinx.dat';
AOF='asapoutx.dat';

if ~exist('Op1','var'),
  Op1=AntCurrent(Ant,Op,2,AIF,AOF,'***** TestAntImped *****');
end

[Z,Y]=AntImped(Ant,Op1)
