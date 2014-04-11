
function [h1,h2]=PlotComplex(f,Z,Ty,Lab,AddPlot)

% [h1,h2]=PlotComplex(f,Z) plots the complex function Z(f),
% displaying the real part in subplot(211) and the imaginary part in subplot(212).
% h1 and h2 return handles to the corresponding curves.
%
% [h1,h2]=PlotComplex(f,Z,2) draws magnitude and phase instead.  
%
% h=PlotComplex(f,Z,3) draws real versus imaginary part in one plot,
% returning a handle to the curve line.
%
% PlotComplex(f,Z,Ty,Lab) defines in the 4-element char-cell vector Lab labels 
% for f, real(Z), imag(Z) and |Z|, which are used for annotating the plot(s). 
% A fifth element can be given to set a plot title.
%
% PlotComplex(f,Z,Ty,Lab,1) adds the plot(s) to present one(s).

deg=pi/180;

if (nargin<3)|isempty(Ty),
  Ty=1;
end

if (nargin<4)|isempty(Lab),
  Lab={[],[],[],[],[]};
end
if length(Lab)<5,
  Lab{5}=[];
end

if (nargin<5)|isempty(AddPlot),
  AddPlot=0;
end

if isequal(Ty,3),
  
  subplot(1,1,1);
  hh=ishold;
  if AddPlot, hold on; end
  h1=plot(real(Z),imag(Z));
  h2=[];
  if ~hh, hold off; end
  
else
  
  subplot(2,1,1);
  hh=ishold;
  if AddPlot, hold on; end
  if isequal(Ty,2),
    h1=plot(f,abs(Z));
  else
    h1=plot(f,real(Z));
  end
  if ~hh, hold off; end
  
  subplot(2,1,2);
  hh=ishold;
  if AddPlot, hold on; end
  if isequal(Ty,2),
    h2=plot(f,dewrap(angle(Z))/deg);
  else
    h2=plot(f,imag(Z));
  end
  if ~hh, hold off; end
  
end

% annotation:

if Ty==3,
  subplot(1,1,1);
  if ischar(Lab{3}), ylabel(Lab{3}); end
  if ischar(Lab{2}), xlabel(Lab{2}); end
elseif Ty==2,
  subplot(2,1,1);
  if ischar(Lab{4}), ylabel(Lab{4}); end
else
  subplot(2,1,1);
  if ischar(Lab{2}), ylabel(Lab{2}); end
end
grid on;
if ischar(Lab{5}), title(Lab{5}); end

if ~(Ty==3),
  subplot(2,1,2);
  if ischar(Lab{1}), xlabel(Lab{1}); end
  if Ty==2,
    if ischar(Lab{4}), ylabel('Phase [deg]'); end
  else
    if ischar(Lab{3}), ylabel(Lab{3}); end
  end
  grid on;
end
