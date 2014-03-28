
function [Z,Y]=AntImpedance(ant,op,solver,antennalength,diameter);

%   [Z,Y]=AntImpedance(Ant,Op,solver,antennalength,diameter) returns the 
%   impedance and admittance matrices.
%
%   Input parameters :
%
%       ant...          antenna structure
%       Op...           structure describing the antenna operation
%       solver...       which solver is to be used  - 1...ASAP
%                                               - 2...Concept    
%       antennalength...length of antenna for radius correction
%                       0 --> no radius correction
%       diameter...     mean diameter of antenna
%
%   Output parameters:
%
%       Z...    impedance matrix
%       Y...    admittance matrix


Y=AntAdmittance(ant,op,solver,antennalength,diameter);

if size(Y,1)~=size(Y,2), 
  Z=1./Y;
else
  Z=inv(Y);
end

