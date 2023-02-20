%
% ----------------------------------------------------------------------- %
% FILE NAME:
%   main_plotting_sum.m
%
% DESCRIPTION
%   loads cleaned .mat files for plotting. Displacements and
%   various types of strains can be visualized, vectors can be enabled.
%
% INPUT:
%   - INPUT.name --> string; name of the experiment ('EXP_xxxx') -
%   - INPUT.datatype --> string; which data set (either incremental or
%   (cumulative)) ('vc_inc' or 'vc_sum')
%
%   - INPUT.plot_choice --> string; chose between:
%           - 'displacement'
%           - 'strain'
%
%   DISPLACEMENTS
%   ====================================================================  %
%   - INPUT.disp_component --> string; which type of displacement:
%           - 'Du' x-displacement component
%           - 'Dv' y-displacement component
%           - 'D2' total displacement in plane
%
%   STRAINS
%   ====================================================================  %
%   - INPUT.strain_type --> string; which type of strain calculation
%           - 'infinitesimal' calculation according to small strain theory
%
%           INPUT.strain_component --> string; Chose from the following
%           components:
%                   - 'exx' axial strain in x-direction
%                   - 'exy' shear strain in x-direction
%                   - 'eyx' shear strain in y-direction (same as exy)
%                   - 'eyy' axial strain in y-direction
%                   - 'vorticity' (in deg/s) measure for local rotation
%                   - 'emax' magnitude of local extension
%                   - 'emin' magnitude of local shortening
%
%           - 'finite' calculation according to large strain theory
%
%           INPUT.strain_component --> string; Chose from the following
%           components:
%                   - 'Exx' axial strain in x-direction
%                   - 'Exy' shear strain in x-direction
%                   - 'Eyx' shear strain in y-direction (same as exy)
%                   - 'Eyy' axial strain in y-direction
%                   - 'Vorticity' (in deg/s) measure for local rotation
%                   - 'Emax' magnitude of local extension
%                   - 'Emin' magnitude of local shortening
% 
%           - 'stretch' stretch calculation using polar decomposition and
%           Cauchy-Green deformatino tensor C
%                   - 'U11' axial stretch in x-direction using right
%                   stretch tensor U
%                   - 'U12' shear stretch in x-direction using right
%                   stretch tensor U
%                   - 'U21' shear stretch in y-direction using right
%                   stretch tensor U
%                   - 'U22' axial stretch in y-direction using right
%                   stretch tensor U
%                   - 'V11' axial stretch in x-direction using left
%                   stretch tensor V
%                   - 'V12' shear stretch in x-direction using left
%                   stretch tensor V
%                   - 'V21' shear stretch in y-direction using left
%                   stretch tensor V
%                   - 'V22' axial stretch in y-direction using left
%                   stretch tensor V
%                   - 'ANG' local rotation (in deg)
%
%                   INPUT.strain --> string; plotting strains in %
%                   INPUT.strain_rate -->; plotting strain_rates according
%                   to image interval dt
%
%   COLORMAPS
%   ====================================================================  %
%   chose colormap according to the list below. Take care to use meaningful
%   colormaps. For displcament and strain components as well as topography
%   divergent colormaps are better suited as they clearly distinguish
%   between negative and positive values. Unidirectional components such as
%   total displacements or magnitudes of extension ([0 max]) or magnitudes
%   of shortening ([min 0]) unidirectional colormaps are better suited. For
%   cyclic data (e.g., rotation ([0 360... 361 = 0 ...])) colormaps
%   indicated by an O are suited.
%
%       - 'viridis'
%       - 'inferno'
%       - 'plasma'
%       - 'magma'
%       - 'vik'
%       - 'roma'
%       - 'romaO'
%       - 'davos'
%       - 'oleron'
%       - 'cork'
%       - 'broc'
%       - 'vik10'     colormap vik with ten steps
%       - 'vik25'     colormap vik with 25 steps
%       - 'berlin'
%       - 'rgb'       discrete colormap
%       - 'custom'    custom colormap
%
%   COLORBAR RANGE
%   ====================================================================  %
%   Set colorbar range either automatically or manually
%   INPUT.activate_clim --> string; chose how to define colorbar range
%       - 'automatic' (best range for each time step)
%       - 'manual' (set colorbar range and fix it for all time steps
%
%   INPUT.set_clim  --> row vector with two entries ([min max]) that is
%   used when colorbar range is set to 'manual'
% 
%   VECTORS
%   ====================================================================  %
%   vectors can be activated or deactivated.
%   INPUT.plot_vectors --> string; activating/deactivating vectors
%       - 'yes'
%       - 'no'
%
%   INPUT.yvectors --> double; # of vectors in the y direction
%   INPUT.color_vectors --> rgb tripplet between 0 and 1
%   (e.g.,[1 0.75 0.1])
%
%   DEFINING MODEL ORIGIN
%   ====================================================================  %
%   linear shift in x- and y-direction to set the model origin
%   INPUT.check_origin --> string; activates/deactivates crosshair
%       - 'yes'
%       - 'no'
%
%   INPUT.xcorrection --> double; shift in x-direction
%   INPUT.ycorrection --> double; shift in y-direction
%
%   SAVING FIGURES
%   ====================================================================  %
%   INPUT.save_figures --> string;
%       - 'yes'
%       - 'no'
%
%   INPUT.resolution --> double; set resolution for saving figures (dpi)
%
% Latest DaVis readimx version for MacOS and Windows: <a href="matlab:
%  web('https://www.lavision.de/en/downloads/software/matlab_add_ons.php')
%  ">DaVis readimx</a>.
% ----------------------------------------------------------------------- %

% Author: Timothy Schmid, PhD., geology
% Institute of Geological Sciences, University of Bern
% Baltzerstrasse 1, Office 207
% 3012 Bern, CH
% email address: timothy.schmid@geo.unibe.ch
% February 2023; Last revision: 17/02/2023 
% Successfully tested on a Mac 64 bit using macOS Monterey
% (Vers. 9.13.0.2126072) and MATLABR2022b

% ======================================================================= %

[parent_folder, ~] = fileparts(mfilename('fullpath'));
cd(parent_folder)
restoredefaultpath

clear
close all
clc

% INPUT
% ======================================================================= %
  INPUT.experimentname      = 'EXP_0000';
  INPUT.datatype            = 'vc_sum';
  
  INPUT.plot_choice         = 'strain';

  INPUT.disp_component      = 'Du';

  INPUT.strain_type         = 'infinitesimal';
  INPUT.strain_component    = 'vorticity';
  INPUT.strain_mode         = 'strain';

  INPUT.colormap            = 'broc';
  INPUT.activate_clim       = 'manual';
  INPUT.set_clim            = [-2, 2];

  INPUT.plot_vectors        = 'yes';
  INPUT.yvectors            = 8;
  INPUT.vec_color           = [0.75 0.25 0.25];

  INPUT.check_origin        = 'no';
  INPUT.xcorrection         = -115;
  INPUT.ycorrection         =  43;

  INPUT.cut_left            = 220;
  INPUT.cut_right           = 735;

  INPUT.save_figures        = 'no';
  INPUT.resolution          = 150;
% ======================================================================= %


% SET PATHS TO DATA
% ----------------------------------------------------------------------- %
path_main = pwd;
path_to_experiment = [path_main, '/', INPUT.experimentname];
path_to_data = [path_to_experiment, '/', INPUT.datatype '_clean'];

addpath(path_main)
addpath 'customcolormap'
addpath '_cmaps'

% load metadata and assemble coordinate grid
cd([path_to_data, '/metadata'])
load('coordinate_system.mat')
load('meta_data.mat')

dt = EXP.dt;

% correct corrdinates
xcoords = xcoords + INPUT.xcorrection;
ycoords = ycoords + INPUT.ycorrection;

[X,Y]   = ndgrid(xcoords,ycoords);
dx      = diff(xcoords(1:2));
dy      = diff(ycoords(1:2));
[nx,ny] = size(X);

cd(path_to_data)
files = dir('*.mat');
n = length(files);

% set initial coordinates
file_init = files(1).name;
load(file_init)

X0 = X;
Y0 = Y;
is_valid = fct_prepare_mask(logical(is_valid),10);
is_valid_0 = is_valid;

for iRead = (10:10:n) % start_position : increment : end_position
    
cd(path_to_data)
file_now = files(iRead).name;

load(file_now)

% update coordinates
X = X0 + double(Du);
Y = Y0 + double(Dv);

% clean boundaries
is_valid = single(is_valid_0);
is_valid(1:INPUT.cut_left,:) = NaN;
is_valid(INPUT.cut_right:end,:) = NaN;
is_valid(is_valid==0) = NaN;

Du = Du .* single(is_valid);
Dv = Dv .* single(is_valid);
X  = X  .* double(is_valid);
Y  = Y  .* double(is_valid);

is_valid(isnan(is_valid)) = 0;    

valid_x = X(logical(is_valid));
valid_y = Y(logical(is_valid));

valid_x(isnan(valid_x)) = [];
valid_y(isnan(valid_y)) = [];

ch = convhull(valid_x,valid_y,'Simplify',true);

% PREPARE PLOTTING COMPONENTS
% ----------------------------------------------------------------------- %
switch INPUT.plot_choice 
    case 'displacement'
        % Get displacements ready
        PLT = fct_prepare_displacement(INPUT,Du,Dv);
    case 'strain'
        % Assemble displacement gradient tensor H
        [~,dudx] = gradient(Du, dx);
        [dudy,~] = gradient(Du, dy);
        [~,dvdx] = gradient(Dv, dx);
        [dvdy,~] = gradient(Dv, dy);

        % Assemble Deformation gradient tensor F
        F(1,1,:,:) = dudx + 1;
        F(1,2,:,:) = dudy;
        F(2,1,:,:) = dvdx;
        F(2,2,:,:) = dvdy + 1;

        % Calculate strains
        PLT = fct_calculate_strain(INPUT,nx,ny,F,is_valid,dt);

    otherwise
end

% PLOTTING FIGURE
% ======================================================================= %
figure(1)
clf
set(gcf,'Units','normalized','Position',[.1 .1 .7 .7])

cmap = fct_colormap(INPUT);
colormap((cmap))

switch INPUT.plot_choice
    case 'displacement'
        % Plot displacement components
        fct_plot_displacements(X,Y,PLT,ch,valid_x,valid_y)
    case 'strain'
        % Plot strain data
        fct_plot_strains(X,Y,PLT,ch,valid_x,valid_y)
    otherwise
end

% red lines for adjusting coordinate system
switch INPUT.check_origin
    case 'yes'
        yline(0,'r-','LineWidth',2)
        xline(0,'r-','LineWidth',2)
    case 'no'
    otherwise
end

title(['Time: ', num2str(iRead), ' min'])
xlabel('Model length (mm)')
ylabel('Model width (mm)')

hAx = gca;
hAx.LineWidth = 2;
hAx.FontSize = 16;

axis equal
axis([-500 400 -170 170])

box on
set(gca, 'Layer', 'Top')

plot(valid_x(ch),valid_y(ch),'-k','LineWidth',3)

switch INPUT.plot_vectors
    case 'yes'
        fct_plot_vectors(X,Y,Du,Dv,INPUT,is_valid)
    case 'no'
    otherwise
end

switch INPUT.activate_clim
    case 'auto'
        clim('auto')
    case 'manual'
        clim([INPUT.set_clim])
end

drawnow

% SAVE FIGURES
% ======================================================================= %
switch INPUT.save_figures
    case 'yes'
        fct_save_figure(INPUT,path_to_experiment,iRead,hAx)
    case 'no'
    otherwise
end

end

restoredefaultpath
cd(path_main)
