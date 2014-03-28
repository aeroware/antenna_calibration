

% load test Grid and Op before running this script or use the following

if 1==1,
  
  Frequencies=[300:100:700]*1e3;  % frequency selection
  
  load('Cas1a_Grid');  % load Grid
  Grid
  
  Op=VarLoad('CasOp r2 inf','all','Op');
  [qq,q]=unique(round([Op.Freq]));
  Op=Op(q);
  q=ismember([Op.Freq],Frequencies);
  Op=Op(find(q));
  Op
  
  f=[Op.Freq];
  nf=length(f);       % number of frequencies
  
end

CL=[118.9,   0.0,   0.0;...
      0.0, 113.1,   0.0;...
      0.0,   0.0, 105.7]*1e-12;

A=zeros(nf,3,3);

for m=1:3,
  for n=m:3,
    
    for q=1:nf
      fprintf('m = %1d,  n = %1d,  f[kHz] = %6d\n',m,n,round(f(q)/1e3));
      YL=j*2*pi*f(q)*CL;
      A(q,m,n)=IntegrateVV(Grid,Op(q),YL,m,n);
      for qq=1:32, fprintf('\b'); end
    end
      
    figure(10*m+n);
    plot(f(:),[real(A(:,m,n)),imag(A(:,m,n))])
    title(['Coherence <V_',char('t'+m),' V^*_',char('t'+n)]);
    ylabel('VV/|E|^2 [m^2]')
    drawnow
    
  end
end

