A=reshape(All_pre_label,[1,864]);
B=reshape(All_true_label,[1,864]);

RMSEUSE(A,B,length(B))