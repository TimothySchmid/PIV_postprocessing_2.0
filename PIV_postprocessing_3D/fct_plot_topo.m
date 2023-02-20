function fct_plot_topo(X,Y,PLT,ch,valid_x,valid_y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
z_comp = -4 * ones(length(valid_x(ch)));
s = fill3(valid_x(ch),valid_y(ch),z_comp,[0.5 0.5 0.5]);
hold on

sf = surf(X,Y,PLT.plot_what);
sf.FaceColor = 'interp';
sf.EdgeColor = 'none';

grid off
view(2)

lightangle(45,85)
sf.FaceLighting = 'flat';
sf.AmbientStrength = 0.8;
sf.DiffuseStrength = 0.8;
sf.SpecularStrength = 0.9;
sf.SpecularExponent = 25;
sf.BackFaceLighting = 'unlit';

cb = colorbar('Location','eastoutside');
cb.Label.Interpreter = 'latex';
cb.Label.String = PLT.label;
cb.Label.FontSize = 16;
clim(PLT.limits)
end