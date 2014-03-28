
% TestTransferVal

x=[1,2,3;2,3,4];

rand('state',0);

y=rand(2,3,3);

z=rand(2,3,3,3);

Tc={z,y; 0.8*y,y(:,:,1); 0.7*x,[]};
Tc1=Tc(fliplr(1:size(Tc,1)),:);

jk=j;
e=[1,0,0];

T=TransferVal(Tc1,jk,e)

isequal(T,...
  (mt((mt(Tc{1,1},e.')+Tc{1,2})*jk + Tc{2,1},e.') + Tc{2,2})*jk + Tc{3,1})
