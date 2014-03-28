
function B=LinRel(A,ny,nx,my,mx)

% B=LinRel(A,ny,nx) solves the equation
%   y = A * x
% for y(ny) and x(nx) to get the matrix B which represents the 
% linear relation between x and y in the form
%   [y(ny);x(nx)] = B * [y(my);x(mx)], 
% with
%   my = setdiff(1:size(A,1),ny),
%   mx = setdiff(1:size(A,2),nx),
% mx and my being the x- and y-indices of the new independent 
% variables, nx and ny being the x- and y-indices of the new 
% dependent variables. mx and my are sorted in ascending order.
%
% B=LinRel(A,ny,nx,my,mx) does the same, but mx and my are 
% explicitly given, so the order of the new independent variables
% can be influenced. In this case [ny,nx,my,mx] need not be the 
% full set of variables; however [my,mx] must, in any case, 
% have size(A,1) variables less than the total number of variables.
%
% All dimensions from the 3rd upwards are treated in parallel.

s=size(A);

ny=ny(:)';
nx=nx(:)';

if (nargin<4),
  my=setdiff(1:s(1),ny);
end
my=my(:)';
py=setdiff(1:s(1),my);

if (nargin<5),
  mx=setdiff(1:s(2),nx);
end
mx=mx(:)';
px=setdiff(1:s(2),mx);

E=eye(s(1));

B=zeros([length(py)+length(px),length(my)+length(mx),s(3:end)]);

for k=1:prod(s(3:end)),
%  B(:,:,k)=[E(:,py),-A(:,px,k)]\[-E(:,my),A(:,mx,k)];
  B(:,:,k)=[E(:,py),-A(:,px,k)]\[-E(:,my),A(:,mx,k)];

end

% take the subset of 1st index corresponding to [ny,nx]:

mx=zeros(1,max(s(1:2)));
mx(px)=1:length(px);

my=zeros(1,max(s(1:2)));
my(py)=1:length(py);

s=size(B);
s(1)=length(ny)+length(nx);

B=reshape(B([my(ny),length(py)+mx(nx)],:),s);
