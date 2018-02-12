function [vertices, atrvertices, edges, atredges] = read_grec_gxl(filename)

% read the file as string
fs = fileread(filename);

cntrs_atrvertices = {'circle', 'corner', 'endpoint', 'intersection'};
cntrs_atredges = {'arc', 'arcarc', 'line', 'linearc'};

% split them with delimeter '_' to get the different parameters
% get the node ids and labels

node_expr = ['<node\sid="(\d*)">\n',...
    '<\w*\s\w*="x"><\w*>([0-9.-]*)</\w*></\w*>\n',...
    '<\w*\s\w*="y"><\w*>([0-9.-]*)</\w*></\w*>\n',...
    '<\w*\s\w*="type"><\w*>(\w*)</\w*></\w*>\n',...
    '</node>'];
edge_expr = ['<edge\s\w*="([0-9]*)"\s\w*="([0-9]*)">\n',...
    '<\w*\s\w*="\w*"><\w*>([0-9]*)</\w*></\w*>\n',...
    '<\w*\s\w*="\w*"><\w*>(\w*)</\w*></\w*>\n',...
    '<\w*\s\w*="\w*"><\w*>([0-9.-]*)</\w*></\w*>\n',...
    '(?:<\w*\s\w*="\w*"><\w*>)?(\w*)(?:</\w*></\w*>\n)?',...
    '(?:<\w*\s\w*="\w*"><\w*>)?([0-9.-]*)(?:</\w*></\w*>\n)?',...
    '</edge>'];

tokens = regexp(fs,node_expr,'tokens');
if(isempty(tokens))    
    error('Error: Parsing nodes');
end;
nvertices = size(tokens, 2) ;
vertices = zeros(nvertices, 2) ;
atrvertices = zeros(nvertices, 2) ;
for i = 1:nvertices
%     [~, c] = ismember(tokens{i}{4}, cntrs_atrvertices) ;
%     atrvertices{i} = [str2double(tokens{i}(2)), str2double(tokens{i}(3)), c] ;
    vertices(i, :) = [str2double(tokens{i}(2)), str2double(tokens{i}(3))] ;
    atrvertices(i, :) = [str2double(tokens{i}(2)), str2double(tokens{i}(3))] ;
end;

% get the source and target of edges and labels
tokens = regexp(fs,edge_expr,'tokens');

if(isempty(tokens))
    error('Error: Parsing edges');
end;
nedges = size(tokens,2);
edges = zeros(nedges,2);
atredges = cell(nedges,1);

for i = 1:nedges
    edges(i,:) = [str2double(tokens{i}(1)),str2double(tokens{i}(2))] + 1;    
    if(strcmp(tokens{i}(6),'line'))
        atredges(i) = tokens{i}(6) ;
    else
        atredges(i) = tokens{i}(4) ;
    end;
end;

[~, atredges] = ismember(atredges, cntrs_atredges);

end