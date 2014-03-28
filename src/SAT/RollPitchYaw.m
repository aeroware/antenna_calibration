
function A=RollPitchYaw(R,P,Y,Forward,Right)

% A=RollPitchYaw(R,P,Y,Forward,Right) calculates the 
% complete rotation matrix A from the given 
% roll (R), pitch (P) and yaw (Y) angles.
% The single revolutions are performed in the order R, P, Y,
% and the corrsponding revolution axes are defined by the 
% vectors Forward, Right, and Forward x Right (the flying 
% object has nose in Forward direction, and downwards is 
% Forward x Right). 
% R, P and Y in radian units, 
%
% Algorithm: A is calculated as A=AR*AP*AY, where AR, AP and AY are
% the roll, pitch and yaw rotations as seen from the flying object.

Down=cross(Forward,Right);
Forward=Forward./Mag(Forward);
Right=Right./Mag(Right);
Down=Down./Mag(Down);

AR=Motion(R*Forward);
AP=Motion(P*Right);
AY=Motion(Y*Down);

A=AR*AP*AY;
