clc;
close all;
clear all;
%% Read Images

Under = im2double(imread('images/abcB.jpg'));
Over  = im2double(imread('images\abcA.JPG'));

levels = 3;

%% Under Image Decomposition

[DU,BU] = AdaptiveExtremaDecomposition(Under,'max',levels);

%% Over Image Decomposition

[DO,BO] = AdaptiveExtremaDecomposition(Over,'min',levels);

%% Display Under Image

figure;
imshow(Under)
title('Original Under')

figure;imshow(mat2gray(DU{1}), []);title('Detail-1');
figure;imshow(mat2gray(DU{2}));title('Detail-2')
figure;imshow(mat2gray(DU{3}));title('Detail-3')
figure;imshow(BU);title('Base')
%% Display Over Image

figure;
imshow(Over)
title('Original Over')

figure;imshow(mat2gray(DO{1}));title('Detail-1')
figure;imshow(mat2gray(DO{2}));title('Detail-2')
figure;imshow(mat2gray(DO{3}));title('Detail-3')
figure;imshow(BO);title('Base');
%% Fusion by Simple Averaging
% Fusing Detail
FD = cell(1,levels);

for k = 1:levels

    FD{k} = (DU{k}+ DO{k})/2;
    figure;
    imshow(mat2gray(FD{k}),[]);

end
%Fusing Base
FB = (BU + BO)/2;
figure;imshow(FB);
Recon = FB;

for k = levels:-1:1
    Recon = Recon + FD{k};
end

figure;
imshow(Recon);
title('Final Fused Image');

%% Fusion by WLE based weighted Averaging
% Fusing Detail
FD = cell(1,levels);
eps = 1e-12;
for k = 1:levels
    EU = WLE(DU{k});
    EO = WLE(DO{k});
    WU = EU ./ (EU + EO + eps);
    WO = EO ./ (EU + EO + eps);
    figure;imshow(WU);title("Weight-U");
    figure;imshow(WO);title("Weight-O");
    FD{k} = WU .* DU{k} + WO .* DO{k};
    figure;
    imshow(mat2gray(FD{k}),[]);
    title(['Fused Detail Level ',num2str(k)]);
end
% Fusing Base
FB = (BU + BO)/2;
figure;imshow(FB);
Recon = FB;

for k = levels:-1:1
    Recon = Recon + FD{k};
end

figure;
imshow(Recon);
title('Final Fused Image');
%% Fusion via PCCN base weighted averaging
% Fusing Detail 
FD = cell(1,levels);
for k = 1:levels
    if size(DU{k},3)==3
        temp = zeros(size(DU{k}));
        for c = 1:3
            temp(:,:,c) = fusion_PCNN(DU{k}(:,:,c), DO{k}(:,:,c));
        end
        FD{k} = temp;
    else
        FD{k} = fusion_PCNN(DU{k}, DO{k});
    end
    figure;
    imshow(mat2gray(FD{k}),[]);
    title(['PCNN Fused Detail Level ', num2str(k)]);
end
%Fusing Base
FB = (BU + BO)/2;
figure;imshow(FB);
Recon = FB;

for k = levels:-1:1
    Recon = Recon + FD{k};
end
figure;
imshow(Recon);
title('Final Fused Image');
%% Fusing via Covariance based weighted averaging (on detail Layer)

% Fusing Detail layer
FD = cell(1,levels);

cov_wsize = 5;    

for k = 1:levels

    if size(DU{k},3)==3

        temp = zeros(size(DU{k}));

        for c = 1:3

            inp = {DU{k}(:,:,c), DO{k}(:,:,c)};
            detail = inp;

            temp(:,:,c) = fusef(inp, detail, cov_wsize);

        end

        FD{k} = temp;

    else

        inp = {DU{k}, DO{k}};
        detail = inp;

        FD{k} = fusef(inp, detail, cov_wsize);

    end

    figure;
    imshow(mat2gray(FD{k}),[]);
    title(['Covariance Weighted Detail Level ',num2str(k)]);
    imwrite(mat2gray(FD{k}), sprintf('cov-weight%d.png', k));
end
%% fused Base - by simple averaging
FB = (BU + BO)/2;
figure;imshow(FB);
imwrite(FB,"Fused-Base.png")
Recon = FB;

for k = levels:-1:1
    Recon = Recon + FD{k};
end
figure;
imshow(Recon);
title('Final Fused Image');
%% Fusion via Covariance based weighted averaging (on Base Layer)
% Fusing Detail layer
FD = cell(1,levels);
for k = 1:levels
    FD{k} = (DU{k} + DO{k})/2;
    figure;
    imshow(mat2gray(FD{k}),[]);
    title(['Averaged Detail Level ',num2str(k)]);
end
% Base Fusion 
cov_wsize = 5;
if size(BU,3)==3
    FB = zeros(size(BU));
    for c = 1:3
        inp = {BU(:,:,c), BO(:,:,c)};
        detail = inp;
        FB(:,:,c) = fusef(inp, detail, cov_wsize);
    end
else
    inp = {BU, BO};
    detail = inp;
    FB = fusef(inp, detail, cov_wsize);
end
figure;
imshow(mat2gray(FB));
title('Covariance Weighted Base');
Recon = FB;
for k = levels:-1:1
    Recon = Recon + FD{k};
end
figure;
imshow(Recon);