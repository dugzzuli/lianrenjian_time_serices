% 计算非负数影响  直接对负数进行取0

clear
close
clc
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/
m=load('data/pemsSave.mat');
pemsdata=reshape(m.pemsSave,[21,24,12]);
ZNData=pemsdata;
W=ones(21,24,12);
randnum=randperm(length(m.pemsSave));
indexZero=randnum(1:604);
oriTTData=pemsdata(indexZero);
ZNData(indexZero)=0;
W(indexZero)=0;
ttZNData=tensor(ZNData);
[P, P0, output]=cp_wopt(ttZNData,W,5);
KTT=full(P);
Pre=double(KTT);
preData=Pre(indexZero);
rmse(1,1)=RMSEUSE(preData,oriTTData,length(oriTTData));

ZerospreData=preData;
indexs=find(ZerospreData<0);
ZerospreData(indexs)=0;
rmse(1,2)=RMSEUSE(ZerospreData,oriTTData,length(oriTTData));


