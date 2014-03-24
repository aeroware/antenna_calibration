function [mcant,asapant,conceptant]=mcCreateDipole(N, l, rad,feed)


% function ant=mcCreateDipole(N, l, rad,feed)
%   The function creates an antenna structure and stores it in ant.
%   N...number of segments
%   l...length
%   rad...radius of the wire
%   feed...position of feed(s)

if(nargin<2)
    fprintf('Please specify length of dipole');
    return;
end

if(nargin<4)
    feed=ceil(N/2);
end

mcant=struct(...
    'nodes',[],...
    'segs',[],...
    'feeds',[],...
    'conductivity',0, ...
    'radius',0,...
    'nNodes',0, ...
    'nSegs',0, ...
    'length',0 ...
    );

mcant.nNodes=N+1;
mcant.nSegs=N;

for(n=1:mcant.nNodes)
    mcant.nodes(n,:)=[0 0 -l/2+(n-0.5)*l/mcant.nNodes];
end


for(n=1:mcant.nSegs)
    mcant.segs(n,:)=[n n+1];
end

mcant.feeds=feed;

%mcant.conductivity=5.9e7 % copper
mcant.conductivity=3.54e7; % aluminium
%mcant.conductivity=30e6; % aluminium

mcant.radius=rad;        
mcant.length=l;

% create text file for passing parameters

fh=fopen('grid.mec','w');
fprintf(fh,'%i\n',mcant.nNodes);
fprintf(fh,'%i\n',mcant.nSegs);
fprintf(fh,'%f\n',mcant.conductivity);
fprintf(fh,'%f\n',mcant.radius);
fprintf(fh,'%f\n',mcant.length);
fprintf(fh,'%i\n',length(feed));

for q=1:length(feed)
    fprintf(fh,'%i\n',feed(q));
end

for q=1:mcant.nNodes
    fprintf(fh,'%f %f %f\n',mcant.nodes(q,1),mcant.nodes(q,2),mcant.nodes(q,3));
end

for q=1:mcant.nSegs
    fprintf(fh,'%i %i\n',mcant.segs(q,1),mcant.segs(q,2));
end

fclose(fh);


