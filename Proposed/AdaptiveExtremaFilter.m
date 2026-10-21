function filtered = AdaptiveExtremaFilter(I,mode)

filtered = zeros(size(I));

for c=1:size(I,3)

    channel = I(:,:,c);

    %% Three window sizes

    if strcmp(mode,'max')

        F2 = ordfilt2(channel,4,ones(2));

        F4 = ordfilt2(channel,16,ones(4));

        F6 = ordfilt2(channel,36,ones(6));

    else

        F2 = ordfilt2(channel,1,ones(2));

        F4 = ordfilt2(channel,1,ones(4));

        F6 = ordfilt2(channel,1,ones(6));

    end

    %% Local Range

    LocalMax = ordfilt2(channel,9,ones(3));

    LocalMin = ordfilt2(channel,1,ones(3));

    Range = LocalMax-LocalMin;

    %% Adaptive Thresholds

    T1 = mean(Range(:));

    T2 = T1 + std(Range(:));

    out = zeros(size(channel));

    %% Adaptive Window Selection

    idx1 = Range < T1;

    idx2 = Range >= T1 & Range < T2;

    idx3 = Range >= T2;

    out(idx1)=F2(idx1);

    out(idx2)=F4(idx2);

    out(idx3)=F6(idx3);

    filtered(:,:,c)=out;

end

end