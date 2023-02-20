function [U0, V0] = fct_NaN_detection(U0, V0)
    % NaN detection ===================================================== %
    % Prepare data for inpaint_nans
    
    u0 = U0;
    v0 = V0;
    
    % Set zero points inside hull to NaN
    u0(u0==0) = NaN;
    v0(u0==0) = NaN;
    
    U0 = u0;
    V0 = v0;
    
end
