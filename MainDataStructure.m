function [handles] = MainDataStructure(handles)
% Generates the "global" handles.* variables used by the program.
% They are actually stored as part of the program's main GUI and passed to each callback function.


handles.base_directory = fileparts(mfilename('fullpath'));  % Path to the base directory (containing MainDataStructure.m)
if (handles.base_directory(end) == filesep())
    handles.base_directory = handles.base_directory(1 : (end-1));  % Remove the trailing (back)slash
end

return;