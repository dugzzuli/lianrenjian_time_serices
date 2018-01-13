clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/

% ncdc_temp=load('ncdc\temp.ncdc.txt');
% ncdc_temp=load('ncdc\sol.ncdc.txt');
ncdc_temp=load('ncdc\prec.ncdc.txt');


for rank_count=2:2
    sensor_count=0;
    for sensor=1:1:72
        sensor_count=sensor_count+1;
        data_temp=ncdc_temp(10:105,sensor);
        data_norm_temp=NormLiza(data_temp,'mm');
        
        
        %         for count=1:1
        
        data_reshape_norm_temp=reshape(data_norm_temp,12,4,2);
        oriData=data_reshape_norm_temp(:,4,2);
        data_reshape_norm_temp(:,4,2)=0;
        W=ones(12,4,2);
        W(:,4,2)=0;
        tt_data=tensor(data_reshape_norm_temp);
        rand('state',0)
        M_init = create_guess('Data',tt_data, 'Num_Factors', rank_count, ...
            'Factor_Generator', 'rand');
        [P, P0, output]=cp_wopt(tt_data,W,rank_count,'init',M_init);
        
        KTT=full(P);
        preData=KTT(:,4,2);
        preData=double(preData);
        FData=oriData;
        LData=preData;
        
        All_true_label(sensor,:)=FData;
        All_pre_label(sensor,:)=LData;
        
        
    end
    A=reshape(All_pre_label,[1,864]);
    B=reshape(All_true_label,[1,864]);
    
    rmse_all(rank_count)=RMSEUSE(A,B,length(B))
end