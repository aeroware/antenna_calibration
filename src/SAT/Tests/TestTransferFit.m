
% TestTransferFit


deg=pi/180;

load TestAntOp;
Ant=GridInit(Ant);

if 1==1,
  
  load TestOp;
  nf=length(Op);
  Freq={Op.Freq};
  feeds=length(Freq);
  w=2*pi*cat(1,Freq{:});
  
else  % create Op
    
  Op.Feed=[195,1; 245,exp(i*pi/2); 295,exp(i*pi/4)];
  feeds=size(Op.Feed,1);
  
  % feed nodes:    195,245,295 (for z,+x,-x)
  % feed segments: 375,378,381
  
  AIF='asapinx.dat';
  AOF='asapoutx.dat';
    
  Freq=(0.1:0.1:2.1)*1e6;  % frequencies to be analyzed
  w=2*pi*Freq;
  Freq=num2cell(Freq);
  nf=length(w);
  
  Op(1:nf)=Op(1);
  [Op.Freq]=deal(Freq{:});
  
  if ~isfield(Op,'CurrSys'),
    Op(1).CurrSys=[];
    Op(1).Curr=[];
    for m=1:nf,
      fprintf(1,'\nFrequency = %f MHz\n',Freq{m}/1e6);
      Op(m)=AntCurrent(Ant,Op(m),2,AIF,AOF,'***** TestTransferFit *****');
    end
    save TestOp Op
  end
  
end


n=2;                 % order of polynomial fit

if 1==0, % create
  e=[eye(3);-eye(3)];  % radiation directions
  rand('state',0);
  e=[e;2*rand(50,3)-1]; 
  e=e./repmat(Mag(e,2),[1,3]);
  
  To=[];
  
  [Tp,dTp,Tc,dTc,dTc_p,To]=TransferFit(Ant,Op,To,e,n);
  
  save TestTo To e
else
  load TestTo
end

nd=size(e,1);

jk=j*Kepsmu(Op);
  
nf=3:length(jk);
Op=Op(nf);
To=To(nf,:,:,:);
jk=jk(nf);
w=w(nf);
nf=length(nf);  

[Tp,dTp,Tc,dTc,dTc_p,To]=TransferFit(Ant,Op,To,e,n);

s=size(To);

disp dTp./To
disp(shiftdim(max(max((dTp./To),[],1),[],4)))
disp(shiftdim(max(max(Mag(dTp,3)./Mag(To,3),[],1),[],4)))

q=0:2; f=length(jk); Tof=To(1:f,:,:,:);
disp PolyValM(Tp,jk,q)-To)./To
disp(shiftdim(max(max((PolyValM(Tp,jk(1:f),q)-Tof)./Tof,[],1),[],4)))
disp(shiftdim(max(max(Mag(PolyValM(Tp,jk(1:f),q)-Tof,3)./Mag(Tof,3),[],1),[],4)))

disp dTc_p(1,:,:,:)./Tp(1,:,:,:)
%disp(shiftdim(max(max(dTc_p(1,:,:,:)./Tp(1,:,:,:),[],1),[],4)))
disp(shiftdim(max(max(Mag(dTc_p(1,:,:,:),3)./Mag(Tp(1,:,:,:),3),[],1),[],4)))

disp dTc_p(2,:,:,:)./Tp(2,:,:,:)
%disp(shiftdim(max(max(dTc_p(2,:,:,:)./Tp(2,:,:,:),[],1),[],4)))
disp(shiftdim(max(max(Mag(dTc_p(2,:,:,:),3)./Mag(Tp(2,:,:,:),3),[],1),[],4)))
    
disp dTc./To
f=1:8;
%disp(shiftdim(max(max((dTc(f,:,:,:)./To(f,:,:,:)),[],1),[],4)))
disp(shiftdim(max(max(Mag(dTc(f,:,:,:),3)./Mag(To(f,:,:,:),3),[],1),[],4)))

disp repmat(shiftdim(Tc{2,1},-1).*repmat(jk,[1,s(2:end)]),[nf,1,1,nd]))./To
%disp(shiftdim(max(max((repmat(shiftdim(Tc{1,1},-1),[nf,1,1,nd]))./To,[],1),[],4)))
disp(shiftdim(max(max(Mag(repmat(shiftdim(Tc{1,1},-1),[nf,1,1,nd]).*repmat(jk(:),[1,s(2:end)]),3)./Mag(To,3),[],1),[],4)))

np=0:1; nf=8; jk=jk(:).'; s(1)=nf; %Tc{2,2}=Tc{2,2}*0;
disp '(shiftdim(TransferVal(Tc,e,jk(f)),-1)-To(f,:,:,:))./To(f,:,:,:)'
tv=shiftdim(reshape(TransferVal(Tc,repmat(e,nf,1),reshape(repmat(jk(1:nf),nd,1),nd*nf,1),np),s([2,3,4,1])),3);
disp(shiftdim(max(max(Mag(tv-To(1:nf,:,:,:),3)./Mag(To(1:nf,:,:,:),3),[],1),[],4)))

return

%f=3;c=1;Ta=shiftdim(TransferVal(Tc,e,jk(:).'),3);for k=1:nd,plot(w(:)/2/pi,[real(To(:,f,c,k)),imag(To(:,f,c,k)),real(Ta(:,f,c,k)),imag(Ta(:,f,c,k))]);title(num2str(k));pause,end

