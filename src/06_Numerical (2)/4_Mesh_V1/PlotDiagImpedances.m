%function PlotDiagImpedances(solver,freq,saveflag,formatflag)

% PlotDiagImpedances_AA_BB(solver,freq,saveflag,formatflag)
% @input: solver  ...    'concept' or 'feko'
%         freq   ...     frequency in Hz
%         saveflag ...   0 - don't save figures (default)
%                        1 - save figures
%         formatflag ... 0 - 'eps' (default)
%                        1 - 'png'

freq = [1 5 10 10.5 11 11.5 12 12.5 13 13.5 14 14.5 15 ...
    15.5 16 16.5 17 17.5 18 18.5 19 19.5 20 20.5 21 21.5 ...
    22 22.5 23 23.5 24 24.5 25 25.5 26 26.5 27 27.5 28 ...
    28.5 29 29.5 30 30.5 31 31.5 32 32.5 33 33.5 34 34.5 ...
    35 35.5 36 36.5 37 37.5 38 38.5 39 39.5 40]*1e6;

solver='Feko';
saveflag = 0;
formatflag = 0; 
DataRootDir='';

AttaInit();

global Global_Annoxybuffer
Global_Annoxybuffer = [];
close all
clc

% import impedance matrix Z

imps = zeros(numel(freq),2,2);




for k=1:numel(freq)
  [T,er,Z] = LoadT(DataRootDir,solver,freq(k),'To.mat');
  % mean impedance matrix
  Z = reshape(Z,2,2);
  imps(k,:,:) = reshape(Z,1,2,2);
end



%% Frequency dependence of Impedance: A1-A2
%----------------------------------------------------------------------
figure('color',[1,1,0.8],'position',[50,50,1200,900],'papertype','A4');

% plot real part of impedance
ah1 = subplot(2,1,1);
grid on
for k=1:2
  re_lh(k) = line(freq/1e6,real(imps(:,k,k)),'linewidth',1);
end

set(re_lh([1]),'color','blue');
set(re_lh([2]),'color','red');


set(ah1,'xlim',[freq(1),freq(end)]/1e6)
set(ah1,'xtick',[freq(1)/1e6,get(ah1,'xtick')])
ytick = get(ah1,'ytick');
set(ah1,'ytick',ytick(2:end))
title('Impedance Z of A-antennas - Re(Z)','fontsize',14);
xlabel('Frequency [MHz]','fontsize',12)
ylabel('Re(Z) [\Omega]','fontsize',12)
legend('A1','A2','location','northwest')

% plot imaginary part of impedance
ah2 = subplot(2,1,2);
grid on
for k=1:2
  im_lh(k) = line(freq/1e6,imag(imps(:,k,k)),'linewidth',1);
end

set(im_lh([1]),'color','blue');
set(im_lh([2]),'color','red');

set(ah2,'xlim',[freq(1),freq(end)]/1e6)
set(ah2,'xtick',[freq(1)/1e6,get(ah2,'xtick')])
set(ah2,'ylim',[-1500,500]);
ytick = get(ah2,'ytick');
set(ah2,'ytick',ytick(2:end))
title('Impedance Z of A-antennas - Im(Z)','fontsize',14);
xlabel('Frequency [MHz]','fontsize',12)
ylabel('Im(Z) [\Omega]','fontsize',12)
legend('A1','A2','location','northwest')


if saveflag
  if formatflag == 1
    SaveFigure(gcf,'png/ZF_AiAi',1)
  else
    SaveFigure(gcf,'eps/ZF_AiAi',0)
  end
end




%% Real vs Imaginary Part of Impedance: A1-A2
%----------------------------------------------------------------------
figure('color',[1,1,0.8],'position',[50,50,1200,900]);

% antennas A1-A3
ah1 = subplot(2,1,1);
set(ah1,'ylim',[-700,400])
hold on
Global_Annoxybuffer = [];

impmat = cat(2,imps(:,1,1),imps(:,2,2));
[h1,h2,ht] = PlotComplex(freq/1e6,impmat,3,'','',{[],freq(10:10:end)/1e6});

set(h1(1),'color','blue');
set(h1(2),'color','red');


set(h2(1),'marker','o','markeredgecolor','k')
set(ht,'color','k')

ytick = get(ah1,'ytick');
set(ah1,'ytick',ytick(2:end))

title('Impedance Z of antennas Ai - Re(Z) vs. Im(Z)','fontsize',14);
xlabel('Re(Z) [\Omega]','fontsize',12)
ylabel('Im(Z) [\Omega]','fontsize',12)
legend('A1','A2','location','northeast')
hold off




if saveflag
  if formatflag == 1
    SaveFigure(gcf,'png/ZZ_AiAi',1)
  else
    SaveFigure(gcf,'eps/ZZ_AiAi',0)
  end
end


