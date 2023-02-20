function fct_check_toolboxes
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
hasIPT = license ('test', 'image_toolbox');
if ~hasIPT
    error('Image Processing Toolbox is not installed. Please get the toolbox via MATLAB add-ons');
end
end