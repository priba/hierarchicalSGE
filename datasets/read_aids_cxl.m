function [file_names,classes] = read_aids_cxl(filename)

% read the file as string
fs = fileread(filename);

expr = '<\w*\s\w*="([a-z0-9._]*)"\s\w*="(\w*)"/>';

tokens = regexp(fs,expr,'tokens');

if(isempty(tokens))    
    error('Error: Parsing nodes');
end;

file_names = cellfun(@(x) x{1},tokens,'UniformOutput',false)';
classes_c = cellfun(@(x) x{2},tokens,'UniformOutput',false)';

classes(strcmpi(classes_c,'a'), :) = 1 ;
classes(strcmpi(classes_c,'i'), :) = 2 ;
        
clear fs tokens;

end