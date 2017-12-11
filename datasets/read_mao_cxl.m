function [file_names,classes] = read_mao_cxl(filename)

% read the file as string
fs = fileread(filename);

if(~isempty(strfind(filename,'train.cxl'))||~isempty(strfind(filename,'valid.cxl')))
        
    expr = '<\w*\s\w*="([a-z0-9.]*)"\s\w*="(\d+)"/>\n';

    tokens = regexp(fs,expr,'tokens');

    if(isempty(tokens))    
        error('Error: Parsing nodes');
    end;

    file_names = cellfun(@(x) x{1},tokens,'UniformOutput',false)';
    classes = str2double(cellfun(@(x) x{2},tokens,'UniformOutput',false)');
        
elseif(~isempty(strfind(filename,'-test.cxl')))
        
    expr = '<\w*\s\w*="([a-z0-9.]*)"\s/>\n';

    tokens = regexp(fs,expr,'tokens');

    if(isempty(tokens))    
        error('Error: Parsing nodes');
    end;

    file_names = cellfun(@(x) x{1},tokens,'UniformOutput',false)';
    classes = [];
        
end;

clear fs tokens;

end