clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/
addpath libs/

ncdc_temp=load('ncdc\temp.ncdc.txt');
% ncdc_temp=load('ncdc\sol.ncdc.txt');
% ncdc_temp=load('ncdc\prec.ncdc.txt');


for rank_count=1:5
    for sensor=1:1:72
        data_temp=ncdc_temp(10:105,sensor);
        data_norm_temp=NormLiza(data_temp,'mm');
        data_reshape=reshape(data_norm_temp,12,4,2);
        data_all(:,:,:,sensor)=data_reshape;
    end
    data_perform=data_all;
    ture_data=data_perform(:,4,2,:);
    data_perform(:,4,2,:)=0;
    W=ones(12,4,2,72);
    W(:,4,2,:)=0;
    tt_data=tensor(data_perform);
    rand('state',0)
    M_init = create_guess('Data',tt_data, 'Num_Factors', rank_count, ...
        'Factor_Generator', 'rand');
    [P, P0, output]=cp_wopt(tt_data,W,rank_count,'init',M_init);
    KTT=full(P);
    preData=double(KTT(:,4,2,:));
    A=reshape(preData,[1,864]);
    B=reshape(ture_data,[1,864]);
    rmse_all(rank_count)=RMSEUSE(A,B,length(B))
end