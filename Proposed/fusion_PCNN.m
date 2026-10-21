function cp=fusion_PCNN(matrixA,matrixB)

%% Initialize parameter
Para.iterTimes=200;
Para.link_arrange=7;
Para.alpha_L=0.02;
Para.alpha_Theta=3;
Para.beta=3;
Para.vL=1;
Para.vTheta=20;

%%
PCNN_timesA=PCNN_withParameters(abs(matrixA),Para);
PCNN_timesB=PCNN_withParameters(abs(matrixB),Para);
figure;imshow(PCNN_timesA);
figure;imshow(PCNN_timesB);
map=(PCNN_timesA>=PCNN_timesB);

%%
cp=map.*matrixA+~map.*matrixB;