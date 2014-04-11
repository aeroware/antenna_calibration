
function [A,T,Ts]=PowerArea(Ant,Op,er,ZL)

% [A,T,Ts]=PowerArea(Ant,Op,er,ZL) calculates the effective area A
% for each feed and the given directions of incidence, er, accordingly
% A is of size d x f, where d is the number of given directions=size(er,1) 
% and f is the number of feeds=size(Op.Feed,1). 
% ZL is an optional load impedance matrix of size f x f, default is
 impedance matching, i.e. ZL=conj(, 
% which represents open feeds. The returned variables T and Ts
% are the corresponding transfer matrices as obtained by AntTransfer, which 
% are actually used to calculate A.


[T,Ts,FF]=AntTransfer(Ant,Op,er,ZL);
 
A=