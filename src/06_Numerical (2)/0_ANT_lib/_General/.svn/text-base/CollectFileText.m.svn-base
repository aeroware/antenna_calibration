
function [Li,Files]=CollectFileText(Fin,Fout)

% Li=CollectFileText(Fin,Fout) collects all text lines from the files
% given in Fin and writes it to the file Fout.
% Fout must be a single file name, whereas Fin can contain
% placeholders (e.g. '*.m') and may also be a cell array of file names.
% Li returns the text written to Fout, each line in a separate cell.

MaxLF=2;                   % max. number of consecutive line feeds
FileSep=repmat('=',1,60);  % separator inserted between files

% collect files:

if ~iscell(Fin),
  Fin=cellstr(Fin);
end

for n=1:numel(Fin),
  d=dir(Fin{n});
  if n==1,
    Files=d(:);
  else
    Files=[Files;d(:)];
  end
end

if ~isempty(Files),
  Files=Files(~[Files.isdir]);
end
  
if isempty(Files),
  warning('No files found.');
  return
end

% read all text lines:

Li={};
for n=1:numel(Files),
  fidi=fopen(Files(n).name);
  x=ReadFileLines(fidi);
  fclose(fidi);
  
  s={};
  if ~isempty(Li)&&~isempty(Li{end}(~isspace(Li{end}))),
    s={''};
  end
  s=[s;cellstr(FileSep)];
  if ~isempty(x)&&~isempty(x{1}(~isspace(x{1}))),
    s=[s;''];
  end
  Li=[Li;s;x];  
end

% remove excess line feeds:

if ~isempty(Li),
  
  nospace=@(x)(x(~isspace(x)));

  Empties=zeros(length(Li),1);
  
  if isempty(nospace(Li{1})),
    Empties(1)=1;
  end
  
  for n=2:length(Li),
    if isempty(nospace(Li{n})),
      Empties(n)=Empties(n-1)+1;
    end
  end

  Li=Li(Empties<=MaxLF);

end

% write to output file:

fido=fopen(Fout,'wt');
for n=1:numel(Li),
  fprintf(fido,'%s\n',Li{n});
end
fclose(fido);

  
end % of main function


% -----------------------------

function [Li,Err]=ReadFileLines(fid)

Li={};
Err='';

while ~feof(fid)&&isempty(Err);

  Li{end+1,1}=fgetl(fid);
  Err=ferror(fid);

end

end

