function fct_plot_displacements(X,Y,PLT,ch,valid_x,valid_y)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
s = fill(valid_x(ch),valid_y(ch),[1.0 1.0 1.0]);
hold on

pc = pcolor(X,Y,PLT.plot_what);
pc.FaceColor = 'interp';
pc.EdgeColor = 'none';
pc.FaceAlpha = 'interp';
pc.AlphaData = PLT.plot_what;
alphamap(PLT.alpha_map)

cb = colorbar('Location','eastoutside');
cb.Label.Interpreter = 'latex';
cb.Label.String = PLT.label;
cb.Label.FontSize = 16;
% clim(PLT.limits)
end