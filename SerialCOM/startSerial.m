function [success,openQCM] = startSerial (comPort, serialBufferSize)

    openQCM = serial(comPort);
    openQCM.DataTerminalReady = 'on';
    openQCM.InputBufferSize = serialBufferSize;
    set(openQCM,'DataBits',8);
    set(openQCM,'StopBits',1);
    set(openQCM,'BaudRate',115200);
    set(openQCM,'Parity','none');
    
    try
        fopen(openQCM);
        success = 1;
    catch err
        success = 0;
        fclose(instrfind);
        error('Make sure you select the correct COM Port where the OpenQCM is connected.');
        
    end
    
end