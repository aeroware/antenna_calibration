% *************************************************************************
% 0.50 - 27.05.2011:  
% 
% determines He from FEKO out file
% 
% *************************************************************************
AttaInit;

clear all
WorkingDir=pwd;

LoadPath='Feko';  % where PhysGrid is to be expected
load(fullfile(LoadPath,'PhysGrid'));

Freq = 300e3;

r = 50e3;         % distance for the nearfield -- see FE card FEKO

[k,epsi,mu]=Kepsmu(Freq,PhysGrid);

% -------------------------------------------------------------------------
% calculate: Feed A1
Atta_Feko_out=('Feko/kHz_000300/Feed_1/antfile.out');

[AA,f]=FEKO_get_A(Atta_Feko_out,WorkingDir, 1);

IA=getFekoFeedCurrent(WorkingDir,Atta_Feko_out);

he = AA /((mu/(4*pi))*(exp(-i*k*r)/r)*IA );

he_A1 = real(mean(he',3));

he_sph_A1 = car2sph(he_A1,2);
he_sph_d_A1 = [he_sph_A1(:,1),he_sph_A1(:,2:3)*180/pi]

%  Result:
%
%  heff_sph_d = 1.4882  134.4313   48.1720
%  Capacitance in F  3.1645E-11
%
%                     VALUES OF THE CURRENT IN THE SEGMENTS in A
% 
% Segment        centre                                      IX                IY                IZ
% number           x/m          y/m          z/m      magn.    phase    magn.    phase    magn.    phase
%         1   1.41449E+00  2.31416E-01 -1.11647E+00 2.113E-05   90.00 5.164E-05   90.00 2.108E-05  -90.00
%         2   1.41449E+00 -2.31417E-01 -1.11647E+00 3.372E-07  -90.00 8.243E-07   90.00 3.365E-07   90.00
%
% I_seg_2 = IX+IY+IZ = 825.0E-9 A /-90 grad
% gC = I_seg_1/(j*omega) 
% gC = 4.3768e-13 (matlab)

% -------------------------------------------------------------------------
% calculate: Feed A2

Atta_Feko_out=('Feko/kHz_000300/Feed_2/ant.out');

[AA,f]=FEKO_get_A(Atta_Feko_out,WorkingDir, 1);

IA=getFekoFeedCurrent(WorkingDir,Atta_Feko_out);

he = AA /((mu/(4*pi))*(exp(-i*k*r)/r)*IA );

he_A2 = real(mean(he',3));

he_sph_A2 = car2sph(he_A2,2);
he_sph_d_A2 = [he_sph_A2(:,1),he_sph_A2(:,2:3)*180/pi]

% Result:
%
% heff_sph_d = 1.4818  134.4454  -48.2380
% Capacitance in F  3.1686E-11

%                     VALUES OF THE CURRENT IN THE SEGMENTS in A
% 
% Segment        centre                                      IX                IY                IZ
% number           x/m          y/m          z/m      magn.    phase    magn.    phase    magn.    phase
%         1   1.41449E+00  2.31416E-01 -1.11647E+00 3.372E-07  -90.00 8.243E-07  -90.00 3.365E-07   90.00
%         2   1.41449E+00 -2.31417E-01 -1.11647E+00 2.116E-05   90.00 5.171E-05  -90.00 2.111E-05  -90.00
%
% I_seg_1 = IX+IY+IZ = 825.0E-9 A /-90 grad
% gC = I_seg_1/(j*omega) 
% gC = 4.3768e-13 (matlab)

% -------------------------------------------------------------------------
% save('he_FEKO_300kHz.mat');
