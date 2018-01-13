

clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/

dir_ndrdb=load('nsrdb\dir.sc.txt');
% dir_ndrdb=load('nsrdb\glo.sc.txt');
% dir_ndrdb=load('nsrdb\dif.sc.txt');
sensor_count=0;
for rank=3:3
    for sensor=1:1:1071
        
        
        sensor_count=sensor_count+1;
        data_wind=dir_ndrdb(:,sensor);
        data_norm_temp_dug=NormLiza(data_wind,'mm');
        
        
        data_norm_temp=data_norm_temp_dug;
        back_data_norm_temp=data_norm_temp;
        data_norm_temp(43:56)=0;
        data_reshape=reshape(data_norm_temp,7,4,2);
        W=ones(7,4,2);
        W(:,3:4,2)=0;
        tt_data=tensor(data_reshape);
        rand('state',0);
        
    M_init = create_guess('Data',tt_data, 'Num_Factors', rank, ...
        'Factor_Generator', 'rand');
        [P, P0, output]=cp_wopt(tt_data,W,rank,'init',M_init);
        KTT=full(P);
        preData=KTT(:,3:4,2);
        preData=reshape(double(preData),14,1);
        rmse=RMSEUSE(back_data_norm_temp(43:56),preData,24);
        
        
        All_true_label(sensor,:)=back_data_norm_temp(43:56);
        All_pre_label(sensor,:)=preData;
    end

    
    
    
    A=reshape(All_pre_label,[1,14*1071]);
    B=reshape(All_true_label,[1,14*1071]);
    
    
    rmseALL(rank)=RMSEUSE(A,B,24*1071)
end



