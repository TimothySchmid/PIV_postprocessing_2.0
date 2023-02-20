function [U0, V0] = fct_NaN_fill(U0, V0, is_valid)
% fill in-mask nans ===================================================== %
% Apply inpaint_nans

    method = 3;
    u0 = U0;
    v0 = V0;
    
    % Apply inpaint_nans
    u0 = fct_inpaint_NaNs(double(u0),method);
    v0 = fct_inpaint_NaNs(double(v0),method);
    
    % check for existing NaN values
    
    while sum(sum(isnan(u0))) ~= 0
        %disp('remaining nans --> reapply inpaint_nans')
        u0 = fct_inpaint_NaNs(double(u0),method);
        v0 = fct_inpaint_NaNs(double(v0),method);
    end
    
    % set outside zeros back to NaN!
    u0(isnan(is_valid)) = NaN;
    v0(isnan(is_valid)) = NaN;
    
    U0 = u0;
    V0 = v0;
    
end
