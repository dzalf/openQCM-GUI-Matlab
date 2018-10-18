% This function extracts the time points from the encoded timePoints created by Matlab.
% Three formats are exported: 

	% numericTime is the individual time points for each data points
	% timeStamp is the clock for each captured sample
	% tempTimeVector contains additional numeric information for each captured data points
	
	% Last modified: 15-June-18
	% Author: Daniel Melendrez
	
function [numericTime, timeStamp, tempTimeVector] = timeVectorManagement(timePoints, datePoints)

[r,c]  = size(datePoints);
cellDateTime = cell(r,c);

for j =1:r

    cellDateTime{j,1} = datePoints(j,1);
    divided = strsplit(char(cellDateTime{j}), ' ');%datestr(timeFreq(j), 'HH:mm:ss') %,'HH:MM:SS'
    timeStamp{j,1} = divided(1); 
    timeStamp{j,2} = divided(2);
    tempTimeVector(j,:) = datevec(timePoints(j));
    timeVec(j,1) = tempTimeVector(1,6)/60;

end

format long

for i=1:r 
    times(i,1)=tempTimeVector(i,4)*60+tempTimeVector(i,5)+tempTimeVector(i,6)/60; 
end
format short
    numericTime = times(:,1)-times(1,1);
    size(numericTime)
end

