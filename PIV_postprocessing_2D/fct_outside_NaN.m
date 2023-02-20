function [U0, V0] = fct_outside_NaN(U0, V0, is_valid)
% set out-mask values to NaN ============================================ %

    % set out-mask values to NaN
    U0(is_valid==0) = NaN;
    V0(is_valid==0) = NaN;
end
