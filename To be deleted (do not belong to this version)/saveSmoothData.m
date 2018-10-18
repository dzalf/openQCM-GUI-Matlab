function saveFinalData(adjustedDataMatrix,smoothIntensity)
smoothMatrix(:,1) = adjustedDataMatrix(:,1);
smoothMatrix(:,2) = smoothIntensity;


failMsg = msgbox('Operation failed. File opened. TRY AGAIN!', 'ATTENTION!','warn');
                
               
               % Create matrix with computed data to be stored
                failMsg.Visible = 'off';
%                 finalMatrix = createDataMatrix(chunk1, chunk2, rotatedChunk3);
               
     
                [filename, pathname] = uiputfile('*.txt', 'Save txt file');

                if isequal(filename,0)

                    msgbox('User CANCELLED writing file operation....Good luck!', 'ATTENTION!','warn');
                    pause(2.5)
                    
                    return
                else
                    outputTxtFile = fopen(fullfile(pathname, filename),'wt');

                    fprintf(outputTxtFile,'\t%s \t %s \r','X[something]','Intensity[arb.units]');
                    fprintf(outputTxtFile,'\t\t%.5f \t\t\t\t  %.5f\r',smoothMatrix');


                    [cdata,map] = imread('check.png');
                    msgbox(['Data matrix created and saved as --> ' , filename],'custom','custom',cdata,map);

                end

                fclose(outputTxtFile);
       

end