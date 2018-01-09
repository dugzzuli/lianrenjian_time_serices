function [ DataWind26 ] = loadData( datawindOld)
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here
DataWind26=zeros(12,7,4,26);

% for i=1:26
%     WindOriData=datawindOld(25:360,i);
%     WindOriDataNorm=NormLiza(WindOriData,'mm');
%     DataWind26(:,:,:,i)=reshape(WindOriDataNorm,24,7,2);
% end

for i=1:26
    WindOriData=datawindOld(25:360,i);
    WindOriDataNorm=NormLiza(WindOriData,'m');
    DataWind26(:,:,:,i)=reshape(WindOriDataNorm,12,7,4);
end
DataWind26
end

