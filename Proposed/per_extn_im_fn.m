function xout_ext = per_extn_im_fn(x,wsize)

hw = (wsize-1)/2;

[p,q] = size(x);

xout_ext = zeros(p+wsize-1,q+wsize-1);

xout_ext(hw+1:p+hw,hw+1:q+hw)=x;

xout_ext(1:hw,:) = xout_ext(wsize:-1:hw+2,:);

xout_ext(p+hw+1:p+wsize-1,:) = xout_ext(p+hw-1:-1:p,:);

xout_ext(:,1:hw) = xout_ext(:,wsize:-1:hw+2);

xout_ext(:,q+hw+1:q+wsize-1)=xout_ext(:,q+hw-1:-1:q);

end