function [wt1, wt2] = covariance_weights(im1, im2, cov_wsize)

half = floor((cov_wsize-1)/2);

temp1 = per_extn_im_fn(im1,cov_wsize);
temp2 = per_extn_im_fn(im2,cov_wsize);

[M,N] = size(temp1);

wt1 = zeros(M-cov_wsize+1,N-cov_wsize+1);
wt2 = zeros(M-cov_wsize+1,N-cov_wsize+1);

for ii = half+1:M-half

    for jj = half+1:N-half

        patch1 = temp1(ii-half:ii+half,...
                       jj-half:jj+half);

        patch2 = temp2(ii-half:ii+half,...
                       jj-half:jj+half);

        wt1(ii-half,jj-half) = DirectionalCovarianceEnergy(patch1);

        wt2(ii-half,jj-half) = DirectionalCovarianceEnergy(patch2);

    end

end

end