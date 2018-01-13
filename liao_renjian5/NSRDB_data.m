

clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/

% dir_ndrdb=load('nsrdb\dir.sc.txt');
dir_ndrdb=load('nsrdb\glo.sc.txt');
% dir_ndrdb=load('nsrdb\dif.sc.txt');
data_all=zeros(7,4,2,1071);
for count_rank=1:2

    for sensor=1:1:1071

        data_wind=dir_ndrdb(:,sensor);
        data_norm_temp=NormLiza(data_wind,'mm');
        data_reshape=reshape(data_norm_temp,7,4,2);
        data_all(:,:,:,sensor)=data_reshape; 
    end
    rank=count_rank;
    oriData_O=data_all(:,3:4,2,:);
    
    W=ones(7,4,2,1071);
    W(:,3:4,2,:)=0;
    
    tt_data=tensor(data_all);
    [P, P0, output]=cp_wopt(tt_data,W,rank,'init','nvecs');
    KTT=full(P);
    preData=KTT(:,3:4,2,:);
    preData=reshape(double(preData),14994,1);
    oriData=reshape(double(oriData_O),14994,1);
    rmse_cpAll(count_rank,1)=RMSEUSE(preData,oriData,24*1071)
end


