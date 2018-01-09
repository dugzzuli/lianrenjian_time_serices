% 测试从秩1到20进行  非负分解
close
clear
clc
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/
addpath libs\ncpc\
addpath libs\ihosvd\
m=load('data/pemsSave.mat');


rank=1;
sr = 0.7; % percentage of samples
N1 = 21; N2 = 24; N3 = 12;
ndim = [N1,N2,N3]; %获取维度
pemsdata=reshape(m.pemsSave,[21,24,12]);%获取数据
ZNData=pemsdata;%数据赋值
W= randsample(N1*N2*N3,round(sr*N1*N2*N3)); %选取样本索引
ttZNData=tensor(ZNData);%转为张量数据
R = rank;%秩选择
esr = round(R); % overestimate of rank 评估秩
opts.tol = 1e-7; opts.maxit = 100000;  %参数初始化
t0 = tic; %记录时间
oriTTData=ttZNData.data(W);%获取样本
[Pnon, Out]=ncpc(oriTTData,W,ndim,esr,opts); %处理数据
time = toc(t0); %结束时间
PnonFull=full(Pnon);
PnonFull=double(PnonFull);
PnonFull(W)=-1;
indexs=find(PnonFull>0);
values=PnonFull(indexs);
OriDatavalues=ZNData(indexs);
rmse(rank,1)=RMSEUSE(values,OriDatavalues,length(OriDatavalues));

coreNway = [1,1,1];
opts = [];
opts.maxit = 10000; opts.tol = 1e-7;
opts.rank_adj = ones(1,3); % use rank-increasing strategy
opts.rank_max = coreNway;
EstCoreNway = [1 1 1];
t0i = tic;
hosvdData=tensor(ZNData);
hosvdTrain=hosvdData(W);
indexW=logical(W)
[A,C,Out] = ALSaS(hosvdTrain,indexW,ndim,EstCoreNway,opts);
timei = toc(t0i);
Mrec = full(ttensor(C,A));
IhooiData=Mrec(indexs);
rmse(rank,6)=RMSEUSE(IhooiData,OriDatavalues,length(OriDatavalues));
rmse(rank,7)=timei;



ZNData(indexs)=0; % 将随机的缺失值
WCP=ones(ndim);
WCP(indexs)=0;
CPoriTTData=pemsdata(indexs);

CPDATA=tensor(ZNData);
t1 = tic; %记录时间
[P, P0, output]=cp_wopt(CPDATA,WCP,rank);
time2 = toc(t1); %结束时间
KTT=full(P);
Pre=double(KTT);
preData=Pre(indexs);
rmse(rank,2)=RMSEUSE(preData,CPoriTTData,length(CPoriTTData));



ZerospreData=preData;
indexs=find(ZerospreData<0);
ZerospreData(indexs)=0;
rmse(rank,3)=RMSEUSE(ZerospreData,CPoriTTData,length(CPoriTTData));



rmse(rank,4)=time;
rmse(rank,5)=time2;
relerr = norm(full(Pnon)-ttZNData)/norm(ttZNData);
fprintf('time = %4.2e, ',time);
fprintf('solution relative error = %4.2e\n\n',relerr);












