function [ output_data ] = RMSEUSE( origin,predit,num)
A=origin;
B=predit;
output_data=sqrt(sum((A-B).^2)/num);
end

