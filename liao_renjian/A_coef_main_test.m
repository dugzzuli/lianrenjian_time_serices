clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/
addpath libs/


if 1==0
    for j=1:3
        if j==1
            data=load('./tceq/wind.tceq.mat');
            datawindOld=data.wind0x2Etceq;
        elseif j==2
            data=load('./tceq/temp.tceq.mat');
            datawindOld=data.temp0x2Etceq;
        elseif j==3
            data=load('./tceq/ozone.tceq.mat');
            datawindOld=data.ozone0x2Etceq;
        end
        
        
        
        % ozone0x2Etceq
        
        for i=1:26
            WindOriData=datawindOld(25:360,i);
            DataWind26(:,:,:,i)=reshape(WindOriData,12,7,4);
        end
        
        for loop=1:4
            UA{loop}=tenmat(DataWind26,loop);
            sumCorr_tceq(j,loop)=corrMAr(UA{loop}.data);
        end
    end
end

if 1==0
    
    pol_mesa=load('mesa\pol.mesa.txt');
    data_all=zeros(12,5,4,20);
    for i=1:20
        data_mesa=pol_mesa(41:280,i);
        
        data_reshape_norm_mesa=reshape(data_mesa,12,5,4);
        data_all_mesa(:,:,:,i)=data_reshape_norm_mesa;
    end
    for loop=1:4
        UA{loop}=tenmat(data_all_mesa,loop);
        sumCorr_mesa(1,loop)=corrMAr(UA{loop}.data);
    end
end

if 1==1
    wind_nrel=load('nrel\wind.ew.txt');
    
    
    data_all_rel=zeros(12,4,3,26);
    sensor_count=0;
    for sensor=1:50:1326.
        sensor_count=sensor_count+1;
        data_wind=wind_nrel(1:144,sensor);
        data_reshape_norm_temp=reshape(data_wind,12,4,3);
        data_all_rel(:,:,:,sensor_count)=data_reshape_norm_temp;
    end
    
    for loop=1:4
        UA{loop}=tenmat(data_all_rel,loop);
        sumCorr_nrel(1,loop)=corrMAr(UA{loop}.data);
    end
    
end

if 1==0
    data_all_sac=zeros(12,6,2,30);
    sumCorr_sac=zeros(1,4);
    sac_temp=load('sac\temp.sac.txt');
    sensor_count=0;
    for sensor=1:30:900
        sensor_count=sensor_count+1;
        data_temp=sac_temp(:,sensor);
        data_reshape_temp_ori=reshape(data_temp,12,6,2);
        data_all_sac(:,:,:,sensor_count)=data_reshape_temp_ori;
    end
    for loop=1:4
        UA{loop}=tenmat(data_all_sac,loop);
        sumCorr_sac(1,loop)=corrMAr(UA{loop}.data);
    end
end

if 1==0
    sumCorr_ndrdb=zeros(3,4);
    for i=1:3
        if i==1
            dir_ndrdb=load('nsrdb\dir.sc.txt');
        elseif i==2
            dir_ndrdb=load('nsrdb\glo.sc.txt');
        elseif i==3
            dir_ndrdb=load('nsrdb\dif.sc.txt');
        end
        for sensor=1:1:1071
            data_wind=dir_ndrdb(:,sensor);
            data_reshape=reshape(data_wind,7,4,2);
            data_all_dir_ndrdb(:,:,:,sensor)=data_reshape;
        end
        for loop=1:4
            UA{loop}=tenmat(data_all_dir_ndrdb,loop);
            sumCorr_ndrdb(i,loop)=corrMAr(UA{loop}.data);
        end
    end
end

if 1==0
    sumCorr_ncdc=zeros(3,4);
    for i=1:3
        clear data_temp
        if i==1
            ncdc_temp=load('ncdc\temp.ncdc.txt');
        elseif i==2
            ncdc_temp=load('ncdc\sol.ncdc.txt');
        elseif i==3
            ncdc_temp=load('ncdc\prec.ncdc.txt');
        end
        for sensor=1:1:72
            
            data_temp=ncdc_temp(10:105,sensor);
            
            data_reshape=reshape(data_temp,12,4,2);
            data_all_ncdc(:,:,:,sensor)=data_reshape;
        end
        
        for loop=1:4
            UA{loop}=tenmat(data_all_ncdc,loop);
            sumCorr_ncdc(i,loop)=corrMAr(UA{loop}.data);
        end
        
    end
end









