clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/
% data=load('./tceq/wind.tceq.mat');
% data=load('./tceq/temp.tceq.mat');
data=load('./tceq/ozone.tceq.mat');

% datawindOld=data.wind0x2Etceq;
% datawindOld=data.temp0x2Etceq;
% ozone0x2Etceq
datawindOld=data.ozone0x2Etceq;
m=12;
n=14;
z=2;
s=26;

Data26=zeros(m,n,z,s);

Data26=loadData(datawindOld,13,348);
Ori26=Data26;
ZerosData=Data26(:,n,z,:);
Data26(:,n,z,:)=0;
W=ones(m,n,z,s);
W(:,n,z,:)=0;

dataTensor=tensor(Data26);
for count_rank=1:2

    [P, P0, output]=cp_wopt(dataTensor,W,count_rank,'init', 'nvecs');
    
    KTT1=full(P);
    
    
    Data26=loadData(datawindOld,25,360);
    Data_ori=Data26(:,n-1:n,z,:);
    
    Ori26=Data26;
    ZerosData=Data26(:,n,z,:);
    Data26(:,n,z,:)=0;
    W=ones(m,n,z,s);
    W(:,n,z,:)=0;
    
    dataTensor_two=tensor(Data26);
    dataTensor_two(:,n-1,z,:)=KTT1(:,n,z,:);
    
    
    
    [P, P0, output]=cp_wopt(dataTensor,W,count_rank,'init', 'nvecs');
    
    KTT=full(P);
    preData2=KTT(:,n,z,:);
    
%     KTT(:,n-1,z,:)=KTT1(:,n,z,:);
    
    rmse=RMSEUSE(double(reshape(Data_ori,[624,1])),double(reshape(KTT(:,n-1:n,z,:),[624,1])),624);
    
    rmse_cp(count_rank)=rmse;
end







