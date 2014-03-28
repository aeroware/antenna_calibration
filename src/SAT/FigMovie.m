
function [M,nid,fn]=FigMovie(ff,n)

% M=FigMovie(ff) creates movie M from the figure files given in ff, 
% which may be a string (single filename) or a cell array of strings.
% All files of the form ff*.fig, or ff{k}*.fig for any k, are used.
% The * stands for any string and is usually used for enumeration.
% if * strarts with a number, the numbers are used to sort the frames 
% (figures) in the order they shall appear in the movie. 
% The placeholder * can also be part of the given string, e.g.
% f='Gain *kHz' loads all files that have names starting with 'Gain ', 
% followed by a number and ending with 'kHz'.
%
% M=FigMovie(ff,n) restricts the frames to those *-numbers which are 
% contained in the vector n.
%
% [M,nid,fn]=... also returns in nid for each frame the identification number 
% (represented by *) that has actually found (nan for no number found), and in 
% fn the corresponding filename. nid is a double and fn a cell array, both of 
% same size as M.

stat=0;

if nargin<2,
  n='all';
end

if ischar(ff),
  ff=Cellstr(ff);
end

fn={};
nid=[];

for k=1:length(ff),
  
  [pa,na,ex]=fileparts(ff{k});
  m=strfind(na,'*');
  if isempty(m),
    ffk=fullfile(pa,[na,'*.fig']);
  else
    ffk=fullfile(pa,[na,'.fig']);
  end
  m=strfind(ffk,'*');
  m=m(1);
  q=dir(ffk);
  qq=find(~[q.isdir]);
  q=unique({q(qq).name});
  
  qq=zeros(size(q))+nan;
  for k=1:length(q),
    q{k}=fullfile(pa,q{k});
    nn=sscanf(q{k}(m:end),'%g');
    if ~isempty(nn),
      qq(k)=nn(1);
    end
  end
  
  if ~ischar(n),
    nn=find(ismember(qq,n));
    qq=qq(nn);
    q=q(nn);
  end
  
  fn=[fn,q];
  nid=[nid,qq];
  
end

if isempty(fn),
  error('File(s) not found.');
end

for k=1:length(fn),
  
  hg=hgload(fn{k});
  
  M(k)=getframe(gcf); 
  
  delete(hg);
   
end
