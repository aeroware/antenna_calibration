
function FF=Concept_Far(Freq,AntGrid,r,WorkingDir,Field)

% FF=Concept_Far(Freq,AntGrid,er,WorkingDir,Field) calculates far field radiated 
% from the antenna system the currents of which already must have been 
% determined and the results stored in the directory WorkingDir.
% The field is calculated for the directions er. er is an n x 3 matrix
% each row of which gives a unit vector (n vectors present) representing
% the radiation direction. 
% FF is of same size as er, so FF(m,:) is the electric field radiated 
% in the direction er(m,:).
% Field is a string defining the field to be calculated: 'E' or 'H'.
%
% Actually, FF is the respective field F apart from the factor
% exp(-jkr)/r, so the field F can be obtained as
%   F = (exp(-jkr)/r) * FF.

[RFar,RFresnel,d]=FieldZones(Freq,AntGrid);

dist=10*max(RFar,10*d);
r=dist*r./repmat(Mag(r,2),[1,3]);

FF=Concept_Near(r,WorkingDir,Field);

jkdist=j*dist*Kepsmu(Freq,AntGrid);

FF=dist*exp(jkdist)*FF;

