%  第二个数据集合
clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/
% data=load('./tceq/wind.tceq.mat');
% data=load('./tceq/temp.tceq.mat');
% data=load('./tceq/ozone.tceq.mat');
pol_mesa=load('mesa\pol.mesa.txt');
data_mesa=pol_mesa(41:280,1); %获取后面264个数据进行组成张量格式数据
data_norm_mesa=NormLiza(data_mesa,'mm');%标准化数据
data_reshape_norm_mesa=reshape(data_norm_mesa,12,5,4);
data_test_reshape_norm_mesa=data_reshape_norm_mesa;
oriData=data_test_reshape_norm_mesa(:,5,4);
data_test_reshape_norm_mesa(:,5,4)=0;
tt_data_test_reshape_norm_mesa=tensor(data_test_reshape_norm_mesa);
W=ones(12,5,4);
W(:,5,4)=0;
[P, P0, output]=cp_wopt(tt_data_test_reshape_norm_mesa,W,1);
KTT=full(P);
preData=KTT(:,5,4);
preData=double(preData);
rmse=RMSEUSE(preData,oriData,length(oriData));
