clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/

% ncdc_temp=load('ncdc\temp.ncdc.txt');
% ncdc_temp=load('ncdc\sol.ncdc.txt');
ncdc_temp=load('ncdc\prec.ncdc.txt');

for count_rank=1:2
    
sensor_count=0;
for sensor=1:1:72
    sensor_count=sensor_count+1;
    data_temp=ncdc_temp(10:105,sensor);
    data_norm_temp=NormLiza(data_temp,'mm');
    
    for rank=count_rank:count_rank
%         for count=1:1
            
            data_reshape_norm_temp=reshape(data_norm_temp,12,4,2);
            oriData=data_reshape_norm_temp(:,4,2);
            data_reshape_norm_temp(:,4,2)=0;
            W=ones(12,4,2);
            W(:,4,2)=0;
            tt_data=tensor(data_reshape_norm_temp);
            
%              rand('state',0)
%         M_init = create_guess('Data', tt_data, 'Num_Factors', rank, ...
%             'Factor_Generator', 'stochastic');
            
              rand('state',0)
            [P, P0, output]=cp_wopt(tt_data,W,rank,'init','nvecs');
            
            KTT=full(P);
            preData=KTT(:,4,2);
            preData=double(preData);
            FData=oriData;
            LData=preData;
            rmse=RMSEUSE(FData,LData,length(LData));
            %             rmse_cp(rank,count)=rmse;
            %             rmse_cp(sensor_count,count)=rmse;
            rmse_cp(sensor_count,rank)=rmse;
            
            All_true_label(sensor,:)=FData;
            All_pre_label(sensor,:)=LData;
            
            
%         end
    end
end
A=reshape(All_pre_label,[1,864]);
B=reshape(All_true_label,[1,864]);

rmse_cp_all(count_rank,1)=RMSEUSE(A,B,length(B))
end