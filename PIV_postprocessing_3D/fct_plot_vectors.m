function fct_plot_vectors(X,Y,Du,Dv,INPUT,is_valid)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% find nice vector distribution

mask = double(is_valid);
mask(mask==0) = NaN;

[x_size,y_size] = size(mask);

mid_x = round(x_size/2);
mid_y = round(y_size/2);

x_data_width = Du(:,mid_y);
y_data_width = Du(mid_x,:);

% valid positions along the model width
all_vec_pos_y = find(~isnan(y_data_width));
y_pos_first   = all_vec_pos_y(1);
y_pos_last    = all_vec_pos_y(end);

margin = 5;

y_vec_clean = round(linspace(y_pos_first+margin,y_pos_last-margin,INPUT.yvectors));

% valid positions along the model length
all_vec_pos_x = find(~isnan(x_data_width));

% get estimated model aspect ratio
ratio = length(all_vec_pos_x)/length(all_vec_pos_y);
INPUT.xvectors = floor(INPUT.yvectors * ratio);

vec_step_x = round(length(all_vec_pos_x)/INPUT.xvectors)+1;

q = quiver(X(1+margin:vec_step_x:end-margin,y_vec_clean),...
           Y(1+margin:vec_step_x:end-margin,y_vec_clean),...
           Du(1+margin:vec_step_x:end-margin,y_vec_clean),...
           Dv(1+margin:vec_step_x:end-margin,y_vec_clean),...
           'color',INPUT.vec_color,'LineWidth',1.5);
q.AutoScaleFactor = 0.3;

% fct_ncquiverref(X(1+margin:vec_step_x:end-margin,y_vec_clean),...
%            Y(1+margin:vec_step_x:end-margin,y_vec_clean),...
%            Du(1+margin:vec_step_x:end-margin,y_vec_clean),...
%            Dv(1+margin:vec_step_x:end-margin,y_vec_clean), ...
%            'mm',30,'true',INPUT.vec_color);
end