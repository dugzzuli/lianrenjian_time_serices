

clear
clc
close
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/
addpath libs/

m=load('data/pemsSave.mat');

pemsdata=reshape(m.pemsSave,[21,24,12]);%获取数据

for loop=1:3
    UA{loop}=tenmat(pemsdata,loop);
    sumCorr(loop)=corrMAr(UA{loop}.data);
end
    
    
    
