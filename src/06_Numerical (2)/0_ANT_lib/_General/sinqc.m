
function s=sinqc(z)

% s=sinqc(z) returns sin(z)./z - cos(z)

s=sqrt(pi/2*z).*besselj(3/2,z);


