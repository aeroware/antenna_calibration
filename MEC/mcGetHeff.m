function Heff=mcGetHeff(ant,cs, n,freqrelsqu)

%   function Heff=mcGetHeff(ant,cs)
%
%   This function computes the effective length vector of the driven
%   dipole. It returns it as vector. In the present configuration (dipole),
%   the effective length vector always points in the z-direction, but
%   to return a vector is for future attempts to implement a 3D solver.
%
%   ant         ...antenna structure
%   cs          ...current system
%   n           ...direction of incident field
%
%   11.2010 by Thomas Oswald

if nargin < 5
    ioneffect=0;
    if nargin < 4
        freqrelsqu=0;
        if nargin < 3
            n=[1,0,0];
            if nargin < 2
                error('not enough parameters');
            end
        end
    end
end

[A,E,B]=mcFarField(ant,cs, n,freqrelsqu,ioneffect);

Heff=A/cs.I(cs.feeds)/1e-7;