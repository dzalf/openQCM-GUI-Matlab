function handles = initialState(handles)
% constant declaration
handles.serialBufferSize = 22;  % Number of bytes to let in the buffer Format --> RAWMONITORXXXXX_XXX
handles.loggingBufferSize = 10; % Accumulations buffer. Stores 10 values to be averaged
handles.ALIAS = 8000000; % Default value for 10 MHz
% handles.baselineCalFlag = 1;


% setSliderVal(0.1);
%  buttons
set(handles.killCOM, 'Enable', 'off')

set(handles.stopButton,'Enable', 'off');
set(handles.startButton,'Enable', 'off');
set(handles.portsList, 'Enable', 'off');
set(handles.startButton, 'BackgroundColor', [0.7 0.7 0.7]);
set(handles.stopButton, 'BackgroundColor', [0.7 0.7 0.7]);
% set(handles.axisSlider, 'Enable', 'off');
% set(handles.zoomVal, 'Enable', 'off');
set(handles.saveTXT, 'Enable', 'off');
set(handles.saveExcel, 'Enable', 'off');
set(handles.plotDataNOSmoothing, 'Enable', 'off');
set(handles.plotDataSmoothed, 'Enable', 'off');
set(handles.CalMinutesVal, 'String', '5.0');
set(handles.CalMinutesVal, 'Value', 5);
handles.lastCalMinutesTime = str2double(get(handles.CalMinutesVal, 'String'));


set(handles.wildCardStr, 'BackgroundColor', [0 0 0]);
set(handles.dataPanel, 'Title', 'Data Captured Display');
set(handles.zoomVal, 'Visible', 'off');
%Flags

% handles.goFlag = 0;
setFlagAcquisiton(0);
% Console message 

set(handles.console, 'String', ' Start querying USB devices');
set(handles.dataGraph2, 'Visible', 'off');
set(handles.axisSlider, 'Visible', 'off');
%Axes initial state




end