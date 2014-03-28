 
function [ant]=SetWireRadii(ant);

%   function [ant]=SetWireRadii(ant); iis a function which takes the
%   grid structure ant as input parameter and inserts a NSegs x 1 vector
%   which holds the radius of the wire of each edge. The radius of the
%   antennas is set to antRadius, all other radii to ant.Wire(1).
%
%   This function was written by Thomas Oswald, 2007
%   Extension to deal with S/C of different number of antennas by Thomas
%   Oswald, March 2007

 %-----------------------
 % read ant
 %-----------------------
 
 
 Nsegs=length(ant.Desc);
 antRadius=ant.Obj(ant.antennae(1).Obj).Prop.Radius;

 % vector to save the number of adjacent segments
 
 ant.WireRadii=zeros(Nsegs,2);
 
 % radii of all edges
 
 ant.WireRadii(:,1)=ant.wire(1);
 
 for n=1:length(ant.antennae)
    
 
% radii of the antennas
 
    ant.WireRadii(ant.Obj(ant.antennae(n).Obj).Elem)=antRadius;
 end

 
 
 
 
 
