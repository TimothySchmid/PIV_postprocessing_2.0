function fct_plot_strains(X,Y,PLT,ch,valid_x,valid_y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
s = fill(valid_x(ch),valid_y(ch),[0.5 0.5 0.5]);
hold on

pc = pcolor(X,Y,PLT.plot_what);
pc.FaceColor = 'interp';
pc.EdgeColor = 'none';

cb = colorbar('Location','eastoutside');
cb.Label.Interpreter = 'latex';
cb.Label.String = PLT.label;
cb.Label.FontSize = 16;
% clim(PLT.limits)
end
