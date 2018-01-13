clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/
addpath libs\tensorlab\
% data=load('./tceq/wind.tceq.mat');
data=load('./tceq/temp.tceq.mat');
% data=load('./tceq/ozone.tceq.mat');

% datawindOld=data.wind0x2Etceq;
datawindOld=data.temp0x2Etceq;
% ozone0x2Etceq
% datawindOld=data.ozone0x2Etceq;
Data26=zeros(24,7,2,26);

Data26=loadData(datawindOld);
Ori26=Data26;
ZerosData=Data26(:,7,2,:);
Data26(:,7,2,:)=0;
W=ones(24,7,2,26);
W(:,7,2,:)=0;
Q=logical(W);
dataTensor=tensor(Data26);

[P, P0, output]=cp_wopt(dataTensor,W,2,'alg','ncg','init','cpd_rnd');
KTT=full(P);
preData=KTT(:,7,2,:);
rmse=RMSEUSE(double(reshape(ZerosData,[624,1])),double(reshape(preData,[624,1])),624);
