function writeFile(handles, selected)


switch selected
    
    case 0
        
        return
        
    case 1
        extension = char(strcat(handles.timeStamp{1,1},'.txt'))
        [usrFileName, pathname] = uiputfile(extension, 'Save txt file');
        
        if isequal(usrFileName,0)
            
            writeCancelledMsgBox = msgbox('User CANCELLED writing file operation....Good luck!', 'ATTENTION!','warn');
            pause(2.5)
            writeCancelledMsgBox.Visible = 'off';
            return
        else
            %             filename =char(strcat({usrFileName},{'-'},handles.timeStamp(1,1)))
            if isequal(handles.baselineCalFlag, 0)
                outputTxtFile = fopen(fullfile(pathname, usrFileName),'wt');
                
                fprintf(outputTxtFile,'%6s \t %12s\t   %12s\t %12s\r\n','time[min]','frequency', 'temperature', 'Smooth Frequency');
                fprintf(outputTxtFile,'%.5f \t %.5f \t %5f \t %.5f  \r\n',handles.dataMatrix');
                set(handles.console, 'String',strcat('Data matrix saved as --> ' , usrFileName));
            else
                if isequal(handles.baselineCalFlag, 1)
                    outputTxtFile = fopen(fullfile(pathname, usrFileName),'wt');
                    
                    fprintf(outputTxtFile,'%6s \t %12s\t%12s\t %12s \t %12s\r\n','time[min]','frequency', 'temperature', 'Smooth Frequency', 'RAW frequency');
                    fprintf(outputTxtFile,'%.5f \t %.5f \t %5f \t %.5f \t %.5f  \r\n',handles.dataMatrix');
                    set(handles.console, 'String',strcat('Data matrix saved as --> ' , usrFileName));
                end
            end
        end   
            fclose(outputTxtFile);
            
            case 2 % Write excel file
                
                
                %         handles.timeStamp = handles.timeStamp';
                if isequal(handles.baselineCalFlag, 0) % If baseline cal is selected NO RAW data
                    [r,c] = size(handles.dataMatrix);
                    [rTS,cTS] = size(handles.timeStamp);
                    cellMat = cell(r+1,c+1);
                    cellMat(1,:) = [{'time [min]'},{'DeltaF [Hz]'},{'Temperature [C]'}, {'Time Stamp'}, {'Smooth Frequency'}];
                    cellMat(2:end,1:3) = num2cell(handles.dataMatrix(:,1:3));
                    for i=1:r
                        cellMat(i+1:end,4) = cellstr(handles.timeStamp{i,2}(1,1));
                    end
                    cellMat(2:end,5) = num2cell(handles.dataMatrix(:,4));
                    
                else
                    if isequal(handles.baselineCalFlag, 1) % If baseline cal is selected, the format includes RAW data
                        
                        [r,c] = size(handles.dataMatrix);
                        [rTS,cTS] = size(handles.timeStamp);
                        cellMat = cell(r+1,c+1);
                        cellMat(1,:) = [{'time [min]'},{'DeltaF [Hz]'},{'Temperature [C]'}, {'Time Stamp'}, {'Smooth Frequency'},{'Raw Frequency'}];
                        cellMat(2:end,1:3) = num2cell(handles.dataMatrix(:,1:3));
                        for i=1:r
                            cellMat(i+1:end,4) = cellstr(handles.timeStamp{i,2}(1,1));
                        end
                        cellMat(2:end,5:6) = num2cell(handles.dataMatrix(:,4:5));
                        
                    end
                end
                cellMat
                
                extension = char(strcat(handles.timeStamp{1,1},'.xlsx')) %,{'-'},handles.timeStamp{end,2}
                [usrFileName, pathname] = uiputfile(extension, 'Save excel file');
                
                if isequal(usrFileName,0)
                    
                    writeCancelledMsgBox = msgbox('User CANCELLED writing file operation....Good luck!', 'ATTENTION!','warn');
                    pause(1)
                    writeCancelledMsgBox.Visible = 'off';
                    return
                else
                    %             filename =char(strcat({usrFileName},{'-'},handles.timeStamp{1,1}))
                    xlswrite([pathname usrFileName], cellMat);
                    set(handles.console, 'String',strcat('Data matrix saved as --> ' , usrFileName));
                    system('taskkill /F /IM EXCEL.EXE');
                end
                
                
        end