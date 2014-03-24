function [ant]=dipole_f(N, l, rad, feed)

// create wire grid model of dipole
//   N...number of segments
//   l...length
//   feed...position of feed(s)

if(argn(2)<2)
    fprintf('Please specify length of dipole');
    return;
end

if(argn(2)<3)
    feed=ceil(N/2);
end

ant=struct(...
    'nodes',[],...
    'segs',[],...
    'feeds',[],...
    'conductivity',0, ...
    'radius',0,...
    'nNodes',0, ...
    'nSegs',0, ...
    'length',0 ...
    );

ant.nNodes=N;
ant.nSegs=N-1;
ant.nodes=zeros(N,3);
ant.segs=zeros(N-1,2);

for(n=1:ant.nNodes)
    ant.nodes(n,:)=[0 0 (n-1)*(l)./ant.nNodes];
end


for(n=1:ant.nSegs)
    ant.segs(n,:)=[n n+1];
end

ant.feeds=feed;

//ant.conductivity=5.9e7 // copper
ant.conductivity=3.54e7; // aluminium
ant.radius=rad;        // 1 mm
ant.length=l

endfunction
