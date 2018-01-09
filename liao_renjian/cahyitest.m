clc;clear;
X =[
    0.31 0.21 0.53 0.18 0.39 0.15 0.17 0.45 0.3 0.12 0.26 0.13
    0.21 0.20 0.33 0.11 0.298 0.0759 0.1512 0.31 0.2674 0.06 0.21 0.08
    ];
P=friedman(X,1);
k=12;
m=2;
p=zeros(k,k);
temp=zeros(m, 2);
for i=1:k
    for j=1:i
        temp(:,1)=X(:,i);
        temp(:,2)=X(:,j);
        p(i,j)=friedman(temp,1);
    end
end
