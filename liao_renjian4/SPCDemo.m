clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/
% data=load('./tceq/wind.tceq.mat');

% datawindOld=data.wind0x2Etceq;

data=load('./tceq/temp.tceq.mat');

datawindOld=data.temp0x2Etceq;




% for i=1:26
%     for j=1:10
wind=datawindOld(25:360,2);
wind=NormLiza(wind,'mm');
ori=wind;

wind(313:336)=0;

W=ones(336,1);
W(313:336)=0;

W=reshape(W,24,7,2);
oriData=reshape(ori,24,7,2);
dataRe=reshape(wind,24,7,2);
dataTensor=tensor(dataRe);
T=double(dataTensor);
Q=logical(W);


%% hyperparameters and run SPC-TV

TVQV    = 'tv';        % 'tv' or 'qv' ;
rho     = [0.01 0.01 0.01]; % smoothness (0.1 - 1.0) for 'qv' and (0.01 - 0.5) for 'tv' is recommended.
K       = j;          % Number of components which are updated in one iteration.
%         TVQV    = 'qv';        % 'tv' or 'qv' ;
%         rho     = [1.0 1.0 1.0]; % smoothness (0.1 - 1.0) for 'qv' and (0.01 - 0.5) for 'tv' is recommended.
SNR     = 100;          % error bound
nu      = 0.0001;        % threshold for R <-- R + 1.
maxiter = 10000;       % maximum number of iteration
tol     = 1e-7;        % tolerance
out_im  = 0;           % you can monitor the process of 'image' completion if out == 1.

[Xtv Z G U histo histo_R] = SPC(T,Q,TVQV,rho,K,SNR,nu,maxiter,tol,out_im);
rmse_sin=RMSEUSE(double(Xtv(:,7,2)),double(oriData(:,7,2)),24);
rmseDataSingle(1,1)=rmse_sin;
close all
%     end
% end

