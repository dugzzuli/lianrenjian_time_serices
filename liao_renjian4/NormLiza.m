function NormLizaData=NormLiza(windOri,type)
clear B;
if strcmp(type,'meanNorm')
    meanData=mean(windOri)
    NormLizaData=(windOri-repmat(meanData,[336,1]))./max(windOri-meanData)
else if  strcmp(type,'mm')
        MaxWind=max(max(windOri));
        MinWind=min(min(windOri));
        NormLizaData=(windOri-MinWind)./(MaxWind-MinWind);
    else if strcmp(type,'zscore')
            NormLizaData=zscore(windOri);
        else
            fprintf('origin data\n')
            NormLizaData=windOri;
        end
    end
end