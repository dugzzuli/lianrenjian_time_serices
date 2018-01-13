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
                back_data_norm_temp=data_norm_temp; %������ԭʼ���� back_data_norm_temp
                
                data_norm_temp(145:192)=0; %��ʼ��ΪԤ����ֵΪ 0
                
                %ѡȡǰ13��144 132����� 145��156 12��Ԥ��� ����reshape����
                data_reshape_norm_temp=reshape(data_norm_temp(13:156),12,6,2);
                
                W=ones(12,6,2);
                W(:,6,1)=0;
                %ת��Ϊ������ʽ����
                tt_data=tensor(data_reshape_norm_temp);
                % ͨ��cp�������зֽ�Ԥ��
                 rand('state',0)
    M_init = create_guess('Data',tt_data, 'Num_Factors', rank, ...
        'Factor_Generator', 'rand');
    
                [P, P0, output]=cp_wopt(tt_data,W,rank,'init',M_init);
                % cp�ֽ�Ϊ �Խ� ����ֵ ���Ӿ���
                KTT=full(P);
                preData=KTT(:,6,2); %��ȡ Ԥ����ֵ
                preData_1=double(preData); %��ȡԤ���145��156֮���ֵ ת��Ϊdouble
                
                data_norm_temp(145:156)=preData_1; %��䵽������ ������һ��Ԥ��
                
                %��ȡ25��156 �� 132����ֵ
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
                preData_2=double(preData); %��ȡԤ��� 157��168֮���ֵ
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
                preData_3=double(preData); %��ȡԤ��� 169��180
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

