clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/

wind_nrel=load('nrel\wind.ew.txt');

for count_rank=5:10
    for sensor=1:1:1326
        sensor_count=0;
        sensor_count=sensor_count+1;
        data_wind=wind_nrel(:,sensor);
        data_norm_temp_dug=NormLiza(data_wind,'mm');
        
        for rank=count_rank:count_rank
    
                data_norm_temp=data_norm_temp_dug;
                back_data_norm_temp=data_norm_temp; %备份最原始数据 back_data_norm_temp
                
                data_norm_temp(145:192)=0; %初始化为预测数值为 0
                
                %选取前13：144 132个点和 145：156 12个预测点 进行reshape数组
                data_reshape_norm_temp=reshape(data_norm_temp(13:156),12,6,2);
                
                W=ones(12,6,2);
                W(:,6,1)=0;
                %转换为张量格式数据
                tt_data=tensor(data_reshape_norm_temp);
                % 通过cp方法进行分解预测
                 rand('state',0)
    M_init = create_guess('Data',tt_data, 'Num_Factors', rank, ...
        'Factor_Generator', 'rand');
    
                [P, P0, output]=cp_wopt(tt_data,W,rank,'init',M_init);
                % cp分解为 对角 特征值 因子矩阵
                KTT=full(P);
                preData=KTT(:,6,2); %获取 预测数值
                preData_1=double(preData); %获取预测的145：156之间的值 转换为double
                
                data_norm_temp(145:156)=preData_1; %填充到数组中 进行下一次预测
                
                %获取25：156 的 132个数值
                temp_data=data_norm_temp(25:156);
                %
                temp_data(133:144)=0;
                
                data_reshape=reshape(temp_data,12,6,2);
                tt_data=tensor(data_reshape);
                
                
                  rand('state',0)
    M_init = create_guess('Data',tt_data, 'Num_Factors', rank, ...
        'Factor_Generator', 'rand');
    
                [P, P0, output]=cp_wopt(tt_data,W,rank,'init',M_init);
                
                KTT=full(P);
                preData=KTT(:,6,2);
                preData_2=double(preData); %获取预测的 157：168之间的值
                data_norm_temp(157:168)=preData_2;
                
                
                temp_data=data_norm_temp(37:168);
                temp_data(133:144)=0;
                
                data_reshape=reshape(temp_data,12,6,2);
                tt_data=tensor(data_reshape);
                
                             rand('state',0)
    M_init = create_guess('Data',tt_data, 'Num_Factors', rank, ...
        'Factor_Generator', 'rand');
                [P, P0, output]=cp_wopt(tt_data,W,rank,'init',M_init);
                
                KTT=full(P);
                preData=KTT(:,6,2);
                preData_3=double(preData); %获取预测的 169：180
                data_norm_temp(169:180)=preData_3;
                temp_data=data_norm_temp(49:180);
                temp_data(133:144)=0;
                
                data_reshape=reshape(temp_data,12,6,2);
                tt_data=tensor(data_reshape);
                 rand('state',0)
    M_init = create_guess('Data',tt_data, 'Num_Factors', rank, ...
        'Factor_Generator', 'rand');
                [P, P0, output]=cp_wopt(tt_data,W,rank,'init',M_init);
                
                KTT=full(P);
                preData=KTT(:,6,2);
                preData_4=double(preData);
                data_norm_temp(181:192)=preData_4;
                
                pre_data=[preData_1,preData_2,preData_3,preData_4];
                pre_data_two=reshape(pre_data,48,1);
                truth_data=back_data_norm_temp(145:192);

                
                
                All_true_label(sensor,:)=truth_data;
                All_pre_label(sensor,:)=pre_data_two;
                

        end
    end
    
    A=reshape(All_pre_label,[1,48*1326]);
    B=reshape(All_true_label,[1,48*1326]);
    
    rmse_cp_all(count_rank,1)=RMSEUSE(A,B,length(B));
end

