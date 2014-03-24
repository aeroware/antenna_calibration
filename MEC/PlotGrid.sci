function [] = PlotGrid(ant)

// Display warning for floating point exception
ieee(1)


// Function PlotGrid(ant)
// The Input of the function ist the structure that holds the antenna
// wiregrid. The purpose ist to plot the wiregrid.

//param3d(0,0,0);

for n = 1:ant.nSegs
	param3d1([ant.nodes(ant.segs(n,1),1) ant.nodes(ant.segs(n,2),1)],[ant.nodes(ant.segs(n,1),2) ant.nodes(ant.segs(n,2),2)],[ant.nodes(ant.segs(n,1),3) ant.nodes(ant.segs(n,2),3)]);	
end; // for all segments

a=get("current_axes");
h=a.children;

h.foreground = color("blue");
h.mark_foreground = color("blue");
h.mark_style = 1;

h(ant.feeds).foreground = color("red");
h(ant.feeds).mark_foreground = color("red");
h(ant.feeds).mark_style = 9;

//for n = 1:max(size(ant.feeds))
  //param3d1([ant.nodes(ant.segs(ant.feeds(n),1),1) ant.nodes(ant.segs(ant.feeds(n),2),1)],[ant.nodes(ant.segs(ant.feeds(n),1),2) ant.nodes(ant.segs(ant.feeds(n),2),2)],[ant.nodes(ant.segs(ant.feeds(n),1),3) ant.nodes(ant.segs(ant.feeds(n),2),3)]);
//end;

//h=a.children;

//for n = ant.nSegs+1:max(size(h)) 
	h//(n).foreground = color("red");
	//h(n).mark_style = 2;
//end
endfunction
