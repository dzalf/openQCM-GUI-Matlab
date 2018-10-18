function plotData(dataMatrix)

plotDataFinal = figure;


meanFreq = mean(dataMatrix(:, 2));
meanTemp = mean(dataMatrix(:, 3));

yLimitFreq  = [min(dataMatrix(:, 2))-2 max(dataMatrix(:, 2))+2];
yLimitTemp =  [min(dataMatrix(:, 3))-2 max(dataMatrix(:, 3))+2];

timeVector = dataMatrix(:, 1)./60;
freqVector = dataMatrix(:, 2);
tempVector = dataMatrix(:, 3);

hold off
grid on
axesFinalPlot = gca;
set(axesFinalPlot,'FontSize',11);
% set(axesFinalPlot,'Color',[0.7 0.7 0.7]);
% set(gcf,'Color',[0.7 0.7 0.7])
yyaxis left

Ffilt = sgolayfilt(freqVector,4,5);
Tfilt = sgolayfilt(tempVector,4,5);
%
Fsmooth = smooth(timeVector,Ffilt ,'sgolay',2);
Tsmooth = smooth(timeVector,Tfilt ,'sgolay',2);

plot(timeVector,Ffilt, 'LineWidth', 0.75);

% ax.YAxis(1).Exponent = 6;
% line(timeVector, meanFreq, 'LineStyle','-', 'Marker', '.', 'LineWidth', 0.25);

ylim(yLimitFreq)

yyaxis right
plot(timeVector,Tfilt, 'LineWidth', 0.75);
% line(timeVector, meanTemp, 'LineStyle','-',  'Marker', '.', 'LineWidth', 0.25);

ylim(yLimitTemp)

yyaxis left
title('\DeltaF and Temperature openQCM')
xlabel('Time [hours] ')
ylabel('\DeltaF [Hz]')

yyaxis right
ylabel('Temperature')
legend('Frequency shift ', 'Temperature ','Location', 'northeast');

end