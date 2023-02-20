function [U0, V0] = fct_clean_raw_data(U0, V0, EXP, is_valid)
%UNTITLED Find wholes inside mask and replace them with zero; pre step for
% inpaint_nans. This sets only zero values INSIDE the mask to NaN, which
% drastically reduces computation time. Only after the use of inpaint_nans,
% all values outside the mask are set to NaN.

% input arguments is structure content from davis .vc7 files.
% input order:
% - Arg1 --> Displacement x (U0)
% - Arg2 --> Displacement y (V0)
% - Arg3 --> Mask data

% output order:
% - outArg1 --> Displacement x (DX)
% - outArg2 --> Displacement y (DY)
 
    % outlier detection ================================================= %
    [U0, V0] = fct_outlier_detection(U0, V0, EXP);
    % =================================================================== %

    % NaN detection ===================================================== %
    [U0, V0] = fct_NaN_detection(U0, V0);
    % =================================================================== %
   
    % fill in-mask NaN values =========================================== %
    [U0, V0] = fct_NaN_fill(U0, V0, is_valid);
    % =================================================================== %
    
    % set out-mask values to NaN ======================================== %
    [U0, V0] = fct_outside_NaN(U0, V0, is_valid);
    % =================================================================== %
    
end
