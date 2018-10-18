function argsTest(varargin)

    numArgs = nargin;
    
    disp('Num args');
    disp(numArgs);
    
    if numArgs == 3
        totSum = sum([varargin{:,:}]);
        disp('Sum = ');
        disp(totSum);
    elseif numArgs == 5
        totAvg = mean([varargin{:,:}]);
        disp('Prod = ');
        disp(totAvg);
    else
        disp('Not enough inputs')
    end
    

end