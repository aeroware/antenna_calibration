function [h]=PlotJunoAntennae(ant,op,er,solver,h,cm,iCol,PhysAnt,leg,LinSty,ca,caps, rad_corr,merge)

%   function [h]=PlotJunoAntennae(Ant,Op,er,h,cm,i,PhysAnt,leg,LinSty,ca.caps,tad_corr,merge)
%   PlotJunoAntennae plots the antennas of the model ant and the effective
%   length vectors in the same figure. It uses AntTransferx for calculation
%   of heff. er is a row-vector, the direction of the incident wave. h is a
%   handle to the picture, cm a colormap and i the index to the color of
%   the effective height vectors. If PhysAnt is 1, the physical antennas will 
%   be plotted. The function returns the handle to the picture. If cm=0,
%   plot the three antennas with the colors red, green and blue and ignore
%   the index. If leg==1, There is some text inserted. LinSty is the
%   LineStyle of the plotted effective axis
%   caps is a matrix of the capacitances

if(nargin<3)
    fprintf('Error-not enough parameters');
    return
end % check input

if((nargin==5)&(cm))
    fprintf('Error-a colormap without index is not useful');
    return
end % check input

if(~exist('rad_corr'))
    rad_corr=0;
end

if(~exist('merge'))
    merge=0;
end

torad=pi/180;


if(ca)
    impedances=caps./(i*op.Freq*2*pi);
    if(rad_corr)
        heff=AntTransferx(ant,op,er,solver,2,0.005,impedances);
    else
        heff=AntTransferx(ant,op,er,solver,0,25.4/1000,impedances);
    end
else
    heff=AntTransferx(ant,op,er,solver,0,0); 
end

if(nargin<4)
    h=figure;
else
    if ~merge
        figure(h);
    end
end

if(~exist('leg'))
    leg=0;
end % if

if(~exist('LinSty'))
    LinSty='-';
end % if

if(~exist('PhysAnt'))
    PhysAnt=0;
end % if

if(~exist('cm'))
    cm=0;
end % if


    

% effective length vectors

if merge
    hold on

    h1x=[ant.Geom(ant.Feed(1),1),real(heff(1,1))+ant.Geom(ant.Feed(1),1)];
    h1y=[ant.Geom(ant.Feed(1),2),real(heff(1,2))+ant.Geom(ant.Feed(1),2)];
    h1z=[ant.Geom(ant.Feed(1),3),real(heff(1,3))+ant.Geom(ant.Feed(1),3)];

    h2x=[ant.Geom(ant.Feed(2),1),real(heff(2,1))+ant.Geom(ant.Feed(2),1)];
    h2y=[ant.Geom(ant.Feed(2),2),real(heff(2,2))+ant.Geom(ant.Feed(2),2)];
    h2z=[ant.Geom(ant.Feed(2),3),real(heff(2,3))+ant.Geom(ant.Feed(2),3)];
else
    h1x=[0,real(heff(1,1))];
    h1y=[0,real(heff(1,2))];
    h1z=[0,real(heff(1,3))];

    h2x=[0,real(heff(2,1))];
    h2y=[0,real(heff(2,2))];
    h2z=[0,real(heff(2,3))];
end

    if(length(cm)>1)
        line(h1x,h1y,h1z,'Color',cm(iCol,:), 'LineStyle', LinSty);
        line(h2x,h2y,h2z,'Color',cm(iCol,:), 'LineStyle', LinSty);
        line(h3x,h3y,h3z,'Color',cm(iCol,:), 'LineStyle', LinSty);
    
        if(leg==1)
            text(h1x(2)*1.2,h1y(2)*1.2,h1z(2)*1.2,'Ez','Color',cm(iCol,:));
            text(h2x(2)*1.2,h2y(2)*1.2,h2z(2)*1.2,'Ey','Color',cm(iCol,:));
            text(h3x(2)*1.2,h3y(2)*1.2,h3z(2)*1.2,'Ex','Color',cm(iCol,:));
        end % if    
    else
        if ca
            line(h1x,h1y,h1z,'Color','b', 'LineStyle', LinSty);
            line(h2x,h2y,h2z,'Color','b', 'LineStyle', LinSty);
 
            if(leg==1)
                text(h1x(2)*1.2,h1y(2)*1.2,h1z(2)*1.2,'Ez','Color','b');
                text(h2x(2)*1.2,h2y(2)*1.2,h2z(2)*1.2,'Ey','Color','b');
            end % if
        else
            line(h1x,h1y,h1z,'Color','r', 'LineStyle', LinSty);
            line(h2x,h2y,h2z,'Color','r', 'LineStyle', LinSty);
            if(leg==1)
                text(h1x(2)*1.2,h1y(2)*1.2,h1z(2)*1.2,'E1','Color','r');
                text(h2x(2)*1.2,h2y(2)*1.2,h2z(2)*1.2,'E2','Color','r');
            end % if
        end % if ca
    end %else

% physical antennas

if ~merge
if(PhysAnt==1)
    a1z=-[0,ant.Antennae(1).Length*sin(ant.Antennae(1).Zeta)*cos(ant.Antennae(1).Xi)];
    a1y=[0,ant.Antennae(1).Length*sin(ant.Antennae(1).Zeta)*sin(ant.Antennae(1).Xi)];
    a1x=[0,ant.Antennae(1).Length*cos(ant.Antennae(1).Zeta)];

    a2z=-[0,ant.Antennae(2).Length*sin(ant.Antennae(2).Zeta)*cos(ant.Antennae(2).Xi)];
    a2y=[0,ant.Antennae(2).Length*sin(ant.Antennae(2).Zeta)*sin(ant.Antennae(2).Xi)];
    a2x=[0,ant.Antennae(2).Length*cos(ant.Antennae(2).Zeta)];

    line(a1x,a1y,a1z,'Color','k','LineWidth',2);
    line(a2x,a2y,a2z,'Color','k','LineWidth',2);


    if(leg==1)
        text(a1x(2)*1.1,a1y(2)*1.1,a1z(2)*1.1,'E1','Color','k');
        text(a2x(2)*1.1,a2y(2)*1.1,a2z(2)*1.1,'E2','Color','k');
    end %if
end % if
end

%axis equal