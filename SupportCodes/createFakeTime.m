function [timePoints,datePoints]=createFakeTime(time, pauseT)
clc

startTime = datetime('now', 'Format','HH:mm:ss:ms') ;
% pause(0.1)
for i=1:time
    
    t(i,1) =  datetime('now', 'Format','HH:mm:ss:ms')- startTime; %, 'Format','HH:mm:ss'
    timePoints(i,1) = datenum(t(i));
    datePoints(i,1) = datetime('now', 'Format', 'dd-MMM-yyyy HH:mm:ss:ms');
    
    enlapsed{i,1} = char(t(i,1)); %+initialTime
    e = enlapsed(i);
    pause(pauseT)
end


end