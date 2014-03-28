
function PlotZ(f,Z,Y)

if isempty(Z),
  Z=Y;
  for k=1:size(Y,1),
    Z(k,:,:)=shiftdim(inv(shiftdim(Y(k,:,:))),-1);
  end
end

if (nargin<3)|isempty(Y),
  Y=Z;
  for k=1:size(Z,1),
    Y(k,:,:)=shiftdim(inv(shiftdim(Z(k,:,:))),-1);
  end
end


if size(Z,2)==1,

  figure(5);
  subplot(2,1,1);
  plot(f,real(Z),'-')
  grid on;
  xlabel('f [Hz]');
  ylabel('R [Ohms]');
  title('Impedance (Z=R+jX)');
  subplot(2,1,2);
  plot(f,imag(Z),'-')
  grid on;
  xlabel('f [Hz]');
  ylabel('X [Ohms]');
  
  figure(6);
  subplot(2,1,1);
  plot(f,real(Y),'-')
  grid on;
  xlabel('f [Hz]');
  ylabel('G [Ohms]');
  title('Admittance (Y=G+jB)');
  subplot(2,1,2);
  plot(f,imag(Y),'-')
  grid on;
  xlabel('f [Hz]');
  ylabel('B [Ohms]');
  
  return
  
end

figure(1);
subplot(2,1,1);
plot(f(:),real(Z(:,1,1)),'r-',f(:),real(Z(:,2,2)),'--',f(:),real(Z(:,3,3)),'-.');
xlabel('f [Hz]');
ylabel('R [Ohms]');
title('Self-impedances (Z=R+jX) of antenna 3-port (monopole and 2 dipole arms)');
grid on;
subplot(2,1,2);
plot(f(:),imag(Z(:,1,1)),'r-',f(:),imag(Z(:,2,2)),'--',f(:),imag(Z(:,3,3)),'-.');
legend('Z_{11}','Z_{22}','Z_{33}');
xlabel('f [Hz]');
ylabel('X [Ohms]');
grid on;

figure(2);
subplot(2,1,1);
plot(f(:),real(Z(:,1,2)),'-.',f(:),real(Z(:,1,3)),'--',f(:),real(Z(:,2,3)),'-');
xlabel('f [Hz]');
ylabel('R [Ohms]');
title('Mutual impedances (Z=R+jX) of antenna 3-port (monopole and 2 dipole arms)');
grid on;
subplot(2,1,2);
plot(f(:),imag(Z(:,1,2)),'-.',f(:),imag(Z(:,1,3)),'--',f(:),imag(Z(:,2,3)),'-');
legend('Z_{12}','Z_{13}','Z_{23}');
xlabel('f [Hz]');
ylabel('X [Ohms]');
grid on;

figure(3);
subplot(2,1,1);
plot(f(:),real(Y(:,1,1)),'r-',f(:),real(Y(:,2,2)),'--',f(:),real(Y(:,3,3)),'-.');
xlabel('f [Hz]');
ylabel('G [Ohms]');
title('Self-admittances (Y=G+jB) of antenna 3-port (monopole and 2 dipole arms)');
grid on;
subplot(2,1,2);
plot(f(:),imag(Y(:,1,1)),'r-',f(:),imag(Y(:,2,2)),'--',f(:),imag(Y(:,3,3)),'-.');
legend('Y_{11}','Y_{22}','Y_{33}');
xlabel('f [Hz]');
ylabel('B [Ohms]');
grid on;

figure(4);
subplot(2,1,1);
plot(f(:),real(Y(:,1,2)),'-.',f(:),real(Y(:,1,3)),'--',f(:),real(Y(:,2,3)),'-');
xlabel('f [Hz]');
ylabel('G [Ohms]');
title('Mutual admittances (Y=G+jB) of antenna 3-port (monopole and 2 dipole arms)');
grid on;
subplot(2,1,2);
plot(f(:),imag(Y(:,1,2)),'-.',f(:),imag(Y(:,1,3)),'--',f(:),imag(Y(:,2,3)),'-');
legend('Y_{12}','Y_{13}','Y_{23}');
xlabel('f [Hz]');
ylabel('B [Ohms]');
grid on;

% return

% compare with impedance measurements:
% ------------------------------------

load DipoleImp.txt
DipoleImp(:,1)=DipoleImp(:,1)*1e6;
DipoleY=1./(DipoleImp(:,2)+j*DipoleImp(:,3));

% figure(1);
% subplot(2,1,1);
% hold on;
% plot(DipoleImp(:,1),DipoleImp(:,2),'.b')
% hold off;
% subplot(2,1,2);
% hold on;
% plot(DipoleImp(:,1),DipoleImp(:,3),'.b')
% hold off;
% 
% figure(3);
% subplot(2,1,1);
% hold on;
% plot(DipoleImp(:,1),real(DipoleY),'.b')
% hold off;
% subplot(2,1,2);
% hold on;
% plot(DipoleImp(:,1),imag(DipoleY),'.b')
% hold off;

Cmount=0e-12;   % capacitance of mounting structure

for k=1:size(Y,1),
  Y(k,:,:)=Y(k,:,:)+shiftdim(eye(3)*j*2*pi*f(k)*Cmount,-1);
  Z(k,:,:)=shiftdim(inv(shiftdim(Y(k,:,:))),-1);
end

ZZ=Z(:,2,2)-Z(:,2,3)-Z(:,3,2)+Z(:,3,3);
figure(5);
subplot(2,1,1);
plot(DipoleImp(:,1),DipoleImp(:,2),'.',...
  f,real(ZZ)/2,'-')
grid on;
xlabel('f [Hz]');
ylabel('R [Ohms]');
title('Impedance (Z=R+jX) of dipole per arm = (Z_{22}+Z_{33}-Z_{23}-Z_{32})/2');
subplot(2,1,2);
plot(DipoleImp(:,1),DipoleImp(:,3),'.',...
  f,imag(ZZ)/2,'-')
grid on;
xlabel('f [Hz]');
ylabel('X [Ohms]');
legend('Measurements','Model');

figure(6);
subplot(2,1,1);
plot(DipoleImp(:,1),real(DipoleY(:)),'.',...
  f,real(1./ZZ)/2,'-')
grid on;
xlabel('f [Hz]');
ylabel('G [Ohms]');
title('Admittance (Y=G+jB) of dipole per arm = 2/(Z_{22}+Z_{33}-Z_{23}-Z_{32})');
subplot(2,1,2);
plot(DipoleImp(:,1),imag(DipoleY(:)),'.',...
  f,imag(1./ZZ)/2,'-')
grid on;
xlabel('f [Hz]');
ylabel('B [Ohms]');
legend('Measurements','Model');

%-----------------

figure(7);
q=3;
plot(f(:),[real(1./Y(:,q,q)),imag(1./Y(:,q,q))])
grid on

