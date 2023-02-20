% Alphamap_maker test version


% INPUT
% ======================================================================= %
INPUT.mapstyle  = 'none';

INPUT.clim      = [-2.5 2.5];
INPUT.shift     = 0;
INPUT.squeeze   = 2.1;
INPUT.save_map  = 'yes';
% ======================================================================= %


% colours
blue = [0 0.4470 0.7410];
red = [0.8500 0.3250 0.0980];
yellow = [0.9290 0.6940 0.1250];
purple = [0.4940 0.1840 0.5560];
green = [0.4660 0.6740 0.1880];

min_val = INPUT.clim(1);
max_val = INPUT.clim(2);

x_vec = linspace(min_val,max_val,1e3+1);

switch INPUT.mapstyle
    case 'none'
        y_vec = ones(size(x_vec));

        bend_start = 1;
        bend_end   = length(x_vec);

    case 'sequential'
        y_vec = erf(INPUT.squeeze*x_vec - INPUT.shift*INPUT.squeeze);

        % normalization
        min_amp = min(y_vec);
        y_vec = y_vec - min_amp;
        max_amp = max(y_vec);
        y_vec = y_vec ./ max_amp;

        % find bending
        low_vals = find(y_vec<=0.01);
        high_vals = find(y_vec>=0.99);

        bend_start = (low_vals(end)+1);
        bend_end   = (high_vals(1)-1);

    case 'diverging'
        y_vec = 5*-exp(-((x_vec - INPUT.shift).^2) ./ 2*INPUT.squeeze^2)+1;
        y_vec(y_vec<=0) = 0;

        % find bending
        low_vals = find(y_vec<=0.99);

        bend_start = (low_vals(1)-1);
        bend_end   = (low_vals(end)+1);
    otherwise
end

% patch
x_patch = [x_vec(bend_start),x_vec(bend_end),x_vec(bend_end),x_vec(bend_start)];
y_patch = [0,0,1,1];


% figure
figure(1)
clf

set(gcf, 'Units', 'normalized', 'Position', [0.15 0.2 0.7 0.5])

patch(x_patch,y_patch,yellow,'FaceAlpha',0.3)
hold on

yline(0,'--','Color',blue,'LineWidth',2,'HandleVisibility','off')
yline(1,'--','Color',blue,'LineWidth',2,'HandleVisibility','off')
xline(min_val,'--','Color',red,'LineWidth',2,'HandleVisibility','off')
xline(max_val,'--','Color',red,'LineWidth',2,'HandleVisibility','off')
xline(x_vec(bend_start),'--','Color',yellow,'LineWidth',2,'HandleVisibility','off')
xline(x_vec(bend_end),'--','Color',yellow,'LineWidth',2,'HandleVisibility','off')

plot(x_vec,y_vec,'k','LineWidth',2)

xticks(INPUT.clim(1):0.5:INPUT.clim(2))
yticks(0:0.5:1)

hAx = gca;
hAx.LineWidth = 2;
hAx.FontSize = 14;

title('Alpha map', 'FontSize', 18)
xlabel('color limits')
ylabel('Opacity')
legend('Transition','Alpha map')

grid on

axis equal
axis([min_val-0.1 max_val+0.1, -0.1, 1.1])

box on
set(gca, 'Layer', 'Top')

% save figure
switch INPUT.save_map
    case 'yes'
        dlgTitle    = 'Save alpha map';
        dlgQuestion = 'Do you wish to overwrite the existing alpha map?';
        choice = questdlg(dlgQuestion,dlgTitle,'Yes','No', 'Yes');

        alpha_map = y_vec;
        save('alpha_map.mat', 'alpha_map')
    case 'no'

    otherwise
end

