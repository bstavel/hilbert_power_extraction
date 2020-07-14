function M_out = nanzscore(M_in, dim)

    if nargin < 2 || isempty(dim)
        dim = 1;
    end

    m_mean = nanmean(M_in, dim);
    m_std = nanstd(M_in, dim);

    M_out = (M_in-m_mean)./m_std;
