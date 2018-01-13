function [ DataWind26 ] = loadData( datawindOld,start,endd)
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here
m=12;
n=14;
z=2;
s=26;
DataWind26=zeros(12,14,2,26);

for i=1:26
    WindOriData=datawindOld(start:endd,i);
    WindOriDataNorm=NormLiza(WindOriData,'mm');
    DataWind26(:,:,:,i)=reshape(WindOriDataNorm,m,n,z);
end

end

