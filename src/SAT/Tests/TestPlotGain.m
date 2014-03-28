
clear all

load('Marsis1 4700');

load('Marsis1 Grid');

CalcModel.Wire=[2e-3,50e6];  % radius, conductivity

%CalcModel=GridRemove(CalcModel,[],[],[302,303]);

Op.Feed(:,2)=[0,0,1];

Op.Curr=AntCurrent(Op);

k=Kepsmu(Op);

kvec=k*[1,1,1]/sqrt(3);

[T,Ts]=AntTransfer(CalcModel,Op,kvec)

[Z,Y]=AntImpedance(CalcModel,Op); Z

Pin=PowerInput(CalcModel,Op)

[Ploss,Corr]=PowerLoss(CalcModel,Op)

%Prad=PowerRad(CalcModel,Op)

% OldFeed=[Op.Feed(:,1),abs(Op.Feed(:,2)),angle(Op.Feed(:,2))*180/pi];
% P=OldPowerInput(CalcModel.Geom,CalcModel.Desc,Op.Curr,OldFeed) 
% 
% Antn=3;
% heff=Heffect(CalcModel.Geom,CalcModel.Desc,Op.Curr,kvec);
% [m,n]=max(abs(heff)); 
% heff=heff/Y(Antn,Antn)

%return

% plots:

figure(4);

n=[61,121];
Loga=[];
Comp=[];

% OldPlotGain(CalcModel.Geom,CalcModel.Desc,Op.Curr,...
%   k,real(Pin-Ploss),[0,pi],[pi/2,3*pi/2],n,Loga,Comp);
% axis equal;

[hp,hc,ha,hco]=PlotGain(CalcModel,Op,-2,[0,pi],[0,2*pi],[30,30],[],[],1)

set(findobj(gca,'Type','surface'),'FaceColor','interp');

CM=CalcModel;
CM.Geom=CalcModel.Geom/10+repmat([2,2,0],size(CalcModel.Geom,1),1);
hold on
PlotGrid(CM,'all');
hold off

