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
data_all=zeros(12,5,4,20);
for i=1:20
    data_mesa=pol_mesa(41:280,i);
    data_norm_mesa=NormLiza(data_mesa,'mm');%标准化数据
    data_reshape_norm_mesa=reshape(data_norm_mesa,12,5,4);
    data_all(:,:,:,i)=data_reshape_norm_mesa;
end
%获取后面264个数据进行组成张量格式数据

for rank=1:5
    for count=1:2
        data_test_reshape_norm_mesa=data_all;
        oriData=data_test_reshape_norm_mesa(:,5,4,:);
        data_test_reshape_norm_mesa(:,5,4,:)=0;
        tt_data_test_reshape_norm_mesa=tensor(data_test_reshape_norm_mesa);
        W=ones(12,5,4,20);
        W(:,5,4,:)=0;
        [P, P0, output]=cp_wopt(tt_data_test_reshape_norm_mesa,W,rank);
        KTT=full(P);
        preData=KTT(:,5,4,:);
        preData=double(preData);
        FData=double(reshape(oriData,[240,1]));
        LData=double(reshape(preData,[240,1]));
        rmse=RMSEUSE(FData,LData,length(LData));
        rmse_cp(rank,count)=rmse;
    end
end
