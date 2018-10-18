function [dataLoaded, filename,success, fig1] = loadData()

% Open file routine

[filename, pathname, success] = uigetfile('*.txt', 'Select a single .txt file to work with...' );

if isequal(filename,0)
    [cdata,map] = imread('error.png');
    msgbox('You cancelled loading data','Error','custom',cdata,map);
end
if isequal(success,1)
    file = char(filename(1,:));

    if ~isequal(filename, 0)
        dataLoaded = txt2mat(file);    
    end

    dx = dataLoaded(:,1);
    dy = dataLoaded(:,2);
    originalData = figure;
    originalData.Name = ('Original data file ');
    
    fig1 = figure(1);
    fig1.Name = 'Loaded file';
    plot(dx, dy, 'Color' ,[0.2,0.5,0.8], 'LineWidth', 1.5);
    ylabel('\DeltaF');
    xlabel('time [min]');
    t = title({['Data Loaded from: ', filename],[]});
    t.Interpreter = 'none';
    grid on
else
    dataLoaded = zeros(1,1);
    pathname = {' '};
    fig1 = 'null';
end
end