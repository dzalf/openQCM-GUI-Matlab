function [dataMatrix, timeStamp] = drawNew(handles)

flagAcq = getFlagAcquisition;
flagInitial = 0;
flagFigure = 0;
indexRows = 1;
indexACQ = 1;
initialLoop = 0;
iterations = 1;

bufferMedianFreq = zeros(handles.loggingBufferSize/2,1);
bufferMedianTemp = zeros(handles.loggingBufferSize/2,1);
bufferAverageFreq = zeros(handles.loggingBufferSize,1);
bufferAverageTemp = zeros(handles.loggingBufferSize,1);

axes(handles.dataGraph);


while isequal(flagAcq, 1)
    
    flagAcq = getFlagAcquisition;
    
    if initialLoop == 0
        tic
    end
    
    if  (flagInitial == 0) && (initialLoop > handles.loggingBufferSize+1)
        flagInitial = 1;
        set(handles.console, 'String', 'Acquiring live data...');
        startTime = datetime('now', 'Format','HH:mm:ss:ms');
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
        
        %         if isequal(handles.continuous, 0)
        timeAccumulation = toc/60; %only for accumulated data
        %         end
        
        if flagFigure == 0
            
            % Initial setup for graph display
            
            handles.plotRealTimeData = gca; % current axis -> display window
            
            cla(handles.plotRealTimeData,'reset')
            
            
            set(handles.plotRealTimeData,'FontSize',11);
            set(handles.plotRealTimeData,'Color',[160/255 160/255 160/255]);
            handles.plotRealTimeData.XTickLabelRotation=45;
            xlabel('Time [min]')
            ylabel('Frequency [Hz]')
            
            grid on
            grid minor
            hold on
            
            yyaxis left
            lineFreqCont = animatedline;
            set(lineFreqCont, 'LineWidth', 1);
            set(lineFreqCont, 'Color', [32/255, 89/255, 181/255]);
            xlabel('Time [min]')
            ylabel('\DeltaF [Hz]')
            
            yyaxis right
            lineTempCont = animatedline;
            set(lineFreqCont, 'LineWidth', 1);
            set(lineFreqCont, 'Color', [0.93 0.33 0.33]);
            ylabel('Temperature')
            
            
            
            yyaxis left
            lineFreqAcum =  line(timePoint,frequencyPoint, 'color', [12/255 137/255 209/255], 'LineWidth', 1, 'Parent', handles.plotRealTimeData);
            lineFreqAcum.Parent.YLim = [frequencyPoint-30 frequencyPoint+30];
            xlabel('Time [min]')
            ylabel('\DeltaF [Hz]')
            
            yyaxis right
            lineTempAcum =  line(timePoint, temperaturePoint, 'color', [0.93 0.33 0.33], 'LineWidth', 1, 'Parent', handles.plotRealTimeData);
            lineTempAcum.Parent.YLim = [temperaturePoint-5 temperaturePoint+5];
            ylabel('Temperature')
            
            
            set(handles.console, 'String', 'Displaying real time data...');
            set(handles.axisSlider, 'Enable', 'on');
            set(handles.zoomVal, 'Enable', 'on');
            set(handles.stopButton,'Enable', 'on')
            set(handles.stopButton, 'BackgroundColor', [0.7 0 0]);
            set(handles.zoomVal,'FontSize',13);
            
            flagFigure = 1;
            
        end
        
        
        t(iterations,1) =  datetime('now', 'Format','HH:mm:ss:ms')- startTime; %, 'Format','HH:mm:ss'
        timePoints(iterations,1) = datenum(t(iterations));
        datePoints(iterations,1) = datetime('now', 'Format', 'dd-MMM-yyyy HH:mm:ss:ms');
        
        enlapsed{iterations,1} = char(t(iterations,1)); %+initialTime
        e = enlapsed(iterations);
        
        
        
        
        timeFreqAcum = get(lineFreqAcum, 'xData');
        pointsFreqAcum = get(lineFreqAcum, 'yData');
        timeTempAcum = get(lineTempAcum, 'xData');
        pointsTempAcum = get(lineTempAcum, 'yData');
        
        timeFreqAcum = [timeFreqAcum timePoint];
        pointsFreqAcum = [pointsFreqAcum frequencyPoint];
        timeTempAcum = [timeTempAcum timePoint];
        pointsTempAcum = [pointsTempAcum temperaturePoint];
        
        
        
        if isequal(handles.continuous,1)
            
            cla(handles.plotRealTimeData,'reset')
            
            set(handles.plotRealTimeData,'FontSize',11);
            set(handles.plotRealTimeData,'Color',[160/255 160/255 160/255]);
            handles.plotRealTimeData.XTickLabelRotation=45;
            xlabel('Time [min]')
            ylabel('Frequency [Hz]')
            
            addpoints(lineFreqCont, timePoints(iterations),frequencyPoint);
            addpoints(lineTempCont, timePoints(iterations),temperaturePoint);
            
            %         val  = get(handles.axisSlider, 'Value');
            %         increment = ((frequencyPoint)/10)/val;
            %         zoomVal = val*100;
            %         stringZoom = strcat(num2str(floor(zoomVal)), ' %');
            %         set(handles.zoomVal, 'String', stringZoom);
            %         handles.plotRealTimeData.YLim = [finalAVG-increment, finalAVG+increment];
            
            
            handles.plotRealTimeData.XLim = datenum([t(iterations,1)-seconds(5) t(iterations,1)]);
            
            datetick('x','keeplimits')
            refreshdata(lineFreqCont);
            refreshdata(lineTempCont);
            drawnow limitrate
            set(lineFreqCont , 'LineWidth', 1);
            set(lineTempCont , 'LineWidth', 1);
            
        else
            
            if isequal(handles.continuous,0)
                
                cla(handles.plotRealTimeData,'reset')
                
                set(handles.plotRealTimeData,'FontSize',11);
                set(handles.plotRealTimeData,'Color',[160/255 160/255 160/255]);
                handles.plotRealTimeData.XTickLabelRotation=45;
                xlabel('Time [min]')
                ylabel('Frequency [Hz]')
                
                set(lineFreqAcum, 'xData', timeFreqAcum, 'yData', pointsFreqAcum);
                set(lineTempAcum, 'xData', timeTempAcum, 'yData', pointsTempAcum);
                
                
                handles.plotRealTimeData.YAxis(1).Limits = [min(pointsFreqAcum)-30 max(pointsFreqAcum)+30];
                handles.plotRealTimeData.YAxis(2).Limits = [min(pointsTempAcum)-2 max(pointsTempAcum)+2];
                
                
                set(lineFreqAcum , 'LineWidth', 1);
                set(lineTempAcum , 'LineWidth', 1);
                
                refreshdata(lineFreqAcum);
                refreshdata(lineTempAcum);
            end
            
        end
        
        
        set(handles.rawFrequencyVal, 'String',freqChunkConverted);
        set(handles.wildCardStr, 'String',num2str(frequencyPoint));
        set(handles.meanFreqVal, 'String',num2str(avgFreqConverted) );
        set(handles.enlapsedVal, 'String', char(enlapsed));
        set(handles.tempVal, 'String', num2str(temperaturePoint) );

        drawnow
        iterations = iterations+1;
    end
end

set(handles.console, 'String','Operation Completed');
pause(1)
set(handles.console, 'String', ' Creating Matrix...');
pause(1)
[timePointsAcum, freqPointsAcum] = getpoints(lineFreqAcum);
[timePointsAcum, tempPointsAcum] = getpoints(lineTempAcum);

[numericTime, timeStamp, tempTimeVector] = timeVectorManagement(timePoints, datePoints);

dataMatrix = createMatrix(numericTime, pointsFreqAcum');


set(handles.saveTXT, 'Enable', 'on');
set(handles.saveExcel, 'Enable', 'on');
set(handles.plotDataNOSmoothing, 'Enable', 'on');
set(handles.plotDataSmoothed, 'Enable', 'on');
pause(1);
set(handles.console, 'String', ' Data Matrix Created!');
pause(0.5)



end