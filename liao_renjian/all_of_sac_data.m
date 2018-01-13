clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/

sac_temp=load('sac\temp.sac.txt');

for sensor=1:1:900
    
    data_temp=sac_temp(:,sensor);
    data_norm_temp=NormLiza(data_temp,'mm');
    data_reshape_temp_ori=reshape(data_norm_temp,12,6,2);
    data_all(:,:,:,sensor)=data_reshape_temp_ori;
end
for rank_count=1:10
    
    data_reshape_temp=data_all;
    oriData=data_reshape_temp(:,6,2,:);
    data_reshape_temp(:,6,2,:)=0;
    W=ones(12,6,2,900);
    W(:,6,2,:)=0;
    tt_data=tensor(data_reshape_temp);
    rand('state',0)
    M_init = create_guess('Data',tt_data, 'Num_Factors', rank_count, ...
        'Factor_Generator', 'rand');
    [P, P0, output]=cp_wopt(tt_data,W,rank_count,'init',M_init);
    KTT=full(P);
    preData=KTT(:,6,2,:);
    preData=double(preData);
    A=reshape(preData,[1,12*900]);
    B=reshape(oriData,[1,12*900]);
    rmse_all(rank_count)=RMSEUSE(A,B,length(B))
end