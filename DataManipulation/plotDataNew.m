function plotDataNew(dataMatrix, selection, newFig, handles)

if isequal(newFig, 1)
    
    plotDataFinal = figure;
    plotDataFinal.Name = 'Captured data';
    axesFinalPlot = gca;
    set(axesFinalPlot,'FontSize',11);
    set(axesFinalPlot,'Color',[77/255, 87/255, 104/255]);
    set(axesFinalPlot);
    set(plotDataFinal,'Color',[37/255, 49/255, 68/255]);
    set(axesFinalPlot,'XColor',[1, 1, 1]);
    set(axesFinalPlot,'YColor',[1, 1, 1]);
    set(axesFinalPlot,'Box', 'on');
    
else
    if isequal(newFig, 0)
        axes(handles.dataGraph);
        axesFinalPlot  = gca;
        cla(axesFinalPlot,'reset')
        
        
        set(axesFinalPlot,'FontSize',11);
        set(axesFinalPlot,'Color',[0.15, 0.15, 0.15]);
        set(axesFinalPlot);
        set(axesFinalPlot,'GridColor',[146/255 158/255 179/255]);
        set(axesFinalPlot,'XColor',[187/255 192/255 199/255]);
        set(axesFinalPlot,'YColor',[187/255 192/255 199/255]);
        
    end
    
end

timeVector = dataMatrix(:, 1);
freqVector = dataMatrix(:, 2);



switch selection
    
    case 1 % WITH  smoothing
        
        %         Ffilt = sgolayfilt(freqVector,4,5);
        %         Fsmooth = smooth(timeVector,Ffilt ,'sgolay',2);
        Fsmooth = smooth(timeVector,freqVector ,0.09, 'rloess');
        
        correlation = corr(freqVector,Fsmooth);
        
        hold on
        grid on
        
        plot(timeVector,freqVector, 'LineWidth', 3.0, 'Color',[237/255, 178/255, 75/255]);
        plot(timeVector,Fsmooth, 'LineWidth',1.5 , 'Color',[113/255, 4/255, 229/255]);
        axesFinalPlot.YLim = [min(freqVector)-10 max(freqVector)+10];
        
        xpos = max(timeVector)*0.7;
        ypos = mean(freqVector)+2 ;
        txt = text(xpos, ypos, ['R^2 = ' num2str(correlation)]);
        txt.Color = [237/255, 225/255, 137/255];
        txt.FontSize = 12;
        
        titleHandleDraw = title('\DeltaF - openQCM data ');
        
        set(axesFinalPlot, 'Title', titleHandleDraw);
        titleHandleDraw.Color = ([112/255, 170/255, 204/255]);
        titleHandleDraw.FontSize = 28;
        
        xlabel('Time [minutes] ')
        ylabel('Frequency [Hz]')
        
        leg = legend('Original Data','Smoothed Response','Location', 'northeast');
        leg.FontSize = 12;
        leg.Color = [112/255, 170/255, 204/255];
        
        set(axesFinalPlot,'FontSize',11);
        set(axesFinalPlot,'Color',[77/255, 87/255, 104/255]);
        set(axesFinalPlot);
        if isequal(newFig, 1)
            set(plotDataFinal,'Color',[37/255, 49/255, 68/255])
        end
        set(axesFinalPlot,'XColor',[1, 1, 1]);
        set(axesFinalPlot,'YColor',[1, 1, 1]);
        set(axesFinalPlot,'Box', 'on');
        
    case 0
        
        plot(timeVector,freqVector, 'LineWidth', 1.5, 'Color',[103/255, 148/255, 219/255]);
        axesFinalPlot.YLim = [min(freqVector)-10 max(freqVector)+10];
        hold off
        grid on
        
        titleHandleDraw = title('\DeltaF - openQCM data ');
        
        set(axesFinalPlot, 'Title', titleHandleDraw);
        titleHandleDraw.Color = ([112/255, 170/255, 204/255]);
        titleHandleDraw.FontSize = 22;
        xlabel('Time [minutes] ');
        ylabel(' Frequency [Hz]');
        legend('Frequency values','Location', 'northeast');
        set(axesFinalPlot,'FontSize',11);
        set(axesFinalPlot,'Color',[77/255, 87/255, 104/255]);
        set(axesFinalPlot);
        
        if isequal(newFig, 1)
            set(plotDataFinal,'Color',[37/255, 49/255, 68/255]);
        end
        
        set(axesFinalPlot,'XColor',[1, 1, 1]);
        set(axesFinalPlot,'YColor',[1, 1, 1]);
        set(axesFinalPlot,'Box', 'on');
        
end

end