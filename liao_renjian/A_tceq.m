clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
% data=load('./tceq/wind.tceq.mat');
data=load('./tceq/temp.tceq.mat');
% data=load('./tceq/ozone.tceq.mat');

% datawindOld=data.wind0x2Etceq;
datawindOld=data.temp0x2Etceq;
% ozone0x2Etceq
% datawindOld=data.ozone0x2Etceq;



m=24;
n=7;
z=2;
s=26;
DataWind26=zeros(24,7,2,26);

for i=1:26
    WindOriData=datawindOld(25:360,i);
    WindOriDataNorm=NormLiza(WindOriData,'mm');
    DataWind26(:,:,:,i)=reshape(WindOriDataNorm,m,n,z);
end


for rank=4:4
    Ori26=DataWind26;
    ZerosData=DataWind26(:,7,2,:);
    Ori26(:,7,2,:)=0;
    W=ones(24,7,2,26);
    W(:,7,2,:)=0;
    Q=logical(W);
    dataTensor=tensor(Ori26);
    rand('state',0)
    M_init = create_guess('Data',dataTensor, 'Num_Factors', rank, ...
        'Factor_Generator', 'rand');
    
    [P, P0, output]=cp_wopt(dataTensor,W,rank,'init',M_init);
    KTT=full(P);
    preData=KTT(:,7,2,:);
    rmse(rank,1)=RMSEUSE(double(reshape(ZerosData,[624,1])),double(reshape(preData,[624,1])),624);
end