cleanDevices = querySerialPorts();
[r,c] = size(cleanDevices);

for i=1:r
        if strcmp(cleanDevices(i,1), 'Arduino Micro')
            openQCMindex(1) = i;
            COMStr = strcat('- COM',num2str(cell2mat(cleanDevices(i,2))) );
            stringDevices{i,1 } = strcat(' openQCM 1.3 ', COMStr);
        end
        
        if strcmp(cleanDevices(i,1), 'Arduino Leonardo')
            openQCMindex(2) = i;
            COMStr = strcat('- COM',num2str(cell2mat(cleanDevices(i,2))) );
            stringDevices{i,1 } = char(strcat({' Debugging FaKeOpEnQcM'},{' '}, {COMStr}));
        end
     
        if and(~strcmp(cleanDevices(i,1), 'Arduino Micro'),~strcmp(cleanDevices(i,1), 'Arduino Leonardo') )
            
            stringDevices{i,1} = char(cleanDevices(i,1));
            
        end
end
    
indexPortsList = 2
comPort = strcat('COM', num2str(cell2mat(cleanDevices(openQCMindex(1,indexPortsList),2))));