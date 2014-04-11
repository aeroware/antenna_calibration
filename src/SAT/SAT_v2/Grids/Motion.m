
function [R,t]=Motion(r1,r2,dir);

% [R,t]=Motion(..) analyzes rigid body motion.
% The function depends on the number of given parameters.
%
% [R,t]=Motion(r1,r2,dir), where dir is optional.
% r1 and r2 must have size 3x3, each representing the 
% position of 3 points, which are stored as columns. 
% r1 represents the positions of the 3 points before, 
% r2 the position after the motion. 
% Each triple of points must not lie on a straight line
% but the triples must span triangles of same size. 
% The transformation is decomposed into a rotation R 
% (an orthogonal matrix with unit determinant) and a 
% translation t, so any point r is transformed by the 
% matrix expression R*r+t. If the optional parameter dir 
% is set to 1, the first columns of r1 and r2 are not 
% interpreted as points but as initial and final directions, 
% respectively. For dir=2 two colums (the first and the 
% second, resp.) of r1 and r2 are treated in this way.
%
% [R,t]=Motion(r1), with two possibilities: 
% if r1 is a vector, it is assumed to represent a revolution 
% vector, which means that it defines a revolution by the 
% angle |r1| around the axis through the origin parallel 
% to r1; the pertaining rotation matrix R is returned. 
% Vice versa, if r1 is a 3x3 array, it is supposed to 
% represent a rotation, and the corresponding revolution 
% vector is calculated and returned in R.  

if nargin<2,
  
  t=[0;0;0];
  
  if size(r1,1)==size(r1,2),  
    
    % given rotation matrix -> revolution vector:
    % (for |phi| < 60 deg the revolution vector is calculated from 
    % the asymmetric part of the rotation matrix to improve accuracy, 
    % otherwise an eigenvector decomposition is used)
    
    if (trace(r1)-1)/2<0.5,
      [v,w]=eig(r1);
      [m,n]=sort(abs(diag(w)-1));
      R=real(v(:,n(1)));
      if R'*Cross(real(v(:,n(3))),imag(v(:,n(3))))<0,
        R=-R;  
      end
      R=-angle(w(n(3),n(3)))*R;
      return
    else   
      A=(r1-r1')/2;
      R=[-A(2,3);A(1,3);-A(1,2)];
      s=norm(R);
      if s==0,
        R=[0;0;0];
      else
        R=asin(s)/s*R;
      end
    end
    
  else  
    
    % given revolution vector -> rotation matrix:
    
    if size(r1,1)<size(r1,2),
      r1=r1';
    end    
    A=norm(r1);
    if A==0,
      R=eye(3);
      return
    end
    s=sin(A);
    c=cos(A);
    A=r1/A;
    R=A*A'*(1-c)+eye(3)*c+s*[0,-A(3),A(2);A(3),0,-A(1);-A(2),A(1),0];
    
  end
  
else  
  
  % given r1, r2 -> rotation matrix and translation vector:
  
  if (nargin<2)|isempty(dir), dir=0; end
  if dir,
    s=max(Mag(r1(:,3),1),Mag(r2(:,3),1));
    if s==0, s=1; end
    if dir==2,
      r1(:,2)=r1(:,3)+r1(:,2)/Mag(r1(:,2),1)*s;
      r2(:,2)=r2(:,3)+r2(:,2)/Mag(r2(:,2),1)*s;
    end
    if (dir==1)|(dir==2),
      r1(:,1)=r1(:,3)+r1(:,1)/Mag(r1(:,1),1)*s;
      r2(:,1)=r2(:,3)+r2(:,1)/Mag(r2(:,1),1)*s;
    end
  end
  
  A=[r1(:,1)-r1(:,2),r1(:,2)-r1(:,3),r1(:,3)-r1(:,1)];
  B=[r2(:,1)-r2(:,2),r2(:,2)-r2(:,3),r2(:,3)-r2(:,1)];
  
  [s,c]=sort(Mag(A,1));
  A(:,c(3))=cross(A(:,c(1)),A(:,c(2)));
  A=A*diag(1./Mag(A,1));
  B(:,c(3))=cross(B(:,c(1)),B(:,c(2)));
  B=B*diag(1./Mag(B,1));
  
  R=B/A;
  t=mean(r2-R*r1,2);
  
end

