% mcPlotImpedance

% mcPlotImpedance is a routine which plots the real and imaginary parts of
% the input impedance as a function of frequency.
clear
% input parameters

nSegs=801;
antLength=6;
antRadius=5e-3;
feed=401;

f=10.1e6:5e5:100e6;
freqrelsqu=0.5;
f_pe=10e6;
ioneffect=0;
integral=1;
inte=50;

% create grid

ant=mcCreateDipole(nSegs,antLength,antRadius);

% compute impedance

imp=zeros(length(f));
impp=zeros(length(f));

for n=1:length(f)
    fprintf('\nf= %6d\n',f(n))
    freqrelsqu=(f_pe/f(n))^2;
    [cs,imp(n)]=mcGetSinCurrent(ant,f(n),0,ioneffect,1);
    [cs,impp(n)]=mcGetSinCurrent(ant,f(n),freqrelsqu,ioneffect,1);
end

figure
plot(f,real(imp),'b');
line(f,real(impp),'color','r');
title('Real part of the input impedance');
xlabel('Frequency [Hz]');
ylabel('Impedance [ohms]');
legend('Vacuum','Plasma');

figure
plot(f,imag(imp),'b');
line(f,imag(impp),'color','r');
title('Imaginary part of the input impedance');
xlabel('Frequency [Hz]');
ylabel('Impedance [ohms]');
legend('Vacuum','Plasma');