function PLT = fct_prepare_displacement(INPUT,Du,Dv,Dw)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
switch INPUT.disp_component
    case 'Du'
        PLT.plot_what = Du;
        PLT.label     = 'Displacement Du (mm)';
        PLT.limits    = [-0.7 0.7];
    case 'Dv'
        PLT.plot_what = Dv;
        PLT.label     = 'Displacement vu (mm)';
        PLT.limits    = [-0.5 0.5];
    case 'Dw'
        PLT.plot_what = Dw;
        PLT.label     = 'Displacement Dw (mm)';
        PLT.limits    = [-0.5 0.5];
    case 'D2'
        PLT.plot_what = sqrt(Du.^2 + Dv.^2);
        PLT.label     = 'Total displacement 2D (mm)';
        PLT.limits    = [0 1];
    case 'D3'
        PLT.plot_what = sqrt(Du.^2 + Dv.^2 + Dw.^2);
        PLT.label     = 'Total displacement 3D (mm)';
        PLT.limits    = [0 1];
    otherwise
end
end