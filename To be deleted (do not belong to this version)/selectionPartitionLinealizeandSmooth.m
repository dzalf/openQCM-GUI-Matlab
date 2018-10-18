clear
close all
clc
loop = 1;


while isequal(loop,1) 

% Load data from a txt file located in a specific folder
[dataLoaded, filename, success, figHandle] = loadData();


if isequal(success,1)
 % Construct a questdlg with three options
    choice = questdlg('Would you like to continue?', ...
        'Data Loaded!', ...
        'Yes','Select again', 'Yes');
    % Handle response
    switch choice
        case 'Yes'
            loop = 0;
            cont = 1;
        case 'Select again'
            
            loop = 1;
            clear dataLoaded
            delete(figHandle)     
    end
else
    loop = 0;
    cont = 0;
end  
end

if isequal (cont,1)
    
    % 1. Select dividing points
    points = selectPoints (dataLoaded, filename);
    
end

[chunk1,chunk2,chunk3] = partitionData(dataLoaded, points);
smoothData = smoothData(chunk2);

[fitValsChunk1, fitChunk1,fitValsChunk2, fitChunk2,fitValsChunk3, fitChunk3] = linearFitChunks(chunk1, smoothData, chunk3);

