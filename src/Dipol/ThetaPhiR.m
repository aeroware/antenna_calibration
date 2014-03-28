function TPR=ThetaPhiR(TM)

%   TPR=ThetaPhiR(TM) takes the Thransphere matrix TM an parameter and
%   computes the spherical coordinates of the effective height vectors
%   The imaginery part is ignored. The z-Coordinate is reflected, due to
%   the characteristics of the stereo model

todeg=180/pi;

% theta is von der pos. x achse
% weg, phi von der pos. z-achse

    TPR(2)=atan2(-real(TM(2)),real(TM(3)));  % phi
    TPR(1)=atan2(sqrt(real(TM(3))^2+ real(TM(2))^2),real(TM(1)));  % theta
    TPR(3)=sqrt(real(TM(1))^2+real(TM(2))^2+ real(TM(3))^2);  % R
    
    % to degrees
    
    TPR(1)=TPR(1)*todeg;
    TPR(2)=TPR(2)*todeg;
    
   
    



