function PlotDiagImpedances_AA_BB(solver,freq,saveflag,formatflag)

% PlotDiagImpedances_AA_BB(solver,freq,saveflag,formatflag)
% @input: solver  ...    'concept' or 'feko'
%         freq   ...     frequency in Hz
%         saveflag ...   0 - don't save figures (default)
%                        1 - save figures
%         formatflag ... 0 - 'eps' (default)
%                        1 - 'png'

if nargin < 3
    saveflag = 0;
end

if nargin < 4
    formatflag = 0; 
end

AttaInit();

global Global_Annoxybuffer
Global_Annoxybuffer = [];
close all
clc

% import impedance matrix Z

imps = zeros(numel(freq),8,8);

for k=1:numel(freq)
  [SolverDir,FreqDir] = GetDataSubdirs('../',solver,freq(k));
  Z = VarLoad(fullfile(FreqDir,'To.mat'),[],'Z');
  % mean impedance matrix
  Z = reshape(Z,8,8);
  imps(k,:,:) = reshape((Z+Z.')/2,1,8,8);
end

% define colors

covec = zeros(4,3);
covec(1:4,3) = 0.8;
covec(1:4,2) = (0:2:6)'*0.1;


%% Frequency dependence of Impedance: A1-A4
%----------------------------------------------------------------------
figure('color',[1,1,0.8],'position',[50,50,1200,900],'papertype','A4');

% plot real part of impedance
ah1 = subplot(2,1,1);
grid on
for k=1:4
  re_lh(k) = line(freq/1e6,real(imps(:,k,k)),'color',covec(k,:),'linewidth',2);
end
set(re_lh([1,4]),'linestyle','-.')
set(ah1,'xlim',[freq(1),freq(end)]/1e6)
set(ah1,'xtick',[freq(1)/1e6,get(ah1,'xtick')])
ytick = get(ah1,'ytick');
set(ah1,'ytick',ytick(2:end))
title('Impedance Z of A-antennas - Re(Z)','fontsize',14);
xlabel('Frequency [MHz]','fontsize',12)
ylabel('Re(Z) [\Omega]','fontsize',12)
legend('A1','A2','A3','A4','location','northwest')

% plot imaginary part of impedance
ah2 = subplot(2,1,2);
grid on
for k=1:4
  im_lh(k) = line(freq/1e6,imag(imps(:,k,k)),'color',covec(k,:),'linewidth',2);
end
set(im_lh([1,4]),'linestyle','-.')
set(ah2,'xlim',[freq(1),freq(end)]/1e6)
set(ah2,'xtick',[freq(1)/1e6,get(ah2,'xtick')])
set(ah2,'ylim',[-1500,500]);
ytick = get(ah2,'ytick');
set(ah2,'ytick',ytick(2:end))
title('Impedance Z of A-antennas - Im(Z)','fontsize',14);
xlabel('Frequency [MHz]','fontsize',12)
ylabel('Im(Z) [\Omega]','fontsize',12)
legend('A1','A2','A3','A4','location','northwest')


if saveflag
  if formatflag == 1
    SaveFigure(gcf,'png/ZF_AiAi',1)
  else
    SaveFigure(gcf,'eps/ZF_AiAi',0)
  end
end




%% Real vs Imaginary Part of Impedance: A1-A4
%----------------------------------------------------------------------
figure('color',[1,1,0.8],'position',[50,50,1200,900]);

% antennas A1-A3
ah1 = subplot(2,1,1);
set(ah1,'ylim',[-700,400])
hold on
Global_Annoxybuffer = [];

impmat = cat(2,imps(:,1,1),imps(:,2,2),imps(:,3,3));
[h1,h2,ht] = PlotComplex(freq/1e6,impmat,3,'','',{[],freq(10:10:end)/1e6});

set(h1,'linewidth',2)
set(h1(1),'color',covec(1,:),'linestyle','-.')
set(h1(2),'color',covec(2,:))
set(h1(3),'color',covec(3,:))

set(h2(1),'marker','o','markeredgecolor','k')
set(ht,'color','k')

ytick = get(ah1,'ytick');
set(ah1,'ytick',ytick(2:end))

title('Impedance Z of antennas Ai - Re(Z) vs. Im(Z)','fontsize',14);
xlabel('Re(Z) [\Omega]','fontsize',12)
ylabel('Im(Z) [\Omega]','fontsize',12)
legend('A1','A2','A3','location','northeast')
hold off


% antenna A4
ah2 = subplot(2,1,2);
set(ah2,'ylim',[-400,400])
hold on
Global_Annoxybuffer = [];

[h1,h2,ht] = PlotComplex(freq/1e6,imps(:,4,4),3,'','',{[],freq(10:10:end)/1e6});

set(h1,'linewidth',2,'color',covec(4,:),'linestyle','-.')
set(h2(1),'marker','o','markeredgecolor','k')
set(ht,'color','k')

ytick = get(ah2,'ytick');
set(ah2,'ytick',ytick(2:end))

title('Impedance Z of antenna A4 - Re(Z) vs. Im(Z)','fontsize',14);
xlabel('Re(Z) [\Omega]','fontsize',12)
ylabel('Im(Z) [\Omega]','fontsize',12)
legend('A4')
hold off


if saveflag
  if formatflag == 1
    SaveFigure(gcf,'png/ZZ_AiAi',1)
  else
    SaveFigure(gcf,'eps/ZZ_AiAi',0)
  end
end




%% Frequency dependence of Impedance: B1-B4
%----------------------------------------------------------------------
figure('color',[1,1,0.8],'position',[50,50,1200,900]);

% define colors
covec = zeros(4,3);
covec(1:4,3) = 0.8;
covec(1:4,2) = (0:2:6)'*0.1;

% plot real part of impedance
ah1 = subplot(2,1,1);
grid on
for k=1:4
  re_lh(k) = line(freq/1e6,real(imps(:,4+k,4+k)),'color',covec(k,:),'linewidth',2);
end
set(re_lh([1,4]),'linestyle','-.')
set(ah1,'ylim',[0,350]);
set(ah1,'xlim',[freq(1),freq(end)]/1e6)
set(ah1,'xtick',[freq(1)/1e6,get(ah1,'xtick')])
ytick = get(ah1,'ytick');
set(ah1,'ytick',ytick(2:end))
title('Impedance Z of B-antennas - Re(Z)','fontsize',14);
xlabel('Frequency [MHz]','fontsize',12)
ylabel('Re(Z) [\Omega]','fontsize',12)
legend('B1','B2','B3','B4','location','northwest')


% plot imaginary part of impedance
ah2 = subplot(2,1,2);
grid on
for k=1:4
  im_lh(k) = line(freq/1e6,imag(imps(:,4+k,4+k)),'color',covec(k,:),'linewidth',2);
end
set(im_lh([1,4]),'linestyle','-.')
set(ah2,'xlim',[freq(1),freq(end)]/1e6)
set(ah2,'xtick',[freq(1)/1e6,get(ah2,'xtick')])
set(ah2,'ylim',[-4500,0]);
ytick = get(ah2,'ytick');
set(ah2,'ytick',ytick(2:end))
title('Impedance Z of B-antennas - Im(Z)','fontsize',14);
xlabel('Frequency [MHz]','fontsize',12)
ylabel('Im(Z) [\Omega]','fontsize',12)
legend('B1','B2','B3','B4','location','northwest')


if saveflag
  if formatflag == 1
    SaveFigure(gcf,'png/ZF_BiBi',1)
  else
    SaveFigure(gcf,'eps/ZF_BiBi',0)
  end
end




%% Real vs Imaginary Part of Impedance: B1-B4
%----------------------------------------------------------------------
figure('color',[1,1,0.8],'position',[50,50,1200,900]);

% antennas B1-B3
ah1 = subplot(2,1,1);
set(ah1,'ylim',[-3000,0])
hold on
Global_Annoxybuffer = [];

impmat = cat(2,imps(:,5,5),imps(:,6,6),imps(:,7,7));
[h1,h2,ht] = PlotComplex(freq/1e6,impmat,3,'','',{[],freq(10:10:end)/1e6});

set(h1,'linewidth',2)
set(h1(1),'color',covec(1,:),'linestyle','-.')
set(h1(2),'color',covec(2,:))
set(h1(3),'color',covec(3,:))

set(h2(1),'marker','o','markeredgecolor','k')
set(ht,'color','k')

ytick = get(ah1,'ytick');
set(ah1,'ytick',ytick(2:end))

title('Impedance Z of antennas Bi - Re(Z) vs. Im(Z)','fontsize',14);
xlabel('Re(Z) [\Omega]','fontsize',12)
ylabel('Im(Z) [\Omega]','fontsize',12)
legend('B1','B2','B3','location','northeast')
hold off


% antenna B4
ah2 = subplot(2,1,2);
set(ah2,'ylim',[-3000,0]);
hold on
Global_Annoxybuffer = [];

[h1,h2,ht] = PlotComplex(freq/1e6,imps(:,8,8),3,'','',{[],freq(10:10:end)/1e6});

set(h1,'linewidth',2,'color',covec(4,:),'linestyle','-.')

set(h2(1),'marker','o','markeredgecolor','k')
set(ht,'color','k')

ytick = get(ah2,'ytick');
set(ah2,'ytick',ytick(2:end))

title('Impedance Z of antenna B4 - Re(Z) vs. Im(Z)','fontsize',14);
xlabel('Re(Z) [\Omega]','fontsize',12)
ylabel('Im(Z) [\Omega]','fontsize',12)
legend('B4')
hold off


if saveflag
  if formatflag == 1
    SaveFigure(gcf,'png/ZZ_BiBi',1)
  else
    SaveFigure(gcf,'eps/ZZ_BiBi',0)
  end
end
