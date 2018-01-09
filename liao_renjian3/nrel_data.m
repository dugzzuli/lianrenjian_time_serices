clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/

wind_nrel=load('nrel\wind.ew.txt');
data_wind=wind_nrel(:,1);
data_norm_temp=NormLiza(data_wind,'mm');
data_reshape_norm_temp=reshape(data_norm_temp,12,8,2);
oriData=data_reshape_norm_temp(:,5:8,2);
data_reshape_norm_temp(:,5:8,2)=0;
W=ones(12,8,2);
W(:,5:8,2)=0;
tt_data=tensor(data_reshape_norm_temp);

[P, P0, output]=cp_wopt(tt_data,W,1);

KTT=full(P);
preData=KTT(:,5:8,2);
preData=double(preData);
FData=double(reshape(oriData,48,1));
LData=double(reshape(preData,48,1));
rmse=RMSEUSE(FData,LData,length(LData));



