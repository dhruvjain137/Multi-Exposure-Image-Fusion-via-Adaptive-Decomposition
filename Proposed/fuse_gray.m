function fuse_im = fuse_gray(inp, detail, cov_wsize)

half_wsize = (cov_wsize-1)/2;

temp1 = per_extn_im_fn(detail{1}, cov_wsize);
temp2 = per_extn_im_fn(detail{2}, cov_wsize);

[MM, NN] = size(temp1);

wt1 = zeros(MM-cov_wsize+1,NN-cov_wsize+1);
wt2 = zeros(MM-cov_wsize+1,NN-cov_wsize+1);

for ii = half_wsize+1:MM-half_wsize

    for jj = half_wsize+1:NN-half_wsize

        tt1 = temp1(ii-half_wsize:ii+half_wsize,...
                    jj-half_wsize:jj+half_wsize);

        wt1(ii-half_wsize,jj-half_wsize)=DirectionalCovarianceEnergy(tt1);

        tt2 = temp2(ii-half_wsize:ii+half_wsize,...
                    jj-half_wsize:jj+half_wsize);

        wt2(ii-half_wsize,jj-half_wsize)=DirectionalCovarianceEnergy(tt2);

    end

end

wt1 = wt1 + eps;
wt2 = wt2 + eps;

fuse_im = (inp{1}.*wt1 + inp{2}.*wt2)./(wt1+wt2);

end