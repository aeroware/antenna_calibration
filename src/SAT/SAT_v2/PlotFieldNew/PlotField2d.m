function [EArrow,EPatches,EPerpVec]=PlotField3(x,y,z,F,wt,ae,c,cmap,cstyle)

% [EArrow,EPatches,EPerpVec]=PlotField3(x,y,Fx,Fy,wt,ae,c,cmap,cstyle) plots
% the field given by  the complex vector F at time-phase wt (default wt=0).
% x, y,z and F must be vectors or matrices of the same size. 
%
% ae is a vector which specifies how arrows, ellipses and normal lines 
% are drawn: ae=[p,s,n],
% where p defines powers for normalization of vector lengths and
% s is a stretch factor for the resulting arrows:
%   vector shown = s * unit vector * (vector length)^p,
% e.g. p=1 shows the vectors as given, p=0.1 stretches vectors
% in such a way that 1/1024 of the maximum vector length is 
% actually shown as half the maximum vector length.
% n determines the vector length of the normal lines.
%
%c contains the colormap matrix that should be used. 
%
%cmap are specifications for the field maginitude color image:
%   cmap=[clog,cmax,cmin]
% clog=0 shows the colors in a linear, clog=1 in a logarithmic scale. 
% cmax is the colorindex of the color corresponding to the highest value,
% cmin the one of the smallest. In case of a logarithmic scale, cmin 
% determines value corresponding to the color with index 1, given in dB.
%
% cstyle contains specifications for the values that are shown by the colors:
% 'rel' means the realative size of the arrows, 'd' the distance to the origin,
% and 'x' the x position of th ellipse (same for y,z). d,x,y,z only work at 
% clog=0.


F=F*exp(i*wt);

Fx=F(:,1);
Fy=F(:,2);
Fz=F(:,3);

p=ae(1);
s=ae(2);
n=ae(3);

clog=cmap(1);
cmax=cmap(2);
cmin=cmap(3);
dB=cmin;

FAbs=sqrt(real(Fx).^2+real(Fy).^2+real(Fz).^2);
Dist=Mag([x,y,z],2);

if length(ae)>3
    ma=ae(4);
else
ma=max(FAbs);
end

mi=min(FAbs);
dma=max(Dist);
dmi=min(Dist);
norm=s/ma*(FAbs/ma).^(p-1);


if size(c,2)==3
    colormap=c';
end



if cstyle==0
    Col=colormap;
end


if clog==0
    for nn=1:length(x)
        
        if cstyle=='rel'
            Col(:,nn)=colormap(:,round((cmax-cmin)/(ma-mi)*(FAbs(nn)-mi)+cmin));
            colmin=mi;
            colmax=ma;
            tit='size';
        elseif cstyle=='d'
            Col(:,nn)=colormap(:,round((cmax-cmin)/(dma-dmi)*(Dist(nn)-dmi)+cmin));
            colmin=0;
            colmax=max(Dist);
            tit='|r|';
        elseif cstyle=='x'
            Col(:,nn)=colormap(:,round((cmax-cmin)/(max(x)-min(x))*(x(nn)-min(x))+cmin));
            colmin=min(x);
            colmax=max(x);
            tit='x';
        elseif cstyle=='y'
            Col(:,nn)=colormap(:,round((cmax-cmin)/(max(y)-min(y))*(y(nn)-min(y))+cmin)); 
            colmin=min(y);
            colmax=max(y);
            tit='y';
        elseif cstyle=='z'
            Col(:,nn)=colormap(:,round((cmax-cmin)/(max(z)-min(z))*(z(nn)-min(z))+cmin)); 
            colmin=min(z);
            colmax=max(z);
            tit='z';
        end
    end
end    


if clog==1
    if cstyle=='rel'
        phi=10^(dB/10);
        FAbs=FAbs/ma;
        FAbs(FAbs<phi)=phi;
        v=log(FAbs);
        xi2=max(1,log(1)-log(phi))/size(c,1);
        v=v/xi2;
        v=v+size(c,1);
        v=round(v);
        v(v==0)=min(v(v~=0));
        colmin=dB;
        colmax=0;
        tit='relative size dB';
        v=min(v,size(c,1));
    end
    
    
    for nn=1:length(x)
        Col(:,nn)=colormap(:,round(v(nn)));
        %Col=round(v(nn))';
    end
    
         
 end




SegNumEll=20;

xe=zeros(length(x),SegNumEll);
ye=zeros(length(y),SegNumEll);
ze=zeros(length(z),SegNumEll);

for nn=1:SegNumEll
    xe(:,nn)=x+norm.*real(Fx*exp(i*2*pi*nn/SegNumEll));
    ye(:,nn)=y+norm.*real(Fy*exp(i*2*pi*nn/SegNumEll));
    ze(:,nn)=z+norm.*real(Fz*exp(i*2*pi*nn/SegNumEll));
end

EllipH=line(ye',ze','Color','k');  

hold on

EPatches=patch(ye',ze',shiftdim(Col',-1));

hold on

EArrow=quiver(y,z,norm.*real(Fy),norm.*real(Fz),0);


EPerpVec=cross([real(Fx),real(Fy),real(Fz)],[imag(Fx),imag(Fy),imag(Fz)],2);

%length(EPerpVec)
EPerpVec=n*EPerpVec./repmat(Mag(EPerpVec,2),1,3);

%EPerp=line([x';x'+EPerpVec(:,1)'],[y';y'+EPerpVec(:,2)'],[z';z'+EPerpVec(:,3)']);

%set(EPerp,'color','k');

hs=gca;
set(gca,'clim',[colmin,colmax]);
ColBar=colorbar;
axes(ColBar);
xlabel('dB');

axes(hs);

hold off

