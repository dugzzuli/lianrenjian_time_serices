clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/

sac_temp=load('sac\temp.sac.txt');
for rank_count=1:10
    sensor_count=0;
    for sensor=1:1:900
        sensor_count=sensor_count+1;
        data_temp=sac_temp(:,sensor);
        data_norm_temp=NormLiza(data_temp,'mm');
        data_reshape_temp_ori=reshape(data_norm_temp,12,4,3);
        
        
        data_reshape_temp=data_reshape_temp_ori;
        oriData=data_reshape_temp(:,4,3);
        data_reshape_temp(:,4,3)=0;
        W=ones(12,4,3);
        W(:,4,3)=0;
        
        tt_data=tensor(data_reshape_temp);
        rand('state',0)
        M_init = create_guess('Data',tt_data, 'Num_Factors', rank_count, ...
            'Factor_Generator', 'rand');
        
        [P, P0, output]=cp_wopt(tt_data,W,rank_count,'init',M_init);
        KTT=full(P);
        preData=KTT(:,4,3);
        preData=double(preData);
        FData=oriData;
        LData=preData;
        
        All_true_label(sensor,:)=FData;
        All_pre_label(sensor,:)=LData;
        %         end
        
    end
    A=reshape(All_pre_label,[1,12*900]);
    B=reshape(All_true_label,[1,12*900]);
    
    
    rmse_all(rank_count)=RMSEUSE(A,B,length(B))
end