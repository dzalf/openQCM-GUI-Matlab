function  smoothMatrix = smoothData(data)

xValues = data(:,1);
yValues = data(:,2);
GPUValsY = gpuArray(yValues);

yLimitOriginal  = [min(data(:, 2))-0.1 max(data(:, 2))+0.1];

% fig4 = figure(4);
% fig4.Name = 'Smoothed data';

hold on
grid on
grid('minor')
axesFinalPlot = gca;
set(axesFinalPlot,'FontSize',11);

% Construct a questdlg with three options
choice = questdlg('Smooth algorithm calibration?', ...
    'Smoothing calibration', ...
    'Yes','No', 'No');
% Handle response
switch choice
    case 'Yes'
        %             msgbox('Processing...','Continue');
        
        opc = 1;
    case 'No'
        
        opc = 0;
        
end


if isequal(opc,1)
    
    maxTestVals = 5;
    testValueWindow = linspace(0.01,0.5,maxTestVals);
    % smoothIntensity = smooth(xValues,yValues ,'sgolay',2);
    tic
    for i =1:maxTestVals
        figure
        hold on
        smoothData = smooth(xValues,yValues ,testValueWindow(i), 'rloess');
        
        correlation(1,i) = corr(yValues,smoothData)
        
        
        
        title(strcat({'Original vs Smooth data'},{' '}, {'R^2 = '},{' '},{ num2str(correlation(1,i))}));
        
        plot(xValues,smoothData, 'LineWidth', 2);
        
        plot(xValues,yValues, 'LineWidth', 0.7);
        
        ylim(yLimitOriginal);
        xlim([min(data(:,1)) max(data(:,1))])
        
        
        ylabel('\Delta F');
        xlabel('Time [min]');
        
        legend('Smooth', 'Original ','Location', 'northeast');
        
    end
    
    %
    %     smoothParams(:,1) = testValueWindow;
    %     smoothParams(:,2) = correlation;
    %
    %
    %     [winVal,Pos] = min(smoothParams(:,2))
    %
    %     bestWindow = smoothParams(Pos,1)
    
    
else
    
    x = inputdlg('Enter smoothing window size (0.001-0.2)',...
        'Sample', [1 30]);
    val = str2num(x{:});
    
    smoothData = smooth(xValues,yValues ,val, 'rloess');
    correlation = corr(yValues,smoothData)
    
    
    
    title(strcat({'Original vs Smooth data'},{' '}, {'R^2 = '},{' '},{ num2str(correlation)}));
    
    plot(xValues,smoothData, 'LineWidth', 2);
    
    plot(xValues,yValues, 'LineWidth', 0.7);
    
    ylim(yLimitOriginal);
    xlim([min(data(:,1)) max(data(:,1))])
    
    
    ylabel('\Delta F');
    xlabel('Time [min]');
    
    legend('Smooth', 'Original ','Location', 'northeast');
    title(strcat({'Original vs Smooth data'},{' '}, {'R^2 = '},{' '},{ num2str(correlation)}));
    
end



smoothMatrix(:,1) = xValues;
smoothMatrix(:,2) = smoothData;
end