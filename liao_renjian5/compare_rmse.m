clear 
clc 
close
target = [1.5, 2.1, 3.3, -4.7, -2.3, 0.75]  ;
prediction = [0.5, 1.5, 2.1, -2.2, 0.1, -0.5] ;
rmse=RMSEUSE(target,prediction,length(prediction))
%     python 
%     target = [1.5, 2.1, 3.3, -4.7, -2.3, 0.75]
%     prediction = [0.5, 1.5, 2.1, -2.2, 0.1, -0.5]
%
%
%     error = []
%     for i in range(len(target)):
%         error.append(target[i] - prediction[i])
%
%
%     print("Errors: ", error)
%     print(error)
%
%
%
%
%
%
%     squaredError = []
%     absError = []
%     for val in error:
%         squaredError.append(val * val)#target-prediction֮��ƽ��
%         absError.append(abs(val))#������ֵ
%
%
%     print("Square Error: ", squaredError)
%     print("Absolute Value of Error: ", absError)
%
%
%
%
%     print("MSE = ", sum(squaredError) / len(squaredError))#�������MSE
%
%
%
%
%     from math import sqrt
%     print("RMSE = ", sqrt(sum(squaredError) / len(squaredError)))#���������RMSE
%     print("MAE = ", sum(absError) / len(absError))#ƽ���������MAE
%
%
%     targetDeviation = []
%     targetMean = sum(target) / len(target)#targetƽ��ֵ
%     for val in target:
%         targetDeviation.append((val - targetMean) * (val - targetMean))
%     print("Target Variance = ", sum(targetDeviation) / len(targetDeviation))#����
%
%
%     print("Target Standard Deviation = ", sqrt(sum(targetDeviation) / len(targetDeviation)))#��׼��