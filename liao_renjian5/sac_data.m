clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/

sac_temp=load('sac\temp.sac.txt');
sensor_count=0;
for sensor=1:1:900
    sensor_count=sensor_count+1;
    data_temp=sac_temp(:,sensor);
    data_norm_temp=NormLiza(data_temp,'mm');
    data_reshape_temp_ori=reshape(data_norm_temp,12,6,2);
    
    for rank=1:1
        %         for count=1:10
        
        data_reshape_temp=data_reshape_temp_ori;
        oriData=data_reshape_temp(:,6,2);
        data_reshape_temp(:,6,2)=0;
        W=ones(12,6,2);
        W(:,6,2)=0;
        
        tt_data=tensor(data_reshape_temp);
        
        
        [P, P0, output]=cp_wopt(tt_data,W,rank,'init','nvecs');
        KTT=full(P);
        preData=KTT(:,6,2);
        preData=double(preData);
        FData=oriData;
        LData=preData;
        rmse=RMSEUSE(FData,LData,length(LData));
        %         rmse_cp(rank,count)=rmse;
        %             rmse_cp(sensor_count,rank,count)=rmse;
        rmse_cp(sensor_count,rank)=rmse;
        
        All_true_label(sensor,:)=FData;
        All_pre_label(sensor,:)=LData;
        %         end
    end
end
A=reshape(All_pre_label,[1,12*900]);
B=reshape(All_true_label,[1,12*900]);

RMSEUSE(A,B,length(B))