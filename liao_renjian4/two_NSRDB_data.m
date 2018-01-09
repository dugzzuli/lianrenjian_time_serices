

clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/

% dir_ndrdb=load('nsrdb\dir.sc.txt');
dir_ndrdb=load('nsrdb\glo.sc.txt');
% dir_ndrdb=load('nsrdb\dif.sc.txt');
sensor_count=0;
% for sensor=1:25:1071
for sensor=176:176

    sensor_count=sensor_count+1;
    data_wind=dir_ndrdb(:,sensor);
    data_norm_temp_dug=NormLiza(data_wind,'mm');
    
    for rank=1:2
%         56个数据  预测十四个数据
        %         for count=1:10
        data_norm_temp=data_norm_temp_dug;
        
        data_norm_temp(43:56)=0;
%         第一部分4350
        data4350=data_norm_temp(1:48);
        data_reshape=reshape(data4350,6,4,2);
        
       
        W=ones(6,4,2);
        W(:,4,2)=0;
        tt_data=tensor(data_reshape);
        [P, P0, output]=cp_wopt(tt_data,W,rank,'init','nvecs');
        KTT=full(P);
        preData=KTT(:,4,2);
        data_norm_temp(43:48)=preData;
        
        
        data154=data_norm_temp(1:54);
        data_reshape=reshape(data154,6,3,3);
        
        W2=ones(6,3,3);
        W2(6,3,3)=0;
        tt_data=tensor(data_reshape);
        [P, P0, output]=cp_wopt(tt_data,W2,rank,'init','nvecs');
        KTT=full(P);
        preData=KTT(:,3,3);
        data_norm_temp(49:54)=preData;

        data_reshape=reshape(data_norm_temp,7,4,2);
        W3=ones(7,4,2);
        W3(6:7,4,2)=0;
        tt_data=tensor(data_reshape);
        [P, P0, output]=cp_wopt(tt_data,W3,rank,'init','nvecs');
        KTT=full(P);
        preData=KTT(6:7,4,2);
        pre=double(KTT);
        data_norm_temp(55:56)=preData;
        rmse=RMSEUSE(data_norm_temp_dug(43:56),reshape(data_norm_temp(43:56),14,1),24);
        
        
        rmse_cp(sensor_count,rank)=rmse;
        %         end
    end
    min_rmse=min(rmse_cp)
    plot(min_rmse)
    
end



