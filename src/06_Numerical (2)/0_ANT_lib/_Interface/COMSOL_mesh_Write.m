function fem=COMSOL_mesh_WriteOut(ant,varargin)
% [fem,mesh]=COMSOL_mesh_WriteOut(ant,varargin)
% takes the 3D mesh from the antenna ant structure and converts it into a
% COMSOL fem strutur, and maybe writes it to a file
%
% ATTN: Matlab has to be started with COMSOL!
%
% *************************************************************************
%  fem  : contains the complete structure
%  mesh : only the mesh
%
% ant                  : antenna grid structure
% WorkingDir           : ....
% Atta_COMSOL_mesh_OUT : filename
%
% *************************************************************************
% 0.50 - 30.03.2010: initial release (altered from COMSOL_mesh_ReadIn.m
% 0.00 - 00.00.0000:  
% 0.00 - 00.00.0000:  
% *************************************************************************

if ~exist('ant','var')||isempty(ant),
    error('   no structure provided');
end

if exist('fem','var')
    clear fem;
end

if exist('mesh','var')
    clear mesh;
end

coord = ant.Geom';
edg = ant.Desc';
el{1} = cell(1,0);

% % ---------- wolfgang input
% for n=1:length(ant.Desc2d),
%    bla=ant.Desc2d{n}([2:end,1]);
%    ant.Desc(end+1:end+length(bla),:)=[ant.Desc2d{n}(:),bla(:)];
% end
% 
% edg = ant.Desc';
% % ---------- wolfgang input

% vtx=[];
% edg=[];
tri=[];
quad=[];

% MAIN LOOP:
% ----------

for n=1:length(ant.Desc2d)
    face=cell2mat(ant.Desc2d(n));
    if length(face)<4
        tri=[tri face'];
    else                          % change 4rd and 3rd coordinate to fit in the Ant structure
        face(3:4)=face(4:-1:3);   % COMSOL does spawn 2 vectors and connects the tips
        quad=[quad face'];        % Ant does number it circle wise
   end        
end

% el{1}= struct('type','vtx','elem',vtx);
el{1}= struct('type','edg','elem',edg);
el{2}= struct('type','tri','elem',tri);
el{3}= struct('type','quad','elem',quad);

mesh = femmesh(coord,el);
mesh = meshenrich(mesh);

% fem = mesh2geom(fem,'srcdata','deformed','frame','ale');
fem.geom = geomobject(mesh);
fem.mesh = mesh;

flsave('fem',fem);





