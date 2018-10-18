function [chunk1,chunk2,chunk3] = partitionData(normData, points)
posPoint1  = points(1);
posPoint2  = points(2);
% Data separation --> chunks are created
chunk1 = normData(1:posPoint1,:);
chunk2 = normData(posPoint1:posPoint2,:);
chunk3 = normData(posPoint2:end,:);

% Plot created sections
dataSelection = figure(3);
dataSelection.Name = 'Data partitioning';

fig3 = figure(3);
fig3.Name = 'Data partition';

subplot(2,3,[1 3])
hold on
grid on
grid('minor')

plot(chunk1(:,1),chunk1(:,2), 'r')
plot(chunk2(:,1),chunk2(:,2), 'g')
plot(chunk3(:,1),chunk3(:,2), 'b')
ylabel('\Delta F');

plot(chunk1(end,1),chunk1(end,2) , '-s')
plot(chunk2(end,1),chunk2(end,2) , '-s')

vline(normData(posPoint1,1),'r','Section 1');
vline(normData(posPoint2,1),'r','Section 2');

title('Sections selected', 'FontSize', 14)

% suptitle ('Extracted data sections')
subplot(2,3,4)
grid on
grid('minor')
hold on
plot(chunk1(:,1),chunk1(:,2), 'r')
xlim([min(chunk1(:,1)) max(chunk1(:,1))])
ylim([min(chunk1(:,2)) max(chunk1(:,2))])
ylabel('/Delta F');

title('Section 1')

subplot(2,3,5)
grid on
grid('minor')
hold on
plot(chunk2(:,1),chunk2(:,2), 'g')
xlim([min(chunk2(:,1)) max(chunk2(:,1))])
ylim([min(chunk2(:,2)) max(chunk2(:,2))])

xlabel('time [min]');
title('Section 2')

subplot(2,3,6)
grid on
grid('minor')
hold on
plot(chunk3(:,1),chunk3(:,2), 'b')
xlim([min(chunk3(:,1)) max(chunk3(:,1))])
ylim([min(chunk3(:,2)) max(chunk3(:,2))])

title('Section 3')

suptitle ('\fontsize{20} Data partitioning');

clc

end