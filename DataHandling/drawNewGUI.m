
% This is the main function for data acquisitions, processing and real time display.
% Buffers for data storage are filled with individual points where the average and median values
% help to avoid spurious data points and/or outliers  

function [dataMatrix, timeStamp] = drawNewGUI(handles)

flagAcq = getFlagAcquisition;
flagInitial = 0;
flagFigure = 0;
indexRows = 1;
indexACQ = 1;
initialLoop = 0;
iterations = 0;

bufferMedianFreq = zeros(handles.loggingBufferSize/2,1);
bufferMedianTemp = zeros(handles.loggingBufferSize/2,1);
bufferAverageFreq = zeros(handles.loggingBufferSize,1);
bufferAverageTemp = zeros(handles.loggingBufferSize,1);

handles.showTemp = get(handles.showTempCheck, 'Value');
continuous = 0;
acumulative = 0;

while isequal(flagAcq, 1)
    
    set(handles.timeBox, 'String',datestr(now, 21));
    
    flagAcq = getFlagAcquisition;
    
    if isequal(initialLoop, 0)
        set(handles.stopButton,'Enable', 'on')
        set(handles.stopButton, 'BackgroundColor', [0.7 0 0]);
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
    
    if handles.ALIAS == 8000000
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
    
    if isequal(flagInitial,0)
        initialLoop = initialLoop + 1;
    end
    
    if indexRows > handles.loggingBufferSize/2
        indexRows = 1;
    end
    
    if indexACQ > handles.loggingBufferSize
        indexACQ = 1;
    end
    
    if  isequal(flagInitial, 0) && (initialLoop > handles.loggingBufferSize+1)
        
        set(handles.console, 'String', 'Acquiring live data...');
        startTime = datetime('now', 'Format','HH:mm:ss:ms');
        
        initialTime = duration(0,0,toc);
        
        iterations = iterations + 1;
        flagInitial = 1;
        tic
    end
    
    if (initialLoop >  (handles.loggingBufferSize+1)) && isequal(flagInitial,1)
        
        freqAcum(iterations) = frequencyPoint;
        tempAcum(iterations) = temperaturePoint;
        
        timeAccumulation = toc/60; %only for accumulated data
        timeAcumVector(iterations) = timeAccumulation;
        
        if isequal(flagFigure,0)
            
            axes(handles.dataGraph);
            handles.acumAxes = gca;

            axes(handles.dataGraph2);
            handles.contAxes = gca;
             
            % Initial setup for graph display
            % *********************************
                cla(handles.acumAxes,'reset')         
                
                set(handles.acumAxes,'FontSize',10);
                set(handles.acumAxes,'Color',[0.15 0.15 0.15]);
                set(handles.acumAxes,'GridColor',[150/255 206/255 244/255]);
                set(handles.acumAxes,'XColor',[187/255 192/255 199/255]);
                set(handles.acumAxes, 'XTickLabelRotation',45);
                   
                yyaxis(handles.acumAxes, 'left')
                lineFreqAcum =  line(timeAccumulation,frequencyPoint,'Parent', handles.acumAxes);
                
               
                set(lineFreqAcum,'color', [187/255 206/255 244/255]);
                set(lineFreqAcum, 'LineWidth', 1);
                handles.acumAxes.XLabel.String = 'Time [min]';%setxlabel('Time [min]')
                handles.acumAxes.YLabel.String = '\DeltaF [Hz]'; %ylabel('\DeltaF [Hz]')
                

                 
                yyaxis(handles.acumAxes, 'right')
                lineTempAcum =  line(timeAccumulation, temperaturePoint,'Parent', handles.acumAxes);
                
                set(lineTempAcum,'color', [0.93 0.33 0.33]);
                set(lineTempAcum, 'LineWidth', 1);

                handles.acumAxes.YLabel.String = strcat('Temperature',strcat( {' '}, {char(176)},{'C'})); %ylabel('Temperature')   
                handles.acumAxes.XGrid = 'on';
                handles.acumAxes.YGrid = 'on';
                handles.acumAxes.XMinorGrid = 'on';
                handles.acumAxes.YMinorGrid = 'on';%grid on
                grid minor
               
                cla(handles.contAxes,'reset')
                
                grid on
                grid minor
                
                
                set(handles.contAxes,'FontSize',10);
                set(handles.contAxes,'Color',[0.15 0.15 0.15]);
                set(handles.contAxes,'GridColor',[150/255 206/255 244/255]);
                set(handles.contAxes,'XColor',[187/255 192/255 199/255]);
                set(handles.contAxes, 'XTickLabelRotation',30);
                
                yyaxis(handles.contAxes, 'left')
                lineFreqCont = animatedline;
                
                set(lineFreqCont, 'LineWidth', 1);
                set(lineFreqCont, 'Color', [150/255 206/255 244/255]);
                xlabel('Time [min]')
                ylabel(strcat('Temperature',strcat( {' '}, {char(176)},{'C'})));
                
                yyaxis(handles.contAxes, 'right') 
                lineTempCont = animatedline;
                
                set(lineTempCont, 'LineWidth', 1);
                set(lineTempCont, 'Color', [0.93 0.33 0.33]);
                ylabel('Temperature')
                

            set(handles.console, 'String', 'Displaying real time data...');
            
            flagFigure = 1;
            
        end
             
        % Time managmement  
        t(iterations,1) =  datetime('now', 'Format','HH:mm:ss:ms') - startTime+initialTime;
        ticksAcum{iterations} = char(datetime('now', 'Format','HH:mm:ss')); % actually creates a timestamp
        timePoints(iterations,1) = datenum(t(iterations));
        datePoints(iterations,1) = datetime('now', 'Format', 'dd-MMM-yyyy HH:mm:ss:ms');
        enlapsed{iterations,1} = char(t(iterations,1)); %+initialTime
        e = enlapsed(iterations);
        
        % Data for accumulative display
        timeFreqAcum = get(lineFreqAcum, 'xData');
        pointsFreqAcum = get(lineFreqAcum, 'yData');
        timeTempAcum = get(lineTempAcum, 'xData');
        pointsTempAcum = get(lineTempAcum, 'yData');
        
        timeFreqAcum = [timeFreqAcum timeAccumulation];
        pointsFreqAcum = [pointsFreqAcum frequencyPoint];
        timeTempAcum = [timeTempAcum timeAccumulation];
        pointsTempAcum = [pointsTempAcum temperaturePoint];
        
        % Read display console status
        displaySelected = get(handles.accumulativeButton, 'Value');
        displayTemp = get(handles.showTempCheck, 'Value');
   
        if isequal(displaySelected,0) % CONTINUOUS!
            
            if isequal(continuous,0)
                
%                 cla(handles.acumAxes,'reset')
                set(handles.console, 'String','Showing continuous data');
                set(handles.dataGraph, 'Visible', 'off');
                set(handles.dataGraph2, 'Visible', 'on');
                set(handles.axisSlider, 'Visible', 'on');
                
                handles.acumAxes.YAxis(1).Visible = 'off';
                handles.acumAxes.YAxis(2).Visible = 'off';
                lineFreqAcum.Visible = 'off';
                lineTempAcum.Visible = 'off';
                
                handles.contAxes.YAxis(1).Visible = 'on';
                handles.contAxes.YAxis(2).Visible = 'on';
                lineFreqCont.Visible = 'on';
                lineTempCont.Visible = 'on';
                
                acumulative = 0;
                continuous = 1;
            end

            yyaxis(handles.contAxes, 'left')
            addpoints(lineFreqCont, timePoints(iterations),frequencyPoint);
            
            yyaxis(handles.contAxes, 'right')
            addpoints(lineTempCont, timePoints(iterations),temperaturePoint);
            
            % Zoom function!
            
            val  = get(handles.axisSlider, 'Value');
           
            zoomVal = val*100;
            stringZoom = strcat(num2str(floor(zoomVal)), ' %');
            set(handles.zoomVal, 'String', stringZoom);

            if ( avgFreqConverted >= 0)
                 increment = avgFreqConverted*(1-val);
                handles.contAxes.YAxis(1).Limits = [avgFreqConverted-abs(increment), avgFreqConverted+abs(increment)];
            else
                 increment = 10*avgFreqConverted*(1-val);
                handles.contAxes.YAxis(1).Limits = [avgFreqConverted-abs(increment), avgFreqConverted+abs(increment)];
            end
            
            handles.contAxes.XLim = datenum([t(iterations,1)-seconds(30) t(iterations,1)]);
            
            datetick('x','keeplimits')
            
            if isequal(displayTemp,0)
                handles.contAxes.YAxis(2).Visible = 'off';
                lineTempCont.Visible = 'off';
            else
                handles.contAxes.YAxis(2).Visible = 'on';
                lineTempCont.Visible = 'on';
                handles.contAxes.YAxis(2).Limits = [min(tempAcum)-2 max(tempAcum)+2];   
            end
            
           
            grid on
            grid minor

            refreshdata(lineFreqCont);
            refreshdata(lineTempCont);
            
            drawnow limitrate
            
        else % ACCUMULATIVE
            
            if isequal(acumulative,0)
                set(handles.console, 'String','Showing accumulative data') 
                set(handles.axisSlider, 'Visible', 'off');
                set(handles.dataGraph, 'Visible', 'on');
                set(handles.dataGraph2, 'Visible', 'off');
                
                handles.acumAxes.YAxis(1).Visible = 'on';
                handles.acumAxes.YAxis(2).Visible = 'on';
                lineFreqAcum.Visible = 'on';
                lineTempAcum.Visible = 'on';
                
                handles.contAxes.YAxis(1).Visible = 'off';
                handles.contAxes.YAxis(2).Visible = 'off';
                lineFreqCont.Visible = 'off';
                lineTempCont.Visible = 'off';
                
                continuous = 0;
                acumulative = 1;
            end
            
            yyaxis(handles.acumAxes, 'left')
            set(lineFreqAcum, 'xData', timeFreqAcum, 'yData', pointsFreqAcum);
                        
            yyaxis(handles.acumAxes, 'right')
            set(lineTempAcum, 'xData', timeTempAcum, 'yData', pointsTempAcum);
            
            handles.acumAxes.YAxis(1).Limits = [min(pointsFreqAcum)-20 max(pointsFreqAcum)+20];
            handles.acumAxes.YAxis(2).Limits = [min(pointsTempAcum)-5 max(pointsTempAcum)+5];
            %             handles.acumAxes.XTick = timeAcumVector;
            %             handles.acumAxes.XTickLabels = ticksAcum';
            
            if isequal(displayTemp,0)   
                handles.acumAxes.YAxis(2).Visible = 'off';
                lineTempAcum.Visible = 'off';   
            else
                handles.acumAxes.YAxis(2).Visible = 'on';
                lineTempAcum.Visible = 'on';    
            end
            
            
            grid on
            grid minor

            refreshdata(lineFreqAcum);
            refreshdata(lineTempAcum);
            refreshdata(handles.acumAxes);
            
            drawnow limitrate
            
        end

        set(handles.rawFrequencyVal, 'String',freqChunkConverted);
        set(handles.wildCardStr, 'String',num2str(frequencyPoint));
        set(handles.meanFreqVal, 'String',num2str(avgFreqConverted) );
        set(handles.enlapsedVal, 'String', e);
        set(handles.tempVal, 'String', strcat(num2str(temperaturePoint),strcat( {' '}, {char(176)},{'C'})));
        
        iterations = iterations+1;
    end
end

handles.contAxes.YAxis(1).Visible = 'off';
handles.contAxes.YAxis(2).Visible = 'off';
lineFreqCont.Visible = 'off';
lineTempCont.Visible = 'off';

set(handles.console, 'String','Operation Completed');
pause(0.1)
set(handles.console, 'String', ' Creating Matrix...');
pause(0.1)

    set(handles.console, 'String','Matrix from accumulative');
    
    [numericTime, timeStamp, tempTimeVector] = timeVectorManagement(timePoints, datePoints);
    
    %smoothFreq = smooth(numericTime,freqAcum ,0.09, 'rloess');   % Takes ages to process. Removed for now
	smoothFreq = freqAcum;
    
    val = get(handles.baselineCheck,'Value');
    handles.baselineCalFlag = val;
    
    if isequal(handles.baselineCalFlag, 1) % If baseline cal is selected, the format includes RAW data
       frequencyRAWBuffer = freqAcum + handles.baseline;
       dataMatrix = createMatrix(numericTime', freqAcum, tempAcum, smoothFreq, frequencyRAWBuffer);
    else
       dataMatrix = createMatrix(numericTime', freqAcum, tempAcum, smoothFreq); % USE THIS FORMAT, CAREFUL!
    end
    
set(handles.saveTXT, 'Enable', 'on');
set(handles.saveExcel, 'Enable', 'on');
set(handles.plotDataNOSmoothing, 'Enable', 'on');
set(handles.plotDataSmoothed, 'Enable', 'on');
pause(0.1);
set(handles.console, 'String', ' Data Matrix Created!');
pause(0.1)

plotDataNew(dataMatrix, 0, 0, handles)
set(handles.console, 'String', ' Final data shown');


end