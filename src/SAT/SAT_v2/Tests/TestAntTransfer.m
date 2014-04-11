
% TestAntTransfer.m

deg=pi/180;

load TestAntOp;
Ant=GridInit(Ant);

Op.Feed=[195,1; 245,exp(i*pi/2); 295,exp(i*pi/4)];

% feed nodes:    195,245,295 (for z,+x,-x)
% feed segments: 375,378,381

AIF='asapinx.dat';
AOF='asapoutx.dat';

if ~exist('Op1','var'),
  Op1=AntCurrent(Ant,Op,2,AIF,AOF,'***** TestAntTransfer *****');
end

[Z,Y]=AntImpedance(Ant,Op1)


if 1==1,

s=size(Op1.CurrSys);
C=reshape(Z.'*reshape(Op1.CurrSys,[s(1),prod(s(2:end))]),s);

Op2=Op1;
Op2.CurrSys=C;
Op2.Curr=[];

ZL=[];

er=[1,0,0; 0,1,0; 0,0,1; 1,1,1];

[To2,Ts2]=AntTransfer(Ant,Op2,er,ZL);
Tsr=real(Ts2);
Tor=real(To2);
[ths,phis,rs]=cart2sph(Tsr(:,1,:),Tsr(:,2,:),Tsr(:,3,:));
[tho,phio,ro]=cart2sph(Tor(:,1,:),Tor(:,2,:),Tor(:,3,:));
cat(2,rs,90-phis/deg,ths/deg)
cat(2,rs,90-phio/deg,tho/deg)

% To=Ts=
%   5.0656e+000  3.4910e+001  8.6218e+001
%   4.8613e+000  1.0196e+002  2.3335e+001
%   4.5902e+000  1.0332e+002  1.5487e+002

return

end



ZL=[];

er=[1,0,0; 0,1,0; 0,0,1];

[To,Ts]=AntTransfer(Ant,Op1,er,ZL);
Tsr=real(Ts);
Tor=real(To);
[ths,phis,rs]=cart2sph(Tsr(:,1,:),Tsr(:,2,:),Tsr(:,3,:));
[tho,phio,ro]=cart2sph(Tor(:,1,:),Tor(:,2,:),Tor(:,3,:));
cat(2,rs,90-phis/deg,ths/deg)
cat(2,ro,90-phio/deg,tho/deg)

return

Antz=GridRemove(Ant,[],[],[378,381]);
Op.Feed=[195,1];
Opz=AntCurrent(Antz,Op,1,AIF,AOF,'***** TestAntTransfer *****');
[To,Ts]=AntTransfer(Antz,Opz,er,ZL);
Tsr=real(Ts);
Tor=real(To);
[ths,phis,rs]=cart2sph(Tsr(:,1,:),Tsr(:,2,:),Tsr(:,3,:));
[tho,phio,ro]=cart2sph(Tor(:,1,:),Tor(:,2,:),Tor(:,3,:));
cat(2,rs,90-phis/deg,ths/deg)
cat(2,ro,90-phio/deg,tho/deg)


Antx=GridRemove(Ant,[],[],[375,381]);
Op.Feed=[245,1];
Opx=AntCurrent(Antx,Op,1,AIF,AOF,'***** TestAntTransfer *****');
[To,Ts]=AntTransfer(Antx,Opx,er,ZL);
Tsr=real(Ts);
Tor=real(To);
[ths,phis,rs]=cart2sph(Tsr(:,1,:),Tsr(:,2,:),Tsr(:,3,:));
[tho,phio,ro]=cart2sph(Tor(:,1,:),Tor(:,2,:),Tor(:,3,:));
cat(2,rs,90-phis/deg,ths/deg)
cat(2,ro,90-phio/deg,tho/deg)

Antx_=GridRemove(Ant,[],[],[375,378]);
Op.Feed=[295,1];
Opx_=AntCurrent(Antx_,Op,1,AIF,AOF,'***** TestAntTransfer *****');
[To,Ts]=AntTransfer(Antx_,Opx_,er,ZL);
Tsr=real(Ts);
Tor=real(To);
[ths,phis,rs]=cart2sph(Tsr(:,1,:),Tsr(:,2,:),Tsr(:,3,:));
[tho,phio,ro]=cart2sph(Tor(:,1,:),Tor(:,2,:),Tor(:,3,:));
cat(2,rs,90-phis/deg,ths/deg)
cat(2,ro,90-phio/deg,tho/deg)

return

% Ts:
%   5.0342e+000  2.9246e+001  8.6895e+001
%   5.1140e+000  1.0582e+002  1.6109e+001
%   4.9003e+000  1.0691e+002  1.6266e+002
% To:
%   5.0656e+000  3.4910e+001  8.6218e+001
%   4.8613e+000  1.0196e+002  2.3335e+001
%   4.5902e+000  1.0332e+002  1.5487e+002
% T removed segments:  
%   5.0685e+000  3.4929e+001  8.6212e+001
%   4.8583e+000  1.0194e+002  2.3363e+001
%   4.5867e+000  1.0329e+002  1.5484e+002

