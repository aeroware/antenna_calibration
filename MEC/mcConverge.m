function [ant,cs]=mcConverge(epsilon, l, f,a)

% mcConverge is a script, which tests for an optimum number of segments. It
% starts with 11 segments and increses the number by a factor of 2, adding 
% one for symmetry. It continues until the impedances converge. 
%
% The requirement is:
%
% abs(real(Zn-1)/real(Zn)-1) < epsilon
%
% and 
% 
% abs(imag(Zn-1)/imag(Zn)-1) < epsilon
%
% epsilon ... the accuracy to be achieved
% l ... length of dipole  
% f ... frequency
% ant ... optimized antenna structure
% cs ... current
% a...radius

nSegs=11;
fprintf('n= %i', nSegs);
ant=mcCreateDipole(nSegs,l,a);
[cs,Za]=mcGetSinCurrent(ant,f,0,0,1);

done=0;

while(done==0)
    Za_old=Za;
    nSegs=nSegs*2+1;
    
    fprintf('n= %i', nSegs);
    ant=mcCreateDipole(nSegs,l,a);
    [cs,Za]=mcGetSinCurrent(ant,f,0,0,1);
    
    if(abs(real(Za_old)/real(Za)-1) <= epsilon)
        if(abs(imag(Za_old)/imag(Za)-1) <= epsilon)
            done=1;
        end
    end
end % do


