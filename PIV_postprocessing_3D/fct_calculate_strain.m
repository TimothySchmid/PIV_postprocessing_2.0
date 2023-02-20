function PLT = fct_calculate_strain(INPUT,nx,ny,F,is_valid,dt)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

switch INPUT.strain_type
    case 'infinitesimal'
        e = NaN(2,2,nx,ny);

        for ix = 1:nx
            for iy = 1:ny
                if ~isnan(is_valid(ix,iy))

                    % get local deformation gradient tensor
                    F_loc = F(:,:,ix,iy);

                    % calculate local infinitesimal strain components
                    e_loc = 0.5 * (F_loc + F_loc') - eye(2,2);
                    e(:,:,ix,iy) = e_loc;

                end
            end
        end

        switch INPUT.strain_component
            case 'exx'
                switch INPUT.strain_mode
                    case 'strain'
                        PLT.plot_what = squeeze(e(1,1,:,:)) * 1e2;
                        PLT.label     = '$\epsilon_{xx}$ (\%)';
                        PLT.limits    = [-2 2];
                    case 'strain_rate'
                        PLT.plot_what = squeeze(e(1,1,:,:)) ./ dt;
                        PLT.label     = '$\dot{\epsilon}_{xx}$ (1/s)';
                        PLT.limits    = [-2 2] ./ dt .* 1e-2;
                    otherwise
                end

            case 'exy'
                switch INPUT.strain_mode
                    case 'strain'
                        PLT.plot_what = squeeze(e(1,2,:,:)) * 1e2;
                        PLT.label     = '$\epsilon_{xy}$ (\%)';
                        PLT.limits    = [-2.5 2.5];
                    case 'strain_rate'
                        PLT.plot_what = squeeze(e(1,2,:,:)) ./ dt;
                        PLT.label     = '$\dot{\epsilon}_{xy}$ (1/s)';
                        PLT.limits    = [-2.5 2.5] ./dt .* 1e-2;
                    otherwise
                end

            case 'eyx'
                switch INPUT.strain_mode
                    case 'strain'
                        PLT.plot_what = squeeze(e(2,1,:,:)) * 1e2;
                        PLT.label     = '$\epsilon_{yx}$ (\%)';
                        PLT.limits    = [-2.5 2.5];
                    case 'strain_rate'
                        PLT.plot_what = squeeze(e(2,1,:,:)) ./ dt;
                        PLT.label     = '$\dot{\epsilon}_{yx}$ (1/s)';
                        PLT.limits    = [-2.5 2.5] ./ dt .* 1e-2;
                    otherwise
                end

            case 'eyy'
                switch INPUT.strain_mode
                    case 'strain'
                        PLT.plot_what = squeeze(e(2,2,:,:)) * 1e2;
                        PLT.label     = '$\epsilon_{yy}$ (\%)';
                        PLT.limits    = [-2 2];
                    case 'strain_rate'
                        PLT.plot_what = squeeze(e(2,2,:,:)) ./ dt;
                        PLT.label     = '$\dot{\epsilon}_{yy}$ (1/s)';
                        PLT.limits    = [-2 2] ./ dt .* 1e-2;
                    otherwise
                end

            case 'vorticity'
                PLT.plot_what = squeeze(0.5 * (F(2,1,:,:) - F(1,2,:,:)));
                PLT.label     = 'vorticity (deg/s)';
                PLT.limits    = [-0.03 0.03];

            case 'emax'
                exx = squeeze(e(1,1,:,:));
                exy = squeeze(e(1,2,:,:));
                eyx = squeeze(e(2,1,:,:));
                eyy = squeeze(e(2,2,:,:));

                a = (exx + eyy) ./ 2;
                b = sqrt(((exx - eyy) ./ 2).^2 + (exy .* eyx));

                switch INPUT.strain_mode
                    case 'strain'
                        PLT.plot_what = (a + b) .* 1e2;
                        PLT.label     = '$\epsilon_{max}$ (\%)';
                        PLT.limits    = [0 3];
                    case 'strain_rate'
                        PLT.plot_what = (a + b) ./ dt;
                        PLT.label     = '$\dot{\epsilon}_{max}$ (1/s)';
                        PLT.limits    = [0 3] ./dt .* 1e-2;
                    otherwise
                end

            case 'emin'
                exx = squeeze(e(1,1,:,:));
                exy = squeeze(e(1,2,:,:));
                eyx = squeeze(e(2,1,:,:));
                eyy = squeeze(e(2,2,:,:));

                a = (exx + eyy) ./ 2;
                b = sqrt(((exx - eyy) ./ 2).^2 + (exy .* eyx));

                switch INPUT.strain_mode
                    case 'strain'
                        PLT.plot_what = (a - b) .* 1e2;
                        PLT.label     = '$\epsilon_{min}$ (\%)';
                        PLT.limits    = [-2 0];
                    case 'strain_rate'
                        PLT.plot_what = (a - b) ./ dt;
                        PLT.label     = '$\dot{\epsilon}_{min}$ (1/s)';
                        PLT.limits    = [-2 0] ./dt .* 1e-2;
                    otherwise
                end
            otherwise
        end

    case 'finite'
        E = NaN(2,2,nx,ny);

        for ix = 1:nx
            for iy = 1:ny
                if ~isnan(is_valid(ix,iy))

                    % get local deformation gradient tensor
                    F_loc = F(:,:,ix,iy);

                    % calculate local finite strain components
                    E_loc = 0.5 * (F_loc' * F_loc - eye(2,2));
                    E(:,:,ix,iy) = E_loc;

                end
            end
        end

        switch INPUT.strain_component
            case 'Exx'
                switch INPUT.strain_mode
                    case 'strain'
                        PLT.plot_what = squeeze(E(1,1,:,:)) * 1e2;
                        PLT.label     = '$\varepsilon_{xx}$ (\%)';
                        PLT.limits    = [-2 2];
                    case 'strain_rate'
                        PLT.plot_what = squeeze(E(1,1,:,:)) ./ dt;
                        PLT.label     = '$\dot{\varepsilon}_{xx}$ (1/s)';
                        PLT.limits    = [-2 2] ./ dt .* 1e-2;
                    otherwise
                end

            case 'Exy'
                switch INPUT.strain_mode
                    case 'strain'
                        PLT.plot_what = squeeze(E(1,2,:,:)) * 1e2;
                        PLT.label     = '$\varepsilon_{xy}$ (\%)';
                        PLT.limits    = [-2.5 2.5];
                    case 'strain_rate'
                        PLT.plot_what = squeeze(E(1,2,:,:)) ./ dt;
                        PLT.label     = '$\dot{\varepsilon}_{xy}$ (1/s)';
                        PLT.limits    = [-2.5 2.5] ./dt .* 1e-2;
                    otherwise
                end

            case 'Eyx'
                switch INPUT.strain_mode
                    case 'strain'
                        PLT.plot_what = squeeze(E(2,1,:,:)) * 1e2;
                        PLT.label     = '$\varepsilon_{yx}$ (\%)';
                        PLT.limits    = [-2.5 2.5];
                    case 'strain_rate'
                        PLT.plot_what = squeeze(E(2,1,:,:)) ./ dt;
                        PLT.label     = '$\dot{\varepsilon}_{yx}$ (1/s)';
                        PLT.limits    = [-2.5 2.5] ./ dt .* 1e-2;
                    otherwise
                end

            case 'Eyy'
                switch INPUT.strain_mode
                    case 'strain'
                        PLT.plot_what = squeeze(E(2,2,:,:)) * 1e2;
                        PLT.label     = '$\varepsilon_{yy}$ (\%)';
                        PLT.limits    = [-2 2];
                    case 'strain_rate'
                        PLT.plot_what = squeeze(E(2,2,:,:)) ./ dt;
                        PLT.label     = '$\dot{\varepsilon}_{yy}$ (1/s)';
                        PLT.limits    = [-2 2] ./ dt * 1e-2;
                    otherwise
                end

            case 'Vorticity'
                PLT.plot_what = squeeze(0.5 * (F(2,1,:,:) - F(1,2,:,:)));
                PLT.label     = 'vorticity (deg/s)';
                PLT.limits    = [-0.03 0.03];

            case 'Emax'
                Exx = squeeze(E(1,1,:,:));
                Exy = squeeze(E(1,2,:,:));
                Eyx = squeeze(E(2,1,:,:));
                Eyy = squeeze(E(2,2,:,:));

                A = (Exx + Eyy) ./ 2;
                B = sqrt(((Exx - Eyy) ./ 2).^2 + (Exy .* Eyx));

                switch INPUT.strain_mode
                    case 'strain'
                        PLT.plot_what = (A + B) .* 1e2;
                        PLT.label     = '$\varepsilon_{max}$ (\%)';
                        PLT.limits    = [0 3];
                    case 'strain_rate'
                        PLT.plot_what = (A + B) ./ dt;
                        PLT.label     = '$\dot{\varepsilon}_{max}$ (1/s)';
                        PLT.limits    = [0 3] ./dt .* 1e-2;
                    otherwise
                end

            case 'Emin'
                Exx = squeeze(E(1,1,:,:));
                Exy = squeeze(E(1,2,:,:));
                Eyx = squeeze(E(2,1,:,:));
                Eyy = squeeze(E(2,2,:,:));

                A = (Exx + Eyy) ./ 2;
                B = sqrt(((Exx - Eyy) ./ 2).^2 + (Exy .* Eyx));

                switch INPUT.strain_mode
                    case 'strain'
                        PLT.plot_what = (A - B) .* 1e2;
                        PLT.label     = '$\epsilon_{min}$ (\%)';
                        PLT.limits    = [-2 0];
                    case 'strain_rate'
                        PLT.plot_what = (A - B) ./ dt;
                        PLT.label     = '$\dot{\varepsilon}_{min}$ (1/s)';
                        PLT.limits    = [-2 0] ./dt .* 1e-2;
                    otherwise
                end
            otherwise
        end

    case 'stretch'
        U = NaN(2,2,nx,ny);
        V = NaN(2,2,nx,ny);
        R = NaN(2,2,nx,ny);
        A = NaN(nx,ny);

        for ix = 1:nx
            for iy = 1:ny
                if ~isnan(is_valid(ix,iy))

                    % get local deformation gradient tensor
                    F_loc = F(:,:,ix,iy);

                    % calculate stretches
                    [R_loc, U_loc, V_loc, ~, RotAngleDeg_now] = fct_PolarDecomposition(F_loc);

                    R(:,:,ix,iy) = R_loc;
                    U(:,:,ix,iy) = U_loc;
                    V(:,:,ix,iy) = V_loc;
                    A(ix,iy)     = RotAngleDeg_now;
                end
            end
        end

        switch INPUT.strain_component
            case 'U11'
                PLT.plot_what = (squeeze(U(1,1,:,:)) -1) .* 1e2;
                PLT.label     = '$U Stretch_{11}$ (\%)';
                PLT.limits    = [-2 2];
            case 'U12'
                PLT.plot_what = squeeze(U(1,2,:,:)) .* 1e2;
                PLT.label     = '$U Stretch_{12}$ (\%)';
                PLT.limits    = [-2.5 2.5];
            case 'U21'
                PLT.plot_what = squeeze(U(2,1,:,:)) .* 1e2;
                PLT.label     = '$U Stretch_{21}$ (\%)';
                PLT.limits    = [-2.5 2.5];
            case 'U22'
                PLT.plot_what = (squeeze(U(2,2,:,:)) -1) .* 1e2;
                PLT.label     = '$U Stretch_{22}$ (\%)';
                PLT.limits    = [-2 2];
            case 'V11'
                PLT.plot_what = (squeeze(V(1,1,:,:)) -1) .* 1e2;
                PLT.label     = '$V Stretch_{11}$ (\%)';
                PLT.limits    = [-2 2];
            case 'V12'
                PLT.plot_what = squeeze(V(1,2,:,:)) .* 1e2;
                PLT.label     = '$V Stretch_{12}$ (\%)';
                PLT.limits    = [-2.5 2.5];
            case 'V21'
                PLT.plot_what = squeeze(V(2,1,:,:)) .* 1e2;
                PLT.label     = '$V Stretch_{21}$ (\%)';
                PLT.limits    = [-2.5 2.5];
            case 'V22'
                PLT.plot_what = (squeeze(V(2,2,:,:)) -1) .*1e2;
                PLT.label     = '$V Stretch_{22}$ (\%)';
                PLT.limits    = [-2 2];
            case 'ANG'
                PLT.plot_what = A;
                PLT.label     = 'Rotation (deg)';
                PLT.limits    = [-1.5 1.5];
            otherwise
                error('not clear')
        end

    otherwise
end
end
