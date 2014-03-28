
function K=StaticKernel(PhysGrid)

% K=StaticKernel(PhysGrid) calculates kernel K for equation
%   psi=K*Q,
% psi being the vector of electrostatic potentials on the elements,
% and Q the vector of charges uniformly distributed over the
% respective elements.
%
% Actually K is calculated in such a way that it gives the potentials
% in the middle of the elements (a slight potential variation over the 
% elements occurs due to dicretization).

Nseg=size(PhysGrid.Desc,1);
Npat=numel(PhysGrid.Desc2d);

Nelem=Nseg+Npat;

K=zeros(Nelem,Nelem);

% segments ends, lengths and directions:

r1=PhysGrid.Geom(PhysGrid.Desc(:,1),:);
r2=PhysGrid.Geom(PhysGrid.Desc(:,2),:); 
L=Mag(r2-r1,2);
er=(r2-r1)./repmat(L,1,3);

% test positions on segments and patches:

Nots=3;   % number of test positions on segments
Notp=1;   % n.o.t.p. on patches; =1: center of patch, ~=1: near each corner

rt=cell(Nelem,1);
for m=1:Nelem,
  if m<=Nseg,
    rt{m}=repmat(r1(m,:),Nots,1)+((1:Nots).'/(Nots+1))*(r2(m,:)-r1(m,:));
  else
    p=m-Nseg;
    g=PhysGrid.Geom(PhysGrid.Desc2d{p},:);
    rm=mean(g,1);
    if Notp==1,
      rt{m}=rm;
    else
      co=size(g,1);
      rt{m}=repmat(rm,co,1)+(g-repmat(rm,co,1))/2;
    end
  end
end

% calculate interaction terms with radiating segments:

for n=1:Nseg,

  Message=sprintf('Calculating static kernel, segment column %d',n);
  fprintf(Message)
  
  a=PhysGrid.Desc_.Diam(n)/2;   % wire radius
  
  % cross-interaction terms:

  for m=[1:n-1,n+1:Nelem],
    tt=size(rt{m},1);
    r=rt{m}-repmat(r1(n,:),tt,1);
    z=r*er(n,:).';
    rho=Mag(cross(r,repmat(er(n,:),tt,1),2),2);
    K(m,n)=0;
    for t=1:tt,
      K(m,n)=K(m,n)+StaticPot2(a,L(n),rho(t),z(t))/tt;
    end
  end
  
  % self-interaction term:

  K(n,n)=StaticPot1(L(n),a,L(n)/2);
  
  fprintf(repmat('\b',1,length(Message)))

end

% calculate interaction terms with radiating patches:

for p=1:Npat,
  
  Message=sprintf('Calculating static kernel, patch column %d',p);
  fprintf(Message)
  
  g=PhysGrid.Geom(PhysGrid.Desc2d{p},:);
  co=size(g,1);
  
  if (co>4)||(co<3),
    error('Can only handle patches with 3 or 4 corners.');
  end
  
  n=Nseg+p;  % element number of patch p
  
  for m=1:Nelem,
%    if (m>Nseg),
      K(m,n)=0;
      tt=size(rt{m},1);
      for t=1:tt,
        if co==3,
          Kx=StaticPot3(g(1,:),g(2,:),g(3,:),rt{m}(t,:));
        else
          F=[Mag(cross(g(2,:)-g(1,:),g(3,:)-g(1,:),2),2),...
            Mag(cross(g(3,:)-g(1,:),g(4,:)-g(1,:),2),2)];
          F=F/sum(F);
          Kx=F(1)*StaticPot3(g(1,:),g(2,:),g(3,:),rt{m}(t,:))+...
            F(2)*StaticPot3(g(3,:),g(4,:),g(1,:),rt{m}(t,:));
        end
        K(m,n)=K(m,n)+Kx/tt;
      end
%     else
%       if co==3,
%         K(m,n)=Interact31(g(1,:),g(2,:),g(3,:),r1(m,:),r2(m,:));
%       else
%         F=[Mag(cross(g(2,:)-g(1,:),g(3,:)-g(1,:),2),2),...
%             Mag(cross(g(3,:)-g(1,:),g(4,:)-g(1,:),2),2)];
%         F=F/sum(F); 
%         K(m,n)=F(1)*Interact31(g(1,:),g(2,:),g(3,:),r1(m,:),r2(m,:))+...
%           F(2)*Interact31(g(3,:),g(4,:),g(1,:),r1(m,:),r2(m,:));
%       end
%     end
   end
  
  fprintf(repmat('\b',1,length(Message)))
  
end

