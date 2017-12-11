function [vertices,nvertices,atrvertices,edges,nedges,atredges] = read_mao_ct(filename)

% read the file as string
fp = fopen(filename,'rt');

tline = fgetl(fp);
tline = fgetl(fp);
szs = sscanf(tline,'%d %d');

nvertices = szs(1);
nedges = szs(2);

vertices = [];
atrvertices = cell(nvertices,1);

tline = fgetl(fp);

i = 1;
while i<=nvertices
    
    l = sscanf(tline,'%*f %*f %*f %c')';
    atrvertices{i} = char(l(1));    
    
    tline = fgetl(fp);
    i = i+1;
    
end;

edges = zeros(nedges,2);
atredges = zeros(nedges,2);

i = 1;
while i<=nedges
    
    l = sscanf(tline,'%d %d %d %d')';
    edges(i,:) = l(1:2);    
    atredges(i,:) = l(3:4);
    
    tline = fgetl(fp);
    i = i+1;
    
end;

atredges(:,2) = atredges(:,2) + 1;

fclose(fp);

end