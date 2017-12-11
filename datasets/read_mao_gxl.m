function [vertices,nvertices,atrvertices,edges,nedges,atredges] = read_mao_gxl(filename)

% read the file as string
fs = fileread(filename);

% split them with delimeter '_' to get the different parameters
% get the node ids and labels

node_expr = ['<node\sid="_(\d*)">\n',...
    '<\w*\s\w*="\w*"><\w*>([0-9.-]*)</\w*>\s+</\w*>\n',...
    '</node>'];
edge_expr = ['<edge\s\w*="_([0-9]*)"\s\w*="_([0-9]*)">\n',...
    '<\w*\s\w*="\w*"><\w*>([0-9]*)</\w*>\s+</\w*>\n',...
    '</edge>'];

tokens = regexp(fs,node_expr,'tokens');
if(isempty(tokens))    
    error('Error: Parsing nodes');
end;
nvertices = size(tokens,2);
vertices = [];
atrvertices = zeros(nvertices,1);
for i = 1:nvertices
    atrvertices(i) = str2double(tokens{i}{2});
end;

% get the source and target of edges and labels
tokens = regexp(fs,edge_expr,'tokens');

if(isempty(tokens))
    error('Error: Parsing edges');
end;
nedges = size(tokens,2);
edges = zeros(nedges,2);
atredges = zeros(nedges,1);

for i = 1:nedges
    edges(i,:) = [str2double(tokens{i}(1)),str2double(tokens{i}(2))];    
    atredges(i) = str2double(tokens{i}(3));    
end;

end