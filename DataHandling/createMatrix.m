function dataMatrix = createMatrix(varargin)

numArgs = nargin;
samples = size(varargin{1}, 2);

switch numArgs
    
    case 4
            
            dataMatrix = zeros(samples, numArgs);

            dataMatrix(:, 1) = varargin{1}'; % Time column
            dataMatrix(:, 2) = varargin{2}'; % Frequency column
            dataMatrix(:, 3) = varargin{3}'; % Temperature column
            dataMatrix(:, 4) = varargin{4};
    case 5
        
        
            dataMatrix = zeros(samples, numArgs);

            dataMatrix(:, 1) = varargin{1}'; % Time column
            dataMatrix(:, 2) = varargin{2}'; % Frequency column
            dataMatrix(:, 3) = varargin{3}'; % Temperature column
            dataMatrix(:, 4) = varargin{4};
            dataMatrix(:, 5) = varargin{5};
            
end