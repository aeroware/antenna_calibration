function SaveFigure(fh,filename,formatflag)  
  % SaveFigure(fh,filename)
  % saves figure (figure handle fh) to filename in eps-format
  %
  % @input: fh          figure handle
  %         filename    filename without extension
  %         formatflag  0 ... 'eps'
  %                     1 ... 'png'
  
  if nargin < 3
    formatflag = 0;
  end
  
  set(fh,'paperposition',[1,1,6.5,9]);
  if formatflag == 1
    print([filename,'.png'],'-dpng','-r300',['-f',num2str(fh)])
  else
    print([filename,'.eps'],'-depsc','-r300',['-f',num2str(fh)])    
  end