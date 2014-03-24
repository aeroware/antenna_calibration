function PlotGrid(ant)

% Function PlotGrid(ant)
% The Input of the function ist the structure that holds the antenna
% wiregrid. The purpose ist to plot the wiregrid.

plot3(0,0,0)

for n=1:ant.nSegs
    line([ant.nodes(ant.segs(n,1),1) ant.nodes(ant.segs(n,2),1)],[ant.nodes(ant.segs(n,1),2) ant.nodes(ant.segs(n,2),2)],[ant.nodes(ant.segs(n,1),3) ant.nodes(ant.segs(n,2),3)],'Marker','+','MarkerEdgeColor','red');
end % for all segments

for(n=1:length(ant.feeds))
line([ant.nodes(ant.segs(ant.feeds(n),1),1) ant.nodes(ant.segs(ant.feeds(n),2),1)],[ant.nodes(ant.segs(ant.feeds(n),1),2) ant.nodes(ant.segs(ant.feeds(n),2),2)],[ant.nodes(ant.segs(ant.feeds(n),1),3) ant.nodes(ant.segs(ant.feeds(n),2),3)],'Marker','o','MarkerEdgeColor','green','Color','green');

title('Dipole');
xlabel('x');
ylabel('y');
zlabel('z');

end
