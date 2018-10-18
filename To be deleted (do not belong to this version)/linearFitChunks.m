function [fitValsChunk1, fitChunk1,fitValsChunk2, fitChunk2,fitValsChunk3, fitChunk3] = linearFitChunks(chunk1, chunk2, ...
    chunk3)

% Extract x and y data from each chunk
xChunk1 = chunk1(:,1);
xChunk2 = chunk2(:,1);
xChunk3 = chunk3(:,1);

yChunk1 = chunk1(:,2);
yChunk2 = chunk2(:,2);
yChunk3 = chunk3(:,2);

% Linear regression for chunk 1
[r1,m1,b1] = regression(xChunk1', yChunk1');
fitValsChunk1 = [r1, m1, b1];
% Linear regression for chunk 2
[r2,m2,b2] = regression(xChunk2', yChunk2');
fitValsChunk2 = [r2, m2, b2];
% Linear regression for chunk 3
[r3,m3,b3] = regression(xChunk3', yChunk3');
fitValsChunk3 = [r3, m3, b3];

%% Creation of data for regression line fit
fitChunk1 = zeros(size(chunk1,1),2);
fitChunk1(:,1) = xChunk1;
fitChunk1(:,2) = m1.*xChunk1 + b1;

fitChunk2 = zeros(size(chunk2,1),2);
fitChunk2(:,1) = xChunk2;
fitChunk2(:,2) = m2.*xChunk2 + b2;

fitChunk3 = zeros(size(chunk3,1),2);
fitChunk3(:,1) = xChunk3;
fitChunk3(:,2) = m3.*xChunk3 + b3;


% Plot computed data
fig5 = figure(5);
fig5.Name = ('Linear fit per section');

subplot(3,1,1)
hold on
grid on
plot(xChunk1,yChunk1,'r')
line(fitChunk1(:,1), fitChunk1(:,2), 'LineWidth',1.5, 'Color', [ 0.7, 0.5 0.9])
xlim([min(fitChunk1(:,1)) max(fitChunk1(:,1))])
% ylim([min(fitChunk1(:,2)) max(fitChunk1(:,2))])
title(['Section 1: m = ', num2str(m1)])

subplot(3,1,2)
hold on
grid on
plot(xChunk2,yChunk2,'g')
line(fitChunk2(:,1), fitChunk2(:,2), 'LineWidth',1.5, 'Color', [ 0.7, 0.5 0.9])
ylabel('\Delta F');
xlim([min(fitChunk2(:,1)) max(fitChunk2(:,1))])
% ylim([min(fitChunk2(:,2)) max(fitChunk2(:,2))])
title(['Section 2: m = ', num2str(m2)])

subplot(3,1,3)
hold on
grid on
plot(xChunk3,yChunk3,'b')
line(fitChunk3(:,1), fitChunk3(:,2), 'LineWidth',1.5, 'Color', [ 0.7, 0.5 0.9])

xlabel('time [min]');
xlim([min(fitChunk3(:,1)) max(fitChunk3(:,1))])
% ylim([min(fitChunk3(:,2)) max(fitChunk3(:,2))])
title(['Section 3: m = ', num2str(m3)])

suptitle ('\fontsize{20} Linear fits')
end