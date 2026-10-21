function fuse_im = fusef(inp, detail, cov_wsize)

half_wsize = (cov_wsize-1)/2;

temp1 = per_extn_im_fn(detail{1}, cov_wsize);
temp2 = per_extn_im_fn(detail{2}, cov_wsize);

[MM,NN] = size(temp1);

wt1 = zeros(size(detail{1}));
wt2 = zeros(size(detail{2}));

for ii = half_wsize+1:MM-half_wsize

    for jj = half_wsize+1:NN-half_wsize

        tt1 = temp1(ii-half_wsize:ii+half_wsize,...
                    jj-half_wsize:jj+half_wsize);

        hr_cov_mat1 = covarf(tt1,cov_wsize);
        ver_cov_mat1 = covarf(tt1',cov_wsize);

        wt1(ii-half_wsize,jj-half_wsize) = ...
            sum(eig(hr_cov_mat1)) + sum(eig(ver_cov_mat1));

        tt2 = temp2(ii-half_wsize:ii+half_wsize,...
                    jj-half_wsize:jj+half_wsize);

        hr_cov_mat2 = covarf(tt2,cov_wsize);
        ver_cov_mat2 = covarf(tt2',cov_wsize);

        wt2(ii-half_wsize,jj-half_wsize) = ...
            sum(eig(hr_cov_mat2)) + sum(eig(ver_cov_mat2));
        
    end

end
figure;imshow(wt1);
figure;imshow(wt2);
wt1(wt1==0)=eps;
wt2(wt2==0)=eps;

fuse_im = (double(inp{1}).*wt1 + double(inp{2}).*wt2) ./ (wt1+wt2);

end