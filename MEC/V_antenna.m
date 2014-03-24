% create wire grid model of dipole

clear

ant=struct(...
    'nodes',[],...
    'segs',[],...
    'feeds',[],...
    'conductivity',0, ...
    'nNodes',0, ...
    'nSegs',0 ...
    );

ant.nodes=[0 -.18 +.18
    0 -.09 +.09
    0 0 0
    0 0.09 .09
    0 .18 .18]

ant.segs=[1 2
    2 3
    3 4 
    4 5]

ant.feeds=[3]

%ant.conductivity=5.9e7 % copper
ant.conductivity=3.54e7 % aluminium
ant.radius=0.001;        % 1 mm

ant.nNodes=5
ant.nSegs=4