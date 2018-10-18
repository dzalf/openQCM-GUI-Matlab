function RawSerial  = getValues(openQCM, serialBufferSize)
RawSerial = char(fread(openQCM, serialBufferSize))';
end