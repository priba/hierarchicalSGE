function [vertices, atrvertices, edges, atredges] = read_coildel_gxl(filename)

% read the file as string
fs = fileread(filename);

% split them with delimeter '_' to get the different parameters
% get the node ids and labels
node_expr = '<node\sid="_([0-9]*)"><\w*\s\w*="x"><\w*>([0-9.-]*)</\w*></\w*><\w*\s\w*="y"><\w*>([0-9.-]*)</\w*></\w*></node>';
edge_expr = '<edge\s\w*="_([0-9]*)"\s\w*="_([0-9]*)">\n<\w*\s\w*="\w*"><\w*>([0-9]*)</\w*></\w*></edge>';
tokens = regexp(fs,node_expr,'tokens');
if(isempty(tokens))    
    error('Error: Parsing nodes');
end;
tokens = cellfun(@str2double,tokens,'UniformOutput',false) ; 
vertices = cell2mat(cellfun(@(x) x(2:3), tokens, 'UniformOutput', false)') ; 
atrvertices = cell2mat(cellfun(@(x) x(2:3), tokens, 'UniformOutput', false)') ; 
clear tokens ;

% get the source and target of edges and labels
tokens = regexp(fs,edge_expr,'tokens');

if(isempty(tokens))
    error('Error: Parsing edges');
end;
tokens = cellfun(@str2double,tokens,'UniformOutput',false);
edges = cell2mat(cellfun(@(x) x(1:2),tokens,'UniformOutput',false)') + 1; 
atredges = cell2mat(cellfun(@(x) x(3),tokens,'UniformOutput',false)') ; clear tokens;

end