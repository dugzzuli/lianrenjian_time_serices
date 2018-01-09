clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/
% data=load('E:/nrel_data.mat');
% data_rmse=(data.rmse_cp)
% [m,n,k]=size(data_rmse)
% rmse_save=zeros(10,50);
% for count=1:50
%     for col=1:20
%         dataColumn=data_rmse(count,col,:);
%         rmse_save(col,count)=mean(dataColumn);
%     end
% end
data=load('moredata\sac.mat');
data_rmse=(data.rmse_cp)
[m,n,k]=size(data_rmse)
rmse_save=zeros(10,30);
for count=1:30
    for col=1:20
        dataColumn=data_rmse(count,col,:);
        rmse_save(col,count)=mean(dataColumn);
    end
end
