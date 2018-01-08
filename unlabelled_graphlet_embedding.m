function global_var = unlabelled_graphlet_embedding( graph , graph_id , M , global_var, MAX2 ) 

    [I,J] = find(graph.am);
%     [I,J] = find(triu(graph.am | graph.am')); % Undirected graph
    % nV = size(graph.am,1);

    L = uint32([I,J]);

    clear I J;
    
    % Find the random graphlets
    graphlets = generate_random_graphlets(L,M(end),MAX2);                
    sizes_graphlets = cellfun(@length,graphlets)/2;

    idx = [];
    for isz = 1:MAX2                    
        idx = [idx;find(sizes_graphlets==isz,M(isz))];
    end;

    % idx = sort(idx);
    graphlets = graphlets(idx);
    sizes_graphlets = sizes_graphlets(idx);
    % Take only the unique of vertices
    [list_vertices_graphlets,~,indices_vertices_graphlets] = cellfun(@unique,graphlets,'UniformOutput',false);

    idx = sizes_graphlets <= 2 ; 
    graphlets(idx) = [];
    sizes_graphlets(idx) = [];
    list_vertices_graphlets(idx) = [];
    indices_vertices_graphlets(idx) = [];

    idxle4 = sizes_graphlets<=4;

    graphletsle4 = graphlets(idxle4);

    graphletsle4_sorted = cellfun(@sort,graphletsle4,'UniformOutput',false); clear graphletsge4;
    fcn1 = @(x) sort(diff([ 0 find(x(1:end-1) ~= x(2:end)) length(x) ])); % Sorted degree nodes as hash function
    sorted_degrees_nodes = cellfun(fcn1,graphletsle4_sorted,'UniformOutput',false);

    clear graphletsle4 graphletsle4_sorted;

    idxge5 = sizes_graphlets>=5;

    graphletsge5 = graphlets(idxge5);

    list_vertices_graphletsge5 = list_vertices_graphlets(idxge5);
    indices_vertices_graphletsge5 = indices_vertices_graphlets(idxge5);
    betweenness_centralities = cell(size(graphletsge5));            
    szA = cellfun(@length,list_vertices_graphletsge5);

    for j = 1:size(graphletsge5,1)
        A = sparse(indices_vertices_graphletsge5{j}(1:2:end),indices_vertices_graphletsge5{j}(2:2:end),1,szA(j),szA(j));
        betweenness_centralities{j} = sort(round(betweenness_centrality(double(A|A'))))';
    end;

    clear graphletsge5;

    hash_codes = cell(size(graphlets));

    hash_codes(idxle4) = sorted_degrees_nodes;
    hash_codes(idxge5) = betweenness_centralities;

    for j = 1:size(hash_codes,1)
        hash_codes{j} = [hash_codes{j},zeros(1,2*sizes_graphlets(j)-size(hash_codes{j},2))];
    end;

    clear idxle4 idxle5 sorted_degrees_nodes betweenness_centralities;

    for j = 3:MAX2
        idxj = (sizes_graphlets == j);

        if(~nnz(idxj))
            continue;
        end;

        hash_codes_j = cat(1,hash_codes{idxj});
        global_var.hash_codes_uniq{j-2} = unique([global_var.hash_codes_uniq{j-2};hash_codes_j],'stable','rows');
        [~, idx] = ismember(hash_codes_j,global_var.hash_codes_uniq{j-2},'rows');

        clear hash_codes_j;

        global_var.idx_graph{j-2} = [global_var.idx_graph{j-2}; graph_id*ones(size(idx))];
        global_var.idx_bin{j-2} = [global_var.idx_bin{j-2}; idx];

        clear idxj idx;
    end;

end
