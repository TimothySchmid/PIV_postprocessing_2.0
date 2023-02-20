function [Du, Dv, Dw] = fct_temporal_smoothing(INPUT,iRead,n,nx,ny,files)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    % check how many neighbours per side
    neighbours_per_side = floor(INPUT.temporal_smoothing/2);

    % find first and last time steps
    first_t = iRead - neighbours_per_side;
    last_t  = iRead + neighbours_per_side;

    % create time step array
    timestep_vec = first_t:1:last_t;

    % remove invalid points for points close to 1 or n
    timestep_vec(timestep_vec<1) = [];
    timestep_vec(timestep_vec>n) = [];

    % get number of time steps involved
    abs_num_of_timesteps = length(timestep_vec);

    % initialize 3D matrices for Du and Dv for all steps considered
    files_in_list_Du = zeros(nx,ny,abs_num_of_timesteps);
    files_in_list_Dv = zeros(nx,ny,abs_num_of_timesteps);
    files_in_list_Dw = zeros(nx,ny,abs_num_of_timesteps);

    % loop through time steps
    for ifile = 1:abs_num_of_timesteps

        file_in_list_now = files(timestep_vec(ifile)).name;

        load(file_in_list_now, 'Du', 'Dv', 'Dw')

        files_in_list_Du(:,:,ifile) = Du;
        files_in_list_Dv(:,:,ifile) = Dv;
        files_in_list_Dw(:,:,ifile) = Dw;

        clearvars Du Dv Dw file_in_list_now
    end

Du = mean(files_in_list_Du,3);
Dv = mean(files_in_list_Dv,3);
Dw = mean(files_in_list_Dw,3);
end
