
function [hs,hc,ha,hco,c,hsurf,rSc,cSc]=...
  PlotEffArea(er,T,rScale,cScale,Contours,verhor,cbar)

% [hs,hc,ha,hco,c]=PlotEffArea(er,T,rScale,cScale,Contours)
% plots the effective area which gives a pattern of the reception 
% sensitivity as a function of direction.
% er must be dx3, where d is the number of directions, which must
% be arranged in phi- or theta-lines of equal number of theta-lines for
% each phi, and vice versa. T must be of size nx3xd, where n is the
% number of patterns to be plotted (usually number of ports, or
% frequencies).
%
% rScale defines the scale for the radii (distance of surface from origin),
% two versions are possible:
% rScale=[rmin,rmax] defines a linear scale, with rmin being the value of
% the effective area Aeff which is mapped to the origin, rmax determines
% the bounding box in which the pattern is plotted.
% rScale=[rdBmin,rdBmax,r0dB] defines a logarithmic scale with 0dB being
% at the Aeff value r0dB. rdBmin is the dB value at the origin, and
% rdBmax defines the bounding box.
%
% cScale sets the color scale, where in analogy to rScale
% two options are possible: 
% cScale=[Cmin,Cmax] establishes a linear scale with the two ends of the
% color scale being mapped to the Aeff values Cmin and Cmax.
% cScale=[CdBmin,CdBmax,C0dB] is a logarithmic scale with the ends
% of the color scale at the dB values CdBmin and CdBmax, 0dB being
% mapped to the Aeff value C0dB.
%
% It is possible to set some of the elements of rScale and/or cScale
% to NaN in order to cause the automatic determination of the respective
% value(s).
%
% Pass a scalar in Contours to indicate how many contour lines shall be
% drawn. Pass a vector to give the values for which contour lines are to be
% drawn. Default is to draw  lines of constant latitude and azimuth
% instead of contour lines.
%
% [hs,hc,ha,hco,c,hsurf,rSc,cSc]=...
%   PlotEffArea(er,T,rScale,cScale,Contours,verhor)
% causes subplots with the arrangement defined in the 2-element vector 
% verhor=[ver,hor], hor and ver being thenumber of horizontal and vertical
% subplots, respectively. 


if (size(er,2)~=3)||(size(T,2)~=3)||(numel(er)~=numel(T(1,:))),
  error('Inconsistent dimensions of er and T.');
end

if ~exist('rScale','var')||isempty(rScale),
  rScale=[];
end
if ~exist('cScale','var')||isempty(cScale),
  cScale=[];
end
if ~exist('Contours','var')||isempty(Contours),
  Contours=[];
end
if ~exist('verhor','var')||isempty(verhor),
  verhor=[];
end
if ~exist('cbar','var')||isempty(cbar),
  cbar=[];
end

% determine spherical coordinates:

rtp=car2sph(er,2);
er=er./repmat(rtp(:,1),1,3);
th=rtp(:,2);
ph=rtp(:,3);

nn=sum(abs(diff([th,ph],1))>1e-6,1);

if nn(1)<nn(2),
  nth=nn(1)+1;
  nph=size(rtp,1)/nth;
  if round(nph)~=nph,
    error('Unsuitable distribution of directions in er.')
  end
  th=reshape(th,nph,nth);
  ph=reshape(ph,nph,nth);
  ii=(abs(th(1,:))<1e-6)|(abs(th(1,:)-pi)<1e-6);
  jj=find(~ii);
  if ~isempty(jj),
    ph(:,ii)=repmat(ph(:,jj(1)),1,sum(ii));
  end
else
  nph=nn(2)+1;
  nth=size(rtp,1)/nph;
  if round(nth)~=nth,
    error('Unsuitable distribution of directions in er.')
  end
  th=reshape(rtp(:,2),nth,nph);
  ph=reshape(rtp(:,3),nth,nph);
  ii=(abs(th(1,:))<1e-6)|(abs(th(1,:)-pi)<1e-6);
  jj=find(~ii);
  if ~isempty(jj),
    ph(ii,:)=repmat(ph(jj(1),:),sum(ii),1);
  end
end  

% subplot arrangement:

nports=size(T,1);

if isempty(verhor),
  switch nports,
    case 3, ver=3; hor=1;
    case 4, ver=4; hor=1;
    case 5, ver=3; hor=2;
    case 6, ver=3; hor=2;
    case 7, ver=4; hor=2;
    case 8, ver=4; hor=2;
    otherwise
      ver=ceil(sqrt(nports)); hor=ceil(nports/ver);
  end
  verhor=[ver,hor];
end

% calculate Aeff and plot it:

Aeff=reshape(Mag(cross(repmat(er,[1,1,size(T,1)]),...
  permute(T(:,:,:),[3,2,1]),2),2).^2,[size(th),size(T,1)]);  
  
tmin=[];
[hs,hc,ha,hco,c,hsurf,rSc,cSc]=...
  PlotPolar3(th,ph,Aeff,rScale,cScale,Contours,tmin,[],verhor,cbar);

