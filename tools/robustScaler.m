function M_out = robustScaler(M_in, dim, quartiles)

    if nargin < 3
        quartiles = [10 90];
    end
    if nargin < 2 || isempty(dim)
        dim = 1;
    end

    if dim > 0
        med = nanmedian(M_in, dim);
        IQR = prctile(M_in, quartiles(2), dim) - prctile(M_in, quartiles(1), dim);
    else % med and IQR computed on the whole matrix
        med = nanmedian(M_in(:));
        IQR = prctile(M_in(:), quartiles(2)) - prctile(M_in(:), quartiles(1));
    end
    M_out = (M_in-med)./IQR;
