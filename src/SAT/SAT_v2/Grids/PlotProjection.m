
function ph=PlotProjection(h,p,M,Margin,Title,PrinterOpt,PrintFile)

% ph=PlotProjection(h,p,M,Margin,Title,PrinterOpt,PrintFile) plots 
% projections of the axes in the figure with handle h. The resulting plots 
% are shown in different figures, the handles are returned in ph. The  
% vector p gives the projections to be plotted, which are defined by numbers:
%    1,2,3,-1,-2,-3 ... view from +X,+Y,+Z,-X,-Y,-Z,
% p being any set of these numbers. M is the scale of the plots, Margin 
% may define figure margins as explained in ToScale (default=[]). 
% If a string PrinterOpt is passed, the plots are immediately printed with 
% PrinterOpt as option, e.g. PrinterOpt='-dtiff example' prints in tiff-format 
% to the file 'example.tif'. 
% Title can be a string array or cell array of strings giving the titles for
% the plots, by defaults the view is indicated in the title.
%
% Note that the plot-scale M refers to units in centimeters, and Margin must 
% be given in cm as well!

% ADDED to grid-toolbox 10.4.2003

if (nargin<7)|isempty(PrintFile),
  PrintFile='';
end
[PrintPath,PrintFile,PrintFileExt]=FileParts(PrintFile);
PrintFile=fullfile(PrintPath,PrintFile);

if nargin<6,
  PrinterOpt=[];
end
if ~isempty(PrinterOpt)&~ischar(PrinterOpt),
  PrinterOpt='';
end

if nargin<4,
  Margin=[];
end

ph=[];

if isempty(p), return, end

if nargin<5,
  Title={};
end
if ischar(Title),
  Title=cellstr(Title);
elseif ~iscell(Title),
  Title={};
end

t=0;

for k=p(:).',
  ph(end+1)=copyobj(h,0);
  figure(ph(end));
  xlabel('X');
  ylabel('Y');
  zlabel('Z');
  switch k,
  case 1,
    v='+X';
    view([1,0,0]);
  case 2,
    v='+Y';
    view([0,1,0]);
  case 3,
    v='+Z';
    view([0,0,1]);
  case -1,
    v='-X';
    view([-1,0,0]);
  case -2,
    v='-Y';
    view([0,-1,0]);
  case -3,
    v='-Z';
    view([0,0,-1]);
  otherwise
%    r=get(gca,'CameraPosition');
    [az,el]=view;
    v=num2str(round([az,el]),'%1d %1d');
  end
  if isempty(Title),
    title(['\bf View from ',v]);
  else
    t=mod(t,length(Title))+1;
    title(Title{t});
  end
  Toscale(M,Margin);
  if ~isempty(PrinterOpt),
    if ~isempty(PrintFile),
      print(PrinterOpt,[PrintFile,' ',v,PrintFileExt]);
    else
      print(PrinterOpt);
    end
  end
end


