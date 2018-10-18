function baseline = dataFit(timeFreq, pointsFreq)
format short;

baseAdjust = polyfit(timeFreq,pointsFreq,1);
baselineFit = baseAdjust(1)*timeFreq+baseAdjust(2);

standardError = std(pointsFreq)/sqrt(length(pointsFreq));
tScore = tinv([0.025  0.975],length(pointsFreq)-1);
confInter = mean(pointsFreq) + tScore*standardError;

bLConfInt = confInter(1);% mode(pointsFreq);
baseline = round(bLConfInt,1);
correlation = corr2(pointsFreq,baselineFit);


end