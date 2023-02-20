function fct_save_figure(INPUT,path_to_experiment,iRead,hAx)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
cd(path_to_experiment)

if isfolder('pngs')
else
    disp('creating png folder')
    mkdir pngs
end

path_to_pngs = [path_to_experiment, '/pngs'];
cd (path_to_pngs)

switch INPUT.datatype
    case 'vc_inc'
        type_folder = 'incremental';
    case 'vc_sum'
        type_folder = 'cumulative';
    otherwise
end

if isfolder(type_folder)
else
    disp(['Creating ', type_folder, ' subfolder'])
    mkdir(type_folder)
end

path_to_type_folder = [path_to_pngs, '/', type_folder];
cd(path_to_type_folder)

if isfolder(INPUT.plot_choice)
else
    disp(['Creating ', INPUT.plot_choice, ' subfolder'])
    mkdir(INPUT.plot_choice)
end

switch INPUT.plot_choice
    case 'topography'
        path_to_plot_choice = [path_to_type_folder, '/topography'];
        cd(path_to_plot_choice)
        name_string = [INPUT.plot_choice, '_min_', num2str(iRead,'%4.4d')];
        exportgraphics(hAx,[path_to_plot_choice,'/',name_string,'.png'],'Resolution',INPUT.resolution)

    case 'displacement'
        path_to_plot_choice = [path_to_type_folder, '/displacement'];
        cd(path_to_plot_choice)

        foldername = INPUT.disp_component;
        if isfolder(foldername)
        else
            mkdir(foldername)
        end
        path_to_folder = [path_to_plot_choice, '/', foldername];

        cd(path_to_folder)
        name_string = [INPUT.plot_choice,'_', foldername, '_min_', num2str(iRead,'%4.4d')];
        exportgraphics(hAx,[name_string,'.png'],'Resolution',INPUT.resolution)

    case 'strain'
        path_to_plot_choice = [path_to_type_folder, '/strain'];
        cd(path_to_plot_choice)

        subfoldername = INPUT.strain_type;
        if isfolder(subfoldername)
        else
            mkdir(subfoldername)
        end

        path_to_subfolder = [path_to_plot_choice, '/', subfoldername];

        cd(path_to_subfolder)

        foldername = INPUT.strain_component;

        if isfolder(foldername)
        else
            mkdir(foldername)
        end

        path_to_folder = [path_to_subfolder, '/' foldername];

        cd(path_to_folder)

        strain_type = INPUT.strain_mode;

        if isfolder(strain_type)
        else
            mkdir(strain_type)
        end

        path_to_strain_type = [path_to_folder, '/', strain_type];

        cd(path_to_strain_type)

        name_string = [foldername, '_min_', num2str(iRead,'%4.4d')];
        exportgraphics(hAx,[name_string,'.png'],'Resolution',INPUT.resolution)

    otherwise
end
end