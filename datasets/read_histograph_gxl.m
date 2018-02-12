function [vertices,atrvertices,edges,atredges] = read_histograph_gxl(filename)

% read the file as string
fs = fileread(filename) ;

% split them with delimeter '_' to get the different parameters
% get the node ids and labels

node_expr = [...
    '\s*<node\sid="[0-9-]*_([0-9]+)">\n',...
    '\s*<\w*\s\w*="x">\n',...
    '\s*<\w*>([-0-9.E]*)</\w*>',...
    '\s*</\w*>\n',...
    '\s*<\w*\s\w*="y">\n',...
    '\s*<\w*>([-0-9.E]*)</\w*>\n',...
    '\s*</\w*>\n',...
    '\s*</node>',...
    ] ;

edge_expr = '\s*<edge\s\w*="[0-9-]+_([0-9]*)"\s\w*="[0-9-]+_([0-9]*)"/>' ;

tokens = regexp(fs, node_expr, 'tokens') ;

if(isempty(tokens))    
    warning('Warning: Parsing nodes') ;
end

nvertices = size(tokens, 2) ;
vertices = zeros(nvertices, 2) ;
atrvertices = zeros(nvertices, 2) ;

for i = 1:nvertices
    vertices(i, :) = [str2double(tokens{i}(2)), str2double(tokens{i}(3))] ;
    atrvertices(i, :) = [str2double(tokens{i}(2)), str2double(tokens{i}(3))] ;
end

% get the source and target of edges and labels
tokens = regexp(fs, edge_expr, 'tokens') ;

if(isempty(tokens))
    warning('Warning: Parsing edges') ;
end

nedges = size(tokens, 2) ;
edges = zeros(nedges, 2) ;
atredges = [] ;

for i = 1:nedges
    edges(i, :) = [str2double(tokens{i}(1)), str2double(tokens{i}(2))] + 1 ;
end

end