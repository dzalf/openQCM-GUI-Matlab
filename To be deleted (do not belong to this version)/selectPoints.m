
function points = selectPoints (normData, filename)
loop = 1;

while isequal(loop,1) 
    
    dataX = normData(:,1);
    dataY = normData(:,2);
    
    fig2 = figure(2);
    fig2.Name = ('Data selection');
    
    hold on
    grid on
    title({'Select breaking points (aprox position)',[' File --> ' filename]}, 'interpreter', 'none')
    plot(dataX,dataY, 'Color',[0,0.5,0.7], 'LineWidth', 1.5)
    ylabel('\Delta F');
    xlabel('time [min]');
    
    
    [p1(1), p1(2)] = ginput(1); % First point
 
    plot( p1(1), p1(2), '-ro')
    text(p1(1), p1(2), ['   x = ', num2str(p1(1)), 'y = ', num2str(p1(2))])
    
    
    [p2(1), p2(2)] = ginput(1); % Second point
    
    plot( p2(1), p2(2), '-ro')
    text(p2(1), p2(2), ['   x = ', num2str(p2(1)), 'y = ', num2str(p2(2))])
    title('Points selected on original data set')
    
    % Construct a questdlg with three options
    choice = questdlg('Would you like to continue?', ...
        'Points selected!', ...
        'Yes','Select again', 'Yes');
    % Handle response
    switch choice
        case 'Yes'
%             msgbox('Processing...','Continue');
       
            loop = 0;
        case 'Select again'
            msgbox('Select points again','Redo' );
            loop = 1;
            delete(fig2)
    end
    
end

transpA = normData';  % Transpose data

% Parameters for point 1
difPoint1 = p1(1,1) - transpA(1,:);
distPoint1 = abs(difPoint1);
[rPoint1,posPoint1] = min(distPoint1);

% Parameters for point 2
difPoint2 = p2(1,1) - transpA(1,:);
distPoint2 = abs(difPoint2);
[rPoint2,posPoint2] = min(distPoint2);

points = [posPoint1,posPoint2];


end