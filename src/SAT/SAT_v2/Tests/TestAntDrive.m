
% TestAntDrive
% ------------


% [VIR_Vo,VIR_G]=AntDrive(YA,QV,QI,QG,QR,Vo,G)
% [V,I,R]=AntDrive(QG,Y,QR,G,Vo)

m=2000;
r=2;
f=3;
YA=rand(f,f,m);
 QV=rand(f+r,f,m);
%QV=rand(1,f,m);

 QI=rand(f+r,f,m);
%QI=rand(1,f,m);

QG=[repmat(-eye(3),[1,1,m]);zeros(r,f,m)];
QR=[zeros(f,r,m);-repmat(eye(r),[1,1,m])];

n=15;
Vo=rand(f,n);
G=rand(f,n);

[VIR_Vo,VIR_G,c]=AntDrive(YA,QV,QI,QG,QR);
%[VIR_G,VIR_Vo]

clear V I R

for k=1:m,
  
  [V(:,:,k),I(:,:,k),R(:,:,k)]=...
    AntDrive0([QV(1:f,:,k),QI(1:f,:,k)],YA(:,:,k),...
              [QV(f+1:f+r,:,k),QI(f+1:f+r,:,k)]);

%     [V(:,:,k),I(:,:,k),R(:,:,k)]=...
%     AntDrive0([diag(QV(1,:,k)),diag(QI(1,:,k))],YA(:,:,k),...
%               [zeros(r,2*f)]);
%           
            
end
VIR=[V;I;R];

d=abs([VIR_G,VIR_Vo]./VIR-1);
max(d(:))
