clc
clear
close all
ALIAS = [];

serialBufferSize = 22;  % Number of bytes to let in the buffer Format --> RAWMONITORXXXXX_XXX
loggingBufferSize = 10; % Accumulations buffer. Stores 10 values to be averaged

[devices, comPort] = querySerialPorts();

if ~isempty(comPort)
    
    frequenciesList = {'5 MHz','10 MHz'};
    chipSelected = listdlg('Name','Select QCM ',...
        'PromptString', 'Select the operating frequency of the QCM chip:',...
        'SelectionMode','single',...
        'InitialValue',[2],...
        'ListString',frequenciesList,...
        'ListSize', [250 50]);
    if isempty(chipSelected)
        chipSelected = 2;
    end
    
    switch chipSelected
        case 1
            ALIAS = 0;    % Correction factor for 10 MHz crystal
        case 2
            ALIAS = 8000000;          % Correction factor for 5 MHz crystal
            
    end
    
 
    openQCM = startSerial (comPort, serialBufferSize);  % Configure serial port and open communication
    % return the serial
    % object 'openQCM'
    prompt = {'Baseline calibration time (in minutes)'};
    name = 'Calibration time';
    defaultans = {'3'};
    options.Interpreter = 'tex';
    answer = inputdlg(prompt,name,[1 50],defaultans,options);
    calTime = str2double(cell2mat(answer)); % Value in minutes for calibration of the baseline frequency
    
    
    if ~isnan(calTime)&& ~isequal(calTime,0)
        % The baseline calibration routine returns the time and frequencies vectors
        % from which a polynomial fit will be extracted and the mean value for the
        % final baseline correction
        [timeFreq, pointsFreq] = baseLineCal(openQCM, loggingBufferSize, serialBufferSize, calTime, ALIAS);
        % routine for  polynomial fit and plotting on top of the baselineCal
        % function
        baseline = dataFit(timeFreq, pointsFreq);
        %Data is dynamically drawn on the 'canvas'. After closing the 'live'
        %plot, the matrix containing the data
        [dataMatrix, timeStamp] = drawData(openQCM, serialBufferSize, loggingBufferSize, baseline, ALIAS);
    else
        noCalMsgBox = msgbox('Running without baseline calibration', 'ATTENTION!','warn');
        baseline = 0;
        [dataMatrix, timeStamp] = drawData(openQCM, serialBufferSize, loggingBufferSize, baseline, ALIAS);
        if noCalMsgBox.Visible == 'on'
            noCalMsgBox.Visible = 'off';
        end
    end
    flushinput(openQCM);
    fclose(openQCM);
    % Special function to plot the acquired data points
    
    plotData(dataMatrix);
    
    
    savingOption = questdlg('Would yo like to save the data?', 'Write output file', ...
        'text File','excel File', 'No', 'No');
    
    if strcmp(savingOption, 'text File')
        selected = 1; % txt
    elseif strcmp(savingOption,'excel File')
        selected = 2; % excel
    else
        selected = 0;
    end
    
    writeFile(dataMatrix, selected, timeStamp);
else
    [cdata,map] = imread('error.png');
    msgbox('No device selected or present! Stopping DAQ','Error','custom',cdata,map);
    return
end

clc
clear
