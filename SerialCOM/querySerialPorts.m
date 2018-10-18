function  [cleanDevices] = querySerialPorts()

Skey = 'HKEY_LOCAL_MACHINE\HARDWARE\DEVICEMAP\SERIALCOMM';
% Find connected serial devices and clean up the output
[~, list] = dos(['REG QUERY ' Skey]);
list = strread(list,'%s','delimiter',' ');

if ~strcmp(list{1,1},'ERROR:')
    coms = 0;
    for i = 1:numel(list)
        if strcmp(list{i}(1:3),'COM')
            if ~iscell(coms)
                coms = list(i);
            else
                coms{end+1} = list{i};
            end
        end
    end
    key = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\USB\';
    % Find all installed USB devices entries and clean up the output
    [~, vals] = dos(['REG QUERY ' key ' /s /f "FriendlyName" /t "REG_SZ"']);
    vals = textscan(vals,'%s','delimiter','\t');
    vals = cat(1,vals{:});
    out = 0;
    % Find all friendly name property entries
    for i = 1:numel(vals)
        if strcmp(vals{i}(1:min(12,end)),'FriendlyName')
            if ~iscell(out)
                out = vals(i);
            else
                out{end+1} = vals{i};
            end
        end
    end
    % Compare friendly name entries with connected ports and generate output
    for i = 1:numel(coms)
        match = strfind(out,[coms{i},')']);
        ind = 0;
        for j = 1:numel(match)
            if ~isempty(match{j})
                ind = j;
            end
        end
        if ind ~= 0
            com = str2double(coms{i}(4:end));
            % Trim the trailing ' (COM##)' from the friendly name - works on ports from 1 to 99
            if com > 9
                length = 8;
            else
                length = 7;
            end
            devices{i,1} = out{ind}(27:end-length);
            devices{i,2} = com;
        end
    end
    
    if exist('devices')
        [r,c] = size(devices);
        
        row = 1;
        col = 1;
        done = false;
        
        for i = 1:r
            
            for j = 1:c
                
                
                if isempty(devices{i,j})
                    done = false;
                else
                    row;
                    col;
                    cleanDevices(row,col) = devices(i,j);
                    done = true;
                    if (done) && isequal(col,c)
                        row = row + 1;
                        done = false;
                    end
                    
                    
                end
                col = col + 1;
                
                if col > c
                    col = 1;
                end
            end
            
        end
        
    else
        cleanDevices = {};
    end
    
else
    devices = {};
    comPort = {};
    cleanDevices = {};
    
end
end