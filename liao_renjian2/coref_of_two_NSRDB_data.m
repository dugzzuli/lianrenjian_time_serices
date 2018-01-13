clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
data=load('./tceq/wind.tceq.mat');
% data=load('./tceq/temp.tceq.mat');
% data=load('./tceq/ozone.tceq.mat');

datawindOld=data.wind0x2Etceq;
% datawindOld=data.temp0x2Etceq;
% ozone0x2Etceq
% datawindOld=data.ozone0x2Etceq;



m=24;
n=5;
z=3;
s=26;
DataWind26=zeros(24,5,3,26);

for i=1:26
    WindOriData=datawindOld(1:360,i);
    WindOriDataNorm=NormLiza(WindOriData,'mm');
    DataWind26(:,:,:,i)=reshape(WindOriDataNorm,m,n,z);
end

for loop=1:4
    UA{loop}=tenmat(DataWind26,loop);
    sumCorr(loop)=corrMAr(UA{loop}.data);
end

rand('state',0)
M_init = create_guess('Data', tensor(DataWind26), 'Num_Factors', 1, ...
    'Factor_Generator', 'rand');



