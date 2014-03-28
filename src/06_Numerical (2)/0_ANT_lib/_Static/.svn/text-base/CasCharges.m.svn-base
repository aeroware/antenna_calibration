
% Calculate charge distribution system and grand capacitance 
% matrix for Cassini wiregrid model.
% -----------------------------------------------------------

tic

deg=pi/180;

load Cas1a_Grid;

Grid.Desc2d_.Body=[];

fprintf('---------------------------------\n');

% remove CDA:

if 1==1,
  Grid=GridRemove(Grid,[],[],1045:1095);
  fprintf('CDA removed from grid model!\n\n');
end

% search for monopole elements:

FeedNodes=[162,165,159];  % u-, v- and w-antenna

ConSegs=[301,302, 306,309,303];

[Mnodes,Msegs,Mlen]=FindMonopoles(Grid.Desc,FeedNodes);

FeedSegs=zeros(1,3);
for  m=1:3,
  Msegs{m}=abs(Msegs{m}{1}(:)).';
  FeedSegs(m)=Msegs{m}(1);
end

% set wire radii:

Nsegs=size(Grid.Desc,1);

Grid.Desc_.Diam=ones(Nsegs,1)*4e-2;         % wire diameters for surface mesh
Grid.Desc_.Diam([Msegs{:},ConSegs])=0.0286; % wire diameters of antennas and connections
Grid.Desc_.Diam([Msegs{:}])=0.0286;

% define bodies:

Grid.Desc_.Body=ones(Nsegs,1)*4;
for m=1:3,
  Grid.Desc_.Body(Msegs{m})=m;
end

Grid.Static.GroundBody=4;

Grid.Exterior.epsr=1.0;

% solve for charges and capacitances:

Grid=StaticSolve(Grid);

% print results:

fprintf('Grand capacitance matrix [pF]:\n');
fprintf('%8.3f  %8.3f  %8.3f  %8.3f\n', Grid.Static.Ct.'*1e12);
fprintf('\n');

fprintf('Antenna capacitance matrix [pF], taking s/c body as ground:\n');
fprintf('%8.3f  %8.3f  %8.3f\n', Grid.Static.CA.'*1e12);
fprintf('\n');

fprintf('Open port Transfer matrix [pF], taking s/c body as ground:\n');
fprintf('%8.3f  %8.3f  %8.3f\n', Grid.Static.To.');
To_sph=car2sph(Grid.Static.To,2);
To_sph(:,2:3)=To_sph(:,2:3)/deg;
fprintf('In spherical coordinates:\n');
fprintf('%8.3f  %8.3f  %8.3f\n', To_sph.');
fprintf('\n');

toc

% diameters: antennas&connection=0.0286, body=2e-12, K(n,n)=0 for body
%
% Grand capacitance matrix [pF]:
%  106.262    -3.908    -5.763   -61.640
%   -4.822   106.987    -3.971   -44.386
%   -3.965    -4.193   106.521   -57.290
%  -73.415   -50.525   -50.016   452.099
%
% Antenna capacitance matrix [pF], taking s/c body as ground:
%  104.201    -8.051    -9.770
%   -7.995   100.609   -10.140
%   -6.387    -9.062   101.813
%
%------
% diameters: antennas&connection=0.0286, body=2e-2, K(n,n)=0 for body
%
% Grand capacitance matrix [pF]:
%  106.262    -3.908    -5.763   -61.640
%   -4.822   106.987    -3.971   -44.386
%   -3.965    -4.193   106.521   -57.290
%  -73.415   -50.525   -50.016   452.099
% 
% Antenna capacitance matrix [pF], taking s/c body as ground:
%  104.201    -8.051    -9.770
%   -7.995   100.609   -10.140
%   -6.387    -9.062   101.813
% 
%------
% diameters: antennas&connection=0.0286, body=2e-12, K(n,n) correct
%
% Grand capacitance matrix [pF]:
%   97.285    -4.452    -6.528   -33.792
%   -4.435    99.172    -6.184   -36.373
%   -6.533    -6.213    99.110   -36.061
%  -33.833   -36.339   -36.138   259.471
% 
% Antenna capacitance matrix [pF], taking s/c body as ground:
%   88.341   -13.342   -15.093
%  -13.322    90.339   -14.694
%  -15.100   -14.729    90.906
% 
%------
% diameters: antennas&connection=0.0286, body=2e-2, K(n,n) correct
%
% Grand capacitance matrix [pF]:
%  100.893    -2.310    -4.434   -51.435
%   -2.267   109.178    -3.866   -60.543
%   -4.444    -3.957   104.048   -54.465
%  -51.482   -60.396   -54.615   410.826
% 
% Antenna capacitance matrix [pF], taking s/c body as ground:
%   95.973    -7.209    -9.173
%   -7.162   104.303    -8.582
%   -9.187    -8.679    99.479
% 
%------
% diameters: antennas&connection=0.0286, body=4e-2, K(n,n) correct
%
% Grand capacitance matrix [pF]:
%  101.191    -2.189    -4.293   -52.646
%   -2.138   111.419    -3.718   -63.690
%   -4.303    -3.824   104.526   -55.808
%  -52.699   -63.515   -55.976   423.071
% 
% Antenna capacitance matrix [pF], taking s/c body as ground:
%   96.479    -6.883    -8.835
%   -6.829   106.747    -8.240
%   -8.850    -8.353   100.142
% 
%------
% diameters: antennas&connection=0.0286, body=2e-2, K(n,n) correct
% without CDA (segments 1045:1095 removed)
%
% Grand capacitance matrix [pF]:
%  100.884    -2.442    -4.470   -51.240
%   -2.442   100.653    -4.461   -50.892
%   -4.480    -4.470   103.885   -53.674
%  -51.243   -50.896   -53.742   399.710
% 
% Antenna capacitance matrix [pF], taking s/c body as ground:
%   95.959    -7.381    -9.221
%   -7.382    95.699    -9.226
%   -9.235    -9.239    99.298
% 
%------
% diameters: antennas&connection=0.0286, body=4e-2, K(n,n) correct
% without CDA (segments 1045:1095 removed)
%
% Grand capacitance matrix [pF]:
%  101.184    -2.310    -4.327   -52.468
%   -2.310   100.952    -4.316   -52.114
%   -4.337    -4.326   104.363   -55.036
%  -52.470   -52.118   -55.107   410.102
% 
% Antenna capacitance matrix [pF], taking s/c body as ground:
%   96.469    -7.041    -8.880
%   -7.041    96.206    -8.883
%   -8.894    -8.897    99.964
