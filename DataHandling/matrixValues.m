function [dataMatrix, meanFreq, meanTemp]= matrixValues(samples, openQCM)

dataMatrix = zeros(samples, 3);
tic;
    
for j = 1:samples

    [frequency, temperature, enlapsedTime] = extractValues(openQCM);
    
    dataMatrix(j , 1) = enlapsedTime; % Time column
    dataMatrix(j, 2) = frequency; % Frequency column
    dataMatrix(j, 3) = temperature; % Temperature column
    
end
    toc
    meanFreq = mean(dataMatrix(:, 2));
    meanTemp = mean(dataMatrix(:, 3));
    
end