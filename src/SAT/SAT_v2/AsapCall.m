
function [Status,Result]=AsapCall(AsapExe)

% [Status,Result]=AsapCall(AIF,AOF,AsapExe)
% Call ASAP with ASAP input-file(s) AIF and store ASAP's output 
% to the corresponding file(s) AOF. AIF and AOF may be strings,
% 2-dimensional matrices of row-strings or 1-dimensional 
% cell arrays of strings. The optional string AsapExe gives
% the name of the executable ASAP program file (default is 
% defined at the beginning of the function). 
% The variables Status and Result are those returned by the 
% 'dos' function that is used to issue the ASAP executable as 
% a command to the DOS operating system.
%
% Revision 01.08 by Thomas Oswald:
% AIF and AOF not used any more. standard files asapin.dat and asapout.dat
% are always used.

% Default ASAP executable:

    if nargin<1, 
        AsapExe='asap3g.exe'; 
    end

    if ~exist(AsapExe,'file'),
        error(['Could not find ASAP executable ''',AsapExe,'''']);
    end

    fprintf('ASAP calculations running ... ');
    [Status,Result]=dos(AsapExe);
    fprintf('finished.\n');
end

