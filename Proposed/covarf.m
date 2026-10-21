function xcovar = covarf(x, cov_wsize)
tr = x - repmat(mean(x), cov_wsize, 1);
xcovar = tr' * tr / (cov_wsize - 1);
end
