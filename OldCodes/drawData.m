function [dataMatrix, timeStamp] = drawData(handles)

axes(handles.dataGraph);
set(handles.stopButton, 'Enable', 'on');
set(handles.dataPanel, 'Title', strcat('Live acquisition - Baseline =  ', num2str(handles.baseline)));
set(handles.console, 'String', 'Filling buffers, please wait...');

flagAcq = getFlagAcquisition;

flagInitial = 0;
flagFigure = 0;
indexRows = 1;
indexACQ = 1;
initialLoop = 0;
iterations = 1;

n = 100000; % dissapars on V2
timeStampCell = cell(2,n); %will dissapear on V2

bufferMedianFreq = zeros(handles.loggingBufferSize/2,1);
bufferMedianTemp = zeros(handles.loggingBufferSize/2,1);
bufferAverageFreq = zeros(handles.loggingBufferSize,1);
bufferAverageTemp = zeros(handles.loggingBufferSize,1);

while isequal(flagAcq, 1)
    
    flagAcq = getFlagAcquisition;
    
    if initialLoop == 0
        tic
    end
    
    if  (flagInitial == 0) && (initialLoop > handles.loggingBufferSize+1)  
        flagInitial = 1;
        set(handles.console, 'String', 'Acquiring live data...');
        startTime = char(datetime('now'));
       
        initialTime = duration(0,0,toc);
        tic
    end
    
    RawSerial = getValues(handles.openQCM, handles.serialBufferSize);
    delimiterCut = strsplit(RawSerial, 'ÿ');
    
    RAWDATA =  strsplit(cell2mat(strsplit(cell2mat(delimiterCut),'RAWMONITOR')), '_');
    
    freqChunk = cell2mat(RAWDATA(1,1));
    tempChunk = cell2mat(RAWDATA(1,2));
    
    freqRaw = str2double(freqChunk);
    tempRaw = str2double(tempChunk);
    
    bufferAverageFreq(indexACQ,1) =  freqRaw;
    bufferAverageTemp(indexACQ,1) = tempRaw;
    
    avgFreq = mean(bufferAverageFreq);
    avgTemp = mean(bufferAverageTemp);
    
    bufferMedianFreq(indexRows,1) = avgFreq;
    bufferMedianTemp(indexRows,1) = avgTemp;
    
    
    if handles.ALIAS==8000000
        tempF = (2*handles.ALIAS) - median(bufferMedianFreq); 
        avgFreqConverted =  (2*handles.ALIAS) - avgFreq - handles.baseline;
        freqChunkConverted = (2*handles.ALIAS) - avgFreq;
    else
        tempF = (2*handles.ALIAS) + median(bufferMedianFreq);
        avgFreqConverted = (2*handles.ALIAS) + avgFreq - handles.baseline;
        freqChunkConverted = (2*handles.ALIAS) + avgFreq;
    end
    
    frequencyPoint = tempF - handles.baseline;
    temperaturePoint = median(bufferMedianTemp)/10;
    
    indexRows = indexRows + 1;
    indexACQ = indexACQ + 1;
    initialLoop = initialLoop + 1;
    
    if indexRows > handles.loggingBufferSize/2
        indexRows = 1;
        finalAVG = avgFreq;
    end
    
    if indexACQ > handles.loggingBufferSize
        indexACQ = 1;
    end
    
    if initialLoop >  (handles.loggingBufferSize +1) && (flagInitial == 1)
        
        timePoint = toc/60;
        
        
        if flagFigure == 0
            
            
            
            handles.plotRealTimeData  = gca;
            cla(handles.plotRealTimeData,'reset')
            
            set(handles.plotRealTimeData,'FontSize',11);             
            set(handles.plotRealTimeData,'Color',[0.15 0.15 0.15]);
            set(handles.plotRealTimeData,'GridColor',[146/255 158/255 179/255]);
            set(handles.plotRealTimeData,'XColor',[187/255 192/255 199/255]);
            
            grid on
            grid minor
            hold on
            
            yyaxis left
            lineFreq =  line(timePoint,frequencyPoint, 'color', [12/255 137/255 209/255], 'LineWidth', 1, 'Parent', handles.plotRealTimeData);
            lineFreq.Parent.YLim = [frequencyPoint-30 frequencyPoint+30];
            
            yyaxis right
            lineTemp =  line(timePoint, temperaturePoint, 'color', [0.93 0.33 0.33], 'LineWidth', 1, 'Parent', handles.plotRealTimeData);
            lineTemp.Parent.YLim = [temperaturePoint-5 temperaturePoint+5];
            ylabel('Temperature')
            
            yyaxis left
            xlabel('Time [min]')
            ylabel('\DeltaF [Hz]')
            
            
            set(handles.stopButton, 'BackgroundColor', [0.7 0 0]);
            
            flagFigure = 1;
            
        end
        
        timeStampCell(1,iterations)=  cellstr(char(datetime('now') - startTime)); %dissapears
        timeStampCell(2,iterations)= cellstr(char(datetime('now')));
        
        enlapsed = char(datetime('now')-startTime+initialTime); %changes
        timeStamp = timeStampCell(1,1:iterations); %dissapears
        
        timeFreq = get(lineFreq, 'xData');
        pointsFreq = get(lineFreq, 'yData');
        timeTemp = get(lineTemp, 'xData');
        pointsTemp = get(lineTemp, 'yData');
        
        timeFreq = [timeFreq timePoint];
        pointsFreq = [pointsFreq frequencyPoint];
        timeTemp = [timeTemp timePoint];
        pointsTemp = [pointsTemp temperaturePoint];
        
        set(lineFreq, 'xData', timeFreq, 'yData', pointsFreq);
        set(lineTemp, 'xData', timeTemp, 'yData', pointsTemp);
        
        
        handles.plotRealTimeData.YAxis(1).Limits = [min(pointsFreq)-30 max(pointsFreq)+30];
        handles.plotRealTimeData.YAxis(2).Limits = [min(pointsTemp)-2 max(pointsTemp)+2];
        
    
        set(lineFreq , 'LineWidth', 1);
        set(lineTemp , 'LineWidth', 1);
        
        refreshdata(lineFreq);
        refreshdata(lineTemp);
        
        
        set(handles.rawFrequencyVal, 'String',freqChunkConverted);
        set(handles.wildCardStr, 'String',num2str(frequencyPoint));
        set(handles.meanFreqVal, 'String',num2str(avgFreqConverted) );
        set(handles.enlapsedVal, 'String', char(enlapsed));
        set(handles.tempVal, 'String', num2str(temperaturePoint) );

        drawnow
        iterations = iterations + 1;
        
    end
    
    
end

set(handles.console, 'String','Operation Completed');

dataMatrix = createMatrix(timeFreq, pointsFreq, pointsTemp);

set(handles.saveTXT, 'Enable', 'on');
set(handles.saveExcel, 'Enable', 'on');
set(handles.plotDataNOSmoothing, 'Enable', 'on');
set(handles.plotDataSmoothed, 'Enable', 'on');
pause(1);
set(handles.console, 'String', ' Data Matrix Created!');
pause(0.5)

% noSignal = imread('noSignal2.jpg');
% noSignalAxes = gca;
% cla(noSignalAxes,'reset')
% axes(handles.dataGraph)
% imshow(noSignal, 'parent', handles.dataGraph);


plotDataNew(dataMatrix, 0, 0, handles)

set(handles.console, 'String', ' Final data shown');


end