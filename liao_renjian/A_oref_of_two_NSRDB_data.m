clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
data=load('./tceq/wind.tceq.mat');
% data=load('./tceq/temp.tceq.mat');
% data=load('./tceq/ozone.tceq.mat');

datawindOld=data.wind0x2Etceq;
% datawindOld=data.temp0x2Etceq;
% ozone0x2Etceq
% datawindOld=data.ozone0x2Etceq;



m=24;
n=5;
z=3;
s=26;
DataWind26=zeros(24,5,3,26);

for i=1:26
    WindOriData=datawindOld(1:360,i);
    WindOriDataNorm=NormLiza(WindOriData,'mm');
    DataWind26(:,:,:,i)=reshape(WindOriDataNorm,m,n,z);
end

for loop=1:4
    UA{loop}=tenmat(DataWind26,loop);
    sumCorr(loop)=corrMAr(UA{loop}.data);
end


%
% pol_mesa=load('mesa\pol.mesa.txt');
% data_all=zeros(12,5,4,20);
% for i=1:20
%     data_mesa=pol_mesa(41:280,i);
%     data_norm_mesa=NormLiza(data_mesa,'mm');%标准化数据
%     data_reshape_norm_mesa=reshape(data_norm_mesa,12,5,4);
%     data_all(:,:,:,i)=data_reshape_norm_mesa;
% end


% wind_nrel=load('nrel\wind.ew.txt');
%
%
% data_all=zeros(12,8,2,26)
% sensor_count=0;
% for sensor=1:50:1326.
%     sensor_count=sensor_count+1;
%     data_wind=wind_nrel(:,sensor);
%     data_reshape_norm_temp=reshape(data_wind,12,8,2);
%     data_all(:,:,:,sensor_count)=data_reshape_norm_temp;
% end


% sac_temp=load('sac\temp.sac.txt');
% sensor_count=0;
% for sensor=1:30:900
%     sensor_count=sensor_count+1;
%     data_temp=sac_temp(:,sensor);
%     data_reshape_temp_ori=reshape(data_temp,12,6,2);
%     data_all(:,:,:,sensor_count)=data_reshape_temp_ori;
% end

% % dir_ndrdb=load('nsrdb\dir.sc.txt');
% % dir_ndrdb=load('nsrdb\glo.sc.txt');
% dir_ndrdb=load('nsrdb\dif.sc.txt');
% sensor_count=0;
% for sensor=1:50:1071
%     sensor_count=sensor_count+1;
%     data_wind=dir_ndrdb(:,sensor);
%     data_norm_temp_dug=NormLiza(data_wind,'mm');
%     data_reshape=reshape(data_norm_temp_dug,7,4,2);
%     data_all(:,:,:,sensor_count)=data_reshape;
% end
% ncdc_temp=load('ncdc\temp.ncdc.txt');
% ncdc_temp=load('ncdc\sol.ncdc.txt');
% ncdc_temp=load('ncdc\prec.ncdc.txt');
% 
% sensor_count=0;
% for sensor=1:1:72
%     sensor_count=sensor_count+1;
%     data_temp=ncdc_temp(10:105,sensor);
%     
%     data_reshape=reshape(data_temp,12,4,2);
%     data_all(:,:,:,sensor_count)=data_reshape;
% end

% for loop=1:4
%     UA{loop}=tenmat(data_all,loop);
%     sumCorr(loop)=corrMAr(UA{loop}.data);
% end




