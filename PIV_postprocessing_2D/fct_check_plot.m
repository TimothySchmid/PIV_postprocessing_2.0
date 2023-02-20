function fct_check_plot(EXP, U0, V0, Du, Dv, iRead)
%fct_check_plot --> show control plot to check interpolated data etc.
%   Detailed explanation goes here
  switch EXP.check_plot
      case 'yes'
%           clf
          figure(1)
          set(gcf,'Units','normalized','Position',[.2 .2 .6 .5])
          cmap = customcolormap([0 .25 .5 .75 1], {'#9d0142','#f66e45','#ffffbb','#65c0ae','#5e4f9f'});
          colormap(cmap)
          
          subplot(2,2,1)
          pcolor(U0'); shading interp; axis equal; colorbar
          title('U0 raw data')
          axis tight
          
          subplot(2,2,2)
          pcolor(Du'); shading interp; axis equal; colorbar
          title('Du corrected data')
          axis tight
          
          subplot(2,2,3)
          pcolor(V0'); shading interp; axis equal; colorbar
          title('V0 raw data')
          axis tight
          
          subplot(2,2,4)
          pcolor(Dv'); shading interp; axis equal; colorbar
          title('Dv corrected data')
          axis tight
          
          sgtitle(['Time step: ', num2str(iRead)])
          drawnow
          
      case 'no'
      otherwise
  end
end

