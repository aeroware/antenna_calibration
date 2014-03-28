clear all

WorkingDir=pwd;

Method = 'FEKO';

Atta_Feko_out='antfile.out';

load('testcube.mat') 

[AA,f]=FEKO_get_A(Atta_Feko_out,WorkingDir, 1)

m = 1;
n = 1;

Op(m,n).Freq = 300e3 

% Op(1,nf).Vfeed=GetFeedVolt(PhysGrid,FeedNum);

r = 50;

[k,epsi,mu]=Kepsmu(Op(m,n).Freq,PhysGrid) ;

IA=getFekoFeedCurrent(WorkingDir,Atta_Feko_out);

he = AA /((mu/(4*pi))*(exp(+i*k*r)/r)*IA )
% he = AA /((mu/4*pi)*IA )

heff = real(mean(he',3));

heff_sph = car2sph(heff,2);
heff_sph_d = [heff_sph(:,1),heff_sph(:,2:3)*180/pi]

% [To,Z]=CalcTo(er,PhysGrid,Op,DataRootDir,Method)

