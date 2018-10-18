
function [timeFreq, pointsFreq] = baseLineCalNew(handles)

axes(handles.dataGraph);

flagAcq = getFlagAcquisition;


flagInitial = 0;    % Flag for first unique call of acquisition start time and stopping precalibration array filling
flagFigure = 0;     % Helps to create a figure object once the average array is complete
indexRows = 1;      % Index for median values array
indexACQ = 1;       % Index for average values array
iterations = 0;     % Index for total iterations. Helps to determine if the precalibration has been completed
initialLoop = 0;    % Precalibration iterations index
timePoint = 0;      % Time point variable. Stores the time spent between each capture and plotting

bufferMedianFreq = zeros(handles.loggingBufferSize/2,1);    % Buffer that stores the average values of each iteration. Lenth is half of the logging
bufferAverageFreq = zeros(handles.loggingBufferSize,1);

% Stores the current frequency values (from the serial buffer)
% and they're averaged on each iteration
bufferMedianTemp = zeros(handles.loggingBufferSize/2,1);
bufferAverageTemp = zeros(handles.loggingBufferSize,1);
set(handles.dataPanel, 'Title', 'Baseline Calibration Routine');
set(handles.stopButton, 'Enable', 'on');
set(handles.wildCardLabel, 'String', 'Remaining Time');
set(handles.wildCardStr, 'String', '<time>');
set(handles.dataGraph2, 'Visible', 'off');

while (timePoint < handles.lastCalMinutesTime) && (isequal(flagAcq,1))% || ishandle(plotBaseline)       % The whole loop is done for the time indicated by calTime var
    
        flagAcq = getFlagAcquisition;
        
        if iterations == 0
            tic
        end
        
        if  (flagInitial == 0) && (initialLoop > handles.loggingBufferSize+1) %2*loggingBufferSize (previous value)
            flagInitial = 1;
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
            baseline = (2*handles.ALIAS) - median(bufferMedianFreq); % ceil(median(bufferMedianFreq))
            avgFreqConverted =  (2*handles.ALIAS) - avgFreq;
        else
            baseline = (2*handles.ALIAS) + median(bufferMedianFreq);
            avgFreqConverted = (2*handles.ALIAS) + avgFreq;
        end
        
        temperaturePoint = median(bufferMedianTemp)/10;
        
        indexRows = indexRows + 1;
        indexACQ = indexACQ + 1;
        initialLoop = initialLoop + 1;
        
        if indexACQ > handles.loggingBufferSize
            indexACQ =  1;
        end
        
        if indexRows > handles.loggingBufferSize/2
            indexRows = 1;
        end
        
        if (initialLoop > handles.loggingBufferSize+1) && (flagInitial == 1) % 2*loggingBufferSize (previous value)
            
            timePoint = toc/60;
            
            if flagFigure == 0
                
                handles.axesBaselineCal  = gca;
                cla(handles.axesBaselineCal,'reset')
                
                set(handles.axesBaselineCal,'FontSize',9);
                set(handles.axesBaselineCal,'Color',[0.15 0.15 0.15]);
                set(handles.axesBaselineCal,'GridColor',[146/255 158/255 179/255]);
                set(handles.axesBaselineCal,'XColor',[187/255 192/255 199/255]);
                set(handles.axesBaselineCal,'YColor',[12/255 137/255 209/255]);
                grid on
                grid minor

                lineFreq =  line(timePoint,baseline, 'color', [12/255 137/255 209/255], 'LineWidth', 1, 'Parent', handles.axesBaselineCal);
                lineFreq.Parent.YLim = [baseline-50 baseline+50];
                
                
                xlabel('Time [min]')
                ylabel('Frequency [MHz]')
                
                handles.axesBaselineCal.YAxis(1).Exponent = 6;
                
                flagFigure = 1;
            end
            
            enlapsed = datetime('now')-startTime;
            remaining = char(duration(0, handles.lastCalMinutesTime,0)- enlapsed + initialTime);
            
            timeFreq = get(lineFreq, 'xData');
            pointsFreq = get(lineFreq, 'yData');
            timeFreq = [timeFreq timePoint];
            pointsFreq = [pointsFreq baseline];
            
            set(lineFreq, 'xData', timeFreq, 'yData', pointsFreq);
            
            handles.axesBaselineCal.YAxis(1).Limits = [min(pointsFreq)-10 max(pointsFreq)+10];
            
            refreshdata(lineFreq);

            set(handles.rawFrequencyVal, 'String',num2str(baseline) );
            set(handles.meanFreqVal, 'String',num2str(avgFreqConverted) );
            set(handles.enlapsedVal, 'String', char(enlapsed));
            set(handles.tempVal, 'String',  strcat(num2str(temperaturePoint),strcat( {' '}, {char(176)},{'C'})) );
            set(handles.wildCardStr, 'String', remaining);
            
            drawnow
            iterations = iterations + 1;
        end
    
end

if timePoint < (handles.lastCalMinutesTime)*0.8
    
    set(handles.console, 'String', 'Operation Cancelled by User');
    pause(1.5)
    setFlagAcquisiton(1);
    set(handles.startButton, 'Enable', 'off');
    
end

if timePoint >= (handles.lastCalMinutesTime)*0.8
    set(handles.console, 'String', 'Operation Completed!');
    pause(1.5)
    
end


end