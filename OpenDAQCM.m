function varargout = OpenDAQCM(varargin)
% OPENDAQCM MATLAB code for OpenDAQCM.fig


% Edit the above text to modify the response to help OpenDAQCM

% Last Modified by GUIDE v2.5 23-Feb-2018 21:09:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @OpenDAQCM_OpeningFcn, ...
    'gui_OutputFcn',  @OpenDAQCM_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before OpenDAQCM is made visible.
function OpenDAQCM_OpeningFcn(hObject, eventdata, handles, varargin)

movegui('center')

handles = MainDataStructure(handles);  % Initialize the main group data structure

addpath(genpath(handles.base_directory));  % Add all m-file directories to the search path

% Load initial state of controls and buttons
handles = initialState(handles);

% Show date & time
handles.date = datestr(now, 21);
set(handles.timeBox, 'Enable','on');
set(handles.timeBox, 'String',handles.date);


% logoUOM = imread('openQCM.jpg');
% axes(handles.openQCMLogo)
% imshow(logoUOM, 'parent', handles.openQCMLogo);

noSignal = imread('noSignal2.jpg');
axes(handles.dataGraph)
imshow(noSignal, 'parent', handles.dataGraph);

% signalDamped = imread('waves.jpg');
% axes(handles.signalLogo)
% imshow(signalDamped, 'parent', handles.signalLogo);

handles.positionGUI = get(hObject, 'Position');
% Choose default command line output for OpenDAQCM
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = OpenDAQCM_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;
return

% --- Executes on button press in queryCOMPush.
function queryCOMPush_Callback(hObject, eventdata, handles)

set(handles.console, 'String', 'Looking for available devices');

handles.cleanDevices = querySerialPorts();
[r,c] = size(handles.cleanDevices);

if ~isempty(handles.cleanDevices)
    
    for i=1:r
        if strcmp(handles.cleanDevices(i,1), 'Arduino Micro')
            handles.openQCMindex(1,1) = i;
            COMStr = strcat('- COM',num2str(cell2mat(handles.cleanDevices(i,2))) );
            stringDevices{1,1 } = strcat(' openQCM 1.3 ', COMStr);
        end
        
        if strcmp(handles.cleanDevices(i,1), 'Arduino Leonardo')
            handles.openQCMindex(1,2) = i;
            COMStr = strcat('- COM',num2str(cell2mat(handles.cleanDevices(i,2))) );
            stringDevices{i+1,1 } = char(strcat({' Debugging FaKeOpEnQcM'},{' '}, {COMStr}));
        end
     
        if and(~strcmp(handles.cleanDevices(i,1), 'Arduino Micro'),~strcmp(handles.cleanDevices(i,1), 'Arduino Leonardo') )
            
            stringDevices{i+1,1} = char(handles.cleanDevices(i,1));
            
        end
    end
    
    set(handles.console, 'String', 'Devices found! :)');
    set(handles.portsList, 'String', stringDevices(:,1));
    pause(0.2)
    set(handles.console, 'String', 'Select a device from the list');
    set(handles.portsList, 'Enable', 'on')
    set(handles.portsList, 'FontSize', 11)
    set(handles.portsList, 'FontWeight', 'bold')
else
    pause(0.5);
    set(handles.console, 'String', 'No devices found! :(');
    pause(0.5);
    handles = initialState(handles);
end

set(handles.timeBox, 'String',datestr(now, 21));
guidata(hObject, handles);  % Update the handles structure
return


% --- Executes on selection change in portsList.
function portsList_Callback(hObject, eventdata, handles)

set(handles.console, 'String', 'Working on selection...');
pause(0.1)
set(handles.portsList, 'Enable', 'off')
set(handles.portsList, 'FontWeight', 'bold')
set(handles.queryCOMPush, 'Enable', 'off');

indexPortsList = get(handles.portsList,'Value');

handles.comPort = strcat('COM', num2str(cell2mat(handles.cleanDevices(handles.openQCMindex(1,indexPortsList),2))));

stringFound =  strcat('Device found and linked in -> ', handles.comPort);
set(handles.console, 'String', stringFound);
set(handles.console, 'String', 'Opening port...');

[success,handles.openQCM] = startSerial (handles.comPort, handles.serialBufferSize);

if isequal(success,1)
    set(handles.console, 'String', 'Serial port ready');
    set(handles.killCOM, 'Enable', 'on');
    set(handles.startButton,'Enable', 'on')
    set(handles.startButton, 'BackgroundColor', [0 0.7 0]);
else
    set(handles.console, 'String', 'Opening serial failed');
    pause(1);
    set(handles.console, 'String', 'Try again...');
end

set(handles.timeBox, 'String',datestr(now, 21));

guidata(hObject, handles);  % Update the handles structure
return


% --- Executes on button press in killCOM.
function killCOM_Callback(hObject, eventdata, handles)

setFlagAcquisiton(0);
flushinput(handles.openQCM);
fclose(handles.openQCM);

set(handles.startButton, 'Enable', 'off');
set(handles.startButton, 'BackgroundColor', [0.5 0.5 0.5]);

set(handles.killCOM, 'Enable', 'off');
set(handles.console, 'String', 'Serial port closed');
pause(0.5);
set(handles.console, 'String', 'Select USB device from the list');
set(handles.portsList, 'Enable', 'on');
set(handles.portsList, 'FontWeight', 'normal');
set(handles.portsList, 'FontSize', 12)

set(handles.queryCOMPush, 'Enable', 'on');

guidata(hObject, handles);  % Update the handles structure
return

% --- Executes on button press in baselineCheck.
function baselineCheck_Callback(hObject, eventdata, handles)

val = get(hObject,'Value'); %returns toggle state of baselineCheck
handles.baselineCalFlag = val;

if isequal(val, 1)
    set(handles.CalMinutesVal, 'Enable', 'on');
    strTime = num2str(handles.lastCalMinutesTime);
    set(handles.CalMinutesVal, 'String', strTime);
    handles.baselineCalTime = str2double(get(handles.CalMinutesVal, 'String'));
else
    if isequal(val, 0)
        set(handles.CalMinutesVal, 'Enable', 'off');
        set(handles.CalMinutesVal, 'String', '<disabled>');
        
    end
end
set(handles.timeBox, 'String',datestr(now, 21));
guidata(hObject, handles);
return

function CalMinutesVal_Callback(hObject, eventdata, handles)

timeStr = get(hObject, 'String');
handles.baselineCalTime = str2double(timeStr);
handles.lastCalMinutesTime = handles.baselineCalTime;
guidata(hObject, handles);
return

% --- Executes on button press in fiveButton.
function fiveButton_Callback(hObject, eventdata, handles)
sel = get(hObject, 'Val');

if isequal(sel, 1)
    set(handles.tenButton, 'Value', 0) ;
    handles.ALIAS = 0;
    
end

guidata(hObject, handles);
return

% --- Executes on button press in tenButton.
function tenButton_Callback(hObject, eventdata, handles)
sel = get(hObject, 'Val');

if isequal(sel, 1)
    set(handles.fiveButton, 'Value', 0) ;
    handles.ALIAS = 8000000;
end

guidata(hObject, handles);
return


% --- Executes on button press in continuousButton.
function continuousButton_Callback(hObject, eventdata, handles)
sel = get(hObject, 'Val');

if isequal(sel, 1)
    set(handles.accumulativeButton, 'Value', 0) ;
    set(handles.axisSlider, 'Enable', 'on');
    set(handles.zoomVal, 'Visible', 'on');
    
     
%     handles.continuous = 1;
end

guidata(hObject, handles);
return


% --- Executes on button press in accumulativeButton.
function accumulativeButton_Callback(hObject, eventdata, handles)
sel = get(hObject, 'Val');

if isequal(sel, 1)
     set(handles.continuousButton, 'Value', 0) ;
      set(handles.axisSlider, 'Enable', 'off');
      set(handles.zoomVal, 'Visible', 'off');
      
      
     
%     handles.continuous = 0;
end

guidata(hObject, handles);
return


% --- Executes on button press in showTempCheck.
function showTempCheck_Callback(hObject, eventdata, handles)

 val =get(hObject, 'Value');
 handles.showTemp = val;

guidata(hObject, handles);
return


% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)

handles.baselineCalFlag  = get(handles.baselineCheck,'Value'); %returns toggle state of baselineCheck

set(handles.exit, 'Enable', 'off');
setFlagAcquisiton(1);
set(handles.dataGraph, 'NextPlot', 'replace')
set(handles.startButton,'Enable', 'off')
set(handles.killCOM, 'Enable', 'off');
set(handles.aboutMenu, 'Enable', 'off');
set(handles.timeBox, 'String',datestr(now, 21));

if isequal(handles.baselineCalFlag, 1) % Run with baseline cal
    
    set(handles.console, 'String','Starting calibration...Please wait!');
    
    [handles.timeFreq, handles.pointsFreq] = baseLineCalNew(handles);
    set(handles.console, 'String','Computing baseline statistics...');
    set(handles.dataPanel, 'Title', 'QCM Data Acquisition Display');
    handles.baseline = dataFit(handles.timeFreq, handles.pointsFreq);
    
    pause(0.5)
    
    baselineStr = strcat('Baseline found: ', num2str(handles.baseline));
    set(handles.console, 'String', baselineStr);
    set(handles.baselineVal, 'String', num2str(handles.baseline));
    set(handles.killCOM, 'Enable', 'off'); %remove later
    set(handles.console, 'String','Wait...');
    pause(1.5);
    
    set(handles.wildCardLabel, 'String', 'Delta F');
    set(handles.wildCardStr, 'String', '< Hz >');
    set(handles.wildCardStr, 'BackgroundColor', [0 0 0]);
    set(handles.console, 'String','Starting live capture...');
    
%     [handles.dataMatrix, handles.timeStamp] = drawData(handles);
[handles.dataMatrix, handles.timeStamp] = drawNewGUI(handles);
    
else
    
    if isequal(handles.baselineCalFlag, 0)
        
        set(handles.console, 'String','Running without baseline calibration');
        pause(2);
        handles.baseline  = 0;
        set(handles.console, 'String', 'Filling buffers, please wait...');
        set(handles.wildCardLabel, 'String', 'Delta F');
        set(handles.wildCardStr, 'BackgroundColor', [0 0 0]);
%         [handles.dataMatrix, handles.timeStamp] = drawData(handles);
        [handles.dataMatrix, handles.timeStamp] = drawNewGUI(handles);
    end
end

   guidata(hObject, handles);  % Update the handles structure
    return

% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
set(handles.exit, 'Enable', 'on');
set(handles.aboutMenu, 'Enable', 'on');
set(handles.console, 'String', 'Stopping acquisition');

%     handles.goFlag = 0;
setFlagAcquisiton(0);
pause(1);
set(handles.startButton,'Enable', 'on')
% set(handles.axisSlider, 'Enable', 'off');
% set(handles.zoomVal, 'Enable', 'off');
set(handles.killCOM,'Enable', 'on')
set(handles.stopButton,'Enable', 'off')
set(handles.stopButton, 'BackgroundColor', [0.7 0.7 0.7]);

% set(handles.enlapsedVal, 'String', '<enlapsed time>');
% set(handles.wildCardStr, 'String','<frequency val>' );
set(handles.console, 'String', 'Comunication stopped!');

guidata(hObject, handles);  % Update the handles structure
return


% --------------------------------------------------------------------
function saveTXT_Callback(hObject, eventdata, handles)

writeFile(handles,1);

return

% --------------------------------------------------------------------
function saveExcel_Callback(hObject, eventdata, handles)

writeFile(handles, 2);

return

% --------------------------------------------------------------------
function plotDataNOSmoothing_Callback(hObject, eventdata, handles)

    plotDataNew(handles.dataMatrix, 0, 1, handles)

return
% --------------------------------------------------------------------
function plotDataSmoothed_Callback(hObject, eventdata, handles)

    plotDataNew(handles.dataMatrix,1, 1, handles)

return

% --------------------------------------------------------------------
function aboutMenu_Callback(hObject, eventdata, handles)
screenSize = get(0, 'ScreenSize');
position(1) = (screenSize(3)-handles.positionGUI(3))/2;
position(2) = (screenSize(4)-handles.positionGUI(4))/2;
posFig = get(handles.GUIFigure, 'Position');
d = dialog('Position',[position(1) position(2)  300 200],'Name','About...');
    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[10 30 290 135],...
               'String',{'Code developed by:',[' '],['Daniel Melendrez'],[' '],['2017']});
           txt.FontSize = 11.5;
    btn = uicontrol('Parent',d,...
               'Position',[120 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');
           btn.FontSize = 11;
return

% --------------------------------------------------------------------
function saveDataMenu_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function loadFile_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
set(handles.console, 'String', ' Powering off ');
portExist = exist('handles.openQCM');
if isequal(portExist, 1)
    flushinput(handles.openQCM);
    fclose(handles.openQCM);
end
set(handles.console, 'String', '  ...sleeping U_U ');
% put here function for saving current state from instrument
pause(1);
% killCOM
set(handles.console, 'BackgroundColor', [0.7 0.7 0.7]);


close all
return


function timeBox_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function timeBox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function console_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function console_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function rawFrequencyVal_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function rawFrequencyVal_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wildCardStr_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function wildCardStr_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tempVal_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function tempVal_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function enlapsedVal_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function enlapsedVal_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function meanFreqVal_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function meanFreqVal_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function portsList_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function CalMinutesVal_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function fileMenu_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function plotDataMenu_Callback(hObject, eventdata, handles)


% --- Executes on slider movement.
function axisSlider_Callback(hObject, eventdata, handles)

setFlagAcquisiton(1);
 
%         handles.plotRealTimeData.YLim = [handles.frequencyPoint-100, handles.frequencyPoint+100];
 guidata(hObject, handles); 


% --- Executes during object creation, after setting all properties.
function axisSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axisSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function zoomVal_Callback(hObject, eventdata, handles)
% hObject    handle to zoomVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zoomVal as text
%        str2double(get(hObject,'String')) returns contents of zoomVal as a double


% --- Executes during object creation, after setting all properties.
function zoomVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zoomVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function baselineVal_Callback(hObject, eventdata, handles)
% hObject    handle to baselineVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of baselineVal as text
%        str2double(get(hObject,'String')) returns contents of baselineVal as a double


% --- Executes during object creation, after setting all properties.
function baselineVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baselineVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
