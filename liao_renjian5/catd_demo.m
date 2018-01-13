% 测试tucker分解的补全

clear
close
clc
addpath('libs/tensor_toolbox_2.5');
addpath('libs/poblano_toolbox_1.1/');
addpath libs/SPC/Function_SPC/
addpath libs\catd\
TestData=zeros([9,9,9]);
SingleAspect=zeros([9,9]);
for i=1:9
    SingleAspect(i,:)=[1:9];
end
for j=1:9
    TestData(:,:,j)=SingleAspect;
end

W=ones(9,9,9);
randnum=randperm(9*9*9); %随机产生矩阵位置
indexZero=randnum(1:round(9*9*9*0.1));%选择
oriTTData=TestData(indexZero);
ZNData=TestData;
ZNData(indexZero)=0;
ttZNData=tensor(ZNData);
W(indexZero)=0;
epsilon=0.0001;
% [S,R,U,T] = catd(A,Y,X,epsilon);
[S,R,U,T] =catd_modify(ttZNData,epsilon);
A=ttm(S,{R,U,T})


