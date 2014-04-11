function alpha=Angle2vec(v1,v2);

% alpha=Angle2vec(v1,v2) calculates the angle alpha between the two vectors
% v1 and v2 that can be two or three-dimensional. alpha will be given in
% degrees.

% Control of input
if size(v1)==[3,1] | size(v1)==[2,1]
   v1=v1';
end
if size(v2)==[3,1] | size(v2)==[2,1]
   v2=v2';
end
sizev1=size(v1);
sizev2=size(v2);
if sizev1(2)==2
   v1(3)=0;
end
if sizev2(2)==2
   v2(3)=0;
end
if sizev1(1)>1 | sizev2(1)>1 | sizev1(2)>3 | sizev2(2)>3
   disp('Vectors exceed dimension.')
   return
end

% Calculations
absv1=sqrt(v1(1)^2+v1(2)^2+v1(3)^2);
absv2=sqrt(v2(1)^2+v2(2)^2+v2(3)^2);
if absv1==0 | absv2==0
   disp('One vector has length zero.')
   return
end
scalarprod=v1(1)*v2(1)+v1(2)*v2(2)+v1(3)*v2(3);
alpha=acos(scalarprod/(absv1*absv2))*180/pi;

