function antout=Convert2Patches(antin,titl)

% converts the wire-grid to a pach model to be used by CONCEPT II
%   antin...the antenna structure holding the model
%   titl ...the name of the model

ant2=Wire2Patch(antin,titl,1);
ant3=SplitTris(ant3);
antout=ant3;