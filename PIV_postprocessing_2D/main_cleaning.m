%
% ----------------------------------------------------------------------- %
% FILE NAME:
%   main_cleaning.m
%
% DESCRIPTION
%   loads .vc7 files from DaVis and cleans data, interpolates missing data
%   and corrects the topography. New data is stored in a new folder as .mat
%   files. Two ways of cleaning:
%   - EXP.cleaning_type --> string; two ways are possible:
%
%   1) 'default'
%   - Uses the universal outlier detection. Westerweel, J. and Scarano, F.
%   (2005). Universal outlier detection for PIV data. Experiments in
%   fluids, 39(6):1096-1100.
%
%   - EXP.outlier.threshmed --> double; noise threshold (default = 1)
%   - EXP.outlier.eps --> double; epsilon value (default = 1e-1)
%   - EXP.outlier.neighbour --> double; how many neighbouring data points
%   should be taken into account for interpolation (default = 7 --> 7x7)
%
%   2) 'DCT-PLS'
%   - Uses robust smoothing according to the DCT-PLS algorithm
%   Garcia, D. (2010). Robust smoothing of gridded data in one and higher
%   dimensions with missing values. Computational statistics & data
%   analysis, 54(4):1167-1178.
%
%   - EXP.DCT_PLS --> double; smoothing value (default = 1e-2)
%
% INPUT:
%   - EXP.name --> string; name of the experiment ('EXP_xxxx') -
%   - EXP.data_choice --> string; which data set (either incremental or
%   (cumulative)) ('vc_inc' or 'vc_sum')
%   - EXP.check_plot --> string; if control plot should be shown or not
%   ('yes' or 'no')
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
% February 2023; Last revision: 19/02/2023 
% Successfully tested on a Mac 64 bit using macOS Monterey
% (Vers. 9.13.0.2126072) and MATLABR2022b

% ======================================================================= %

[parent_folder, ~] = fileparts(mfilename('fullpath'));
cd(parent_folder)
restoredefaultpath

clear
close all
clc

fct_check_toolboxes

% INPUT PARAMETERS
% ======================================================================= %
EXP.name              = 'EXP_1068';            % --> 'experiment name'
EXP.data_choice       = 'vc_inc';              % --> 'data set name'


EXP.check_plot        = 'no';                  % --> 'yes'/'no'

EXP.cleaning_type     = 'default';             % --> 'default'/'DCT-PLS'

% for default cleaning
EXP.outlier.threshmed = 1;          %1         % --> noise threshold
EXP.outlier.eps       = 1e-1;       %1e-2      % --> estimated measurement noise level
EXP.outlier.neighbour = 7;                     % --> neighborhood radius: 1 = 3x3, 2 = 5x5 etc.

% for DCT-PLS algorithm
EXP.DCT_PLS           = 1e-2;                  % --> value for DCT-PLS data correction
% ======================================================================= %


% SET PATHS TO FUNCTIONS AND MAKE FOLDERS
% ----------------------------------------------------------------------- %
parent_path  = pwd;
addpath(parent_path)
addpath 'customcolormap'

if isunix
    addpath([parent_path, '/readimx-v2.1.8-osx']);   % Mac
else
    addpath([parent_path, '/readimx-v2.1.9-win64']); % Windows
end

path_to_experiment = [parent_path, '/', EXP.name];
path_to_data = [path_to_experiment, '/', EXP.data_choice];

cd(path_to_experiment)

mkdir([EXP.data_choice, '_clean'])
clean_data_path = [path_to_experiment '/' EXP.data_choice '_clean'];

cd(clean_data_path)
mkdir metadata
metadata_path = [clean_data_path '/metadata'];

% get data list and make new folder for mat files
cd(path_to_data)
files = dir('*.vc7');
files(strncmp({files.name}, '.', 1)) = [];
n = length(files);


% LOCATE DISPLACEMENT COMPONENTS
% ----------------------------------------------------------------------- %
vc_struc_init = readimx(files(1).name);

% search for correct places
loc_u = fct_find_location(vc_struc_init,'U0');
loc_v = fct_find_location(vc_struc_init,'V0');
loc_m = fct_find_location(vc_struc_init,'ENABLED');

% search image interval

% SCALING VALUES FOR COORDINATE SYSTEM
% ----------------------------------------------------------------------- %
[slope_x, offset_x, step_x] = fct_get_scaling(vc_struc_init, 'X');
[slope_y, offset_y, step_y] = fct_get_scaling(vc_struc_init, 'Y');
[slope_i, offset_i] = fct_get_scaling(vc_struc_init, 'I');


% ASSEMBLE COORDINATE SYSTEM
% ----------------------------------------------------------------------- %
dim = size(vc_struc_init.Frames{1}.Components{loc_u}.Planes{:});

xcoords = slope_x * (linspace(0, dim(1), dim(1)) * step_x) + offset_x;
ycoords = slope_y * (linspace(0, dim(2), dim(2)) * step_y) + offset_y;

% write experiment data and coordinates
savevar = [metadata_path '/coordinate_system'];
save(savevar, '*coords', 'slope*', 'offset*', 'step*', '-v7.3')


% WRITE META DATA
% ----------------------------------------------------------------------- %
EXP = fct_write_metadata(vc_struc_init, EXP);

clearvars vc_struc_init slope_* offset_* *coords dim savevar step_* ...
    -except slope_i


% RUN THROUGH FILES
% ----------------------------------------------------------------------- %
tStart = tic;

fct_print_statement('starting')
fct_print_statement('cleaning')

for iRead = progress(1:n)
    
  % get step
    cd(path_to_data)
    step_now = files(iRead).name;

  % get current .vc7 structure
    vc_struc = readimx(step_now);
    
  % prepare mask
    M0 = logical(vc_struc.Frames{1}.Components{loc_m}.Planes{:});
    is_valid = fct_prepare_mask(M0,1);
    
    clean_mask = double(is_valid);
    clean_mask(clean_mask==0) = NaN;
  
  % get needed components
    U0 = vc_struc.Frames{1}.Components{loc_u}.Planes{:};
    V0 = vc_struc.Frames{1}.Components{loc_v}.Planes{:};
    
  % clean extracted buffers
    switch EXP.cleaning_type
        case 'default'
            % default (slower but more robust for "nasty" data)
            [U_temp, V_temp] = fct_clean_raw_data(U0, V0, EXP, is_valid);
        case 'DCT-PLS'
            % DCT-PLS filtering (works well and fast for "good" data)
            U_temp = fct_clean_raw_data_DCT(U0, clean_mask, is_valid, EXP);
            V_temp = fct_clean_raw_data_DCT(V0, clean_mask, is_valid, EXP);
        otherwise
            error('not clear how data should be cleared. Check spelling of EXP.cleaning_type')  
    end
    
    savevar = [metadata_path '/meta_data'];
    save(savevar, 'EXP', '-v7.3')
    
  % scale new variables
    Du = single(U_temp * slope_i);
    Dv = single(V_temp * slope_i);
    
  % control plot
    fct_check_plot(EXP, U0, V0, Du, Dv, iRead)
    
  % write new data as 7.3 .mat file (can also be read in python)
    file_name = strrep(step_now, 'vc7', 'mat');
    savevar = [clean_data_path '/' file_name];
    
    save(savevar, 'Du', 'Dv', 'is_valid','-v7.3')
    
end

fct_print_statement('ending', tStart)

restoredefaultpath
