function global_var = labelled_graphlet_embedding( graph , graph_id , M , global_var, MAX2 ) 

%     [I,J] = find(graph.am);
    [I,J] = find(triu(graph.am | graph.am')); % Undirected graph
    % nV = size(graph.am,1);

    L = uint32([I,J]);

    clear I J;
    
    % Find the random graphlets
    graphlets = generate_random_graphlets(L,M(MAX2),MAX2);                
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

%     for isz = 3:params.MAX2
%         idx = sizes_graphlets == isz;
%         weights_node_isz = 1./histc(cat(2,list_vertices_graphlets{idx}),1:nV)';
%         v_bin{isz-2} = [v_bin{isz-2};cellfun(@(x) sum(weights_node_isz(x)),list_vertices_graphlets(idx))];
% 
%         clear weights_node_isz;
%     end;

%     idx = sizes_graphlets <= 2 ; 
%     graphlets(idx) = [];
%     sizes_graphlets(idx) = [];
%     list_vertices_graphlets(idx) = [];
%     indices_vertices_graphlets(idx) = [];

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
        betweenness_centralities{j} = sort(round(betweenness_centrality(double(A|A'))*1e4))';
    end;

    clear graphletsge5;

    hash_codes = cell(size(graphlets));

    hash_codes(idxle4) = sorted_degrees_nodes;
    hash_codes(idxge5) = betweenness_centralities;

    % calculate node signatures with the help of classes of the vertices
    node_sign = cellfun(@(x) sort(graph.nl.values(x))',graphlets,'UniformOutput',false);

    % calculate edge signatures with the help of classes of the vertices
    if ~isfield(graph,'el') || ~isfield(graph.el,'values') || isempty(graph.el.values)
        edge_sign = cell(size(hash_codes,1),1);
    else
        edges_graphlets = cellfun(@(x) [x(1:2:end)' x(2:2:end)'],graphlets,'UniformOutput',false);	
        [~,idx_edges] = cellfun(@(x) ismember(x, L, 'rows'), edges_graphlets, 'UniformOutput', false);
        if iscell(graph.el.values)
            edge_sign = cellfun(@(x) sort(graph.el.values{x, 1})', idx_edges, 'UniformOutput', false);
        else
            edge_sign = cellfun(@(x) sort(graph.el.values(x, 1))', idx_edges, 'UniformOutput', false);
        end;
    end;

    for j = 1:size(hash_codes,1)
      	hash_codes{j} = [node_sign{j},edge_sign{j},hash_codes{j},zeros(1,2*sizes_graphlets(j)-size(hash_codes{j},2))];
    end;

    clear idxle4 idxle5 sorted_degrees_nodes betweenness_centralities;

    for j = 1:MAX2
        idxj = (sizes_graphlets == j);

        if(~nnz(idxj))
            continue;
        end;

        hash_codes_j = cat(1,hash_codes{idxj});
        global_var.hash_codes_uniq{j} = unique([global_var.hash_codes_uniq{j};hash_codes_j],'stable','rows');
        [~,idx] = ismember(hash_codes_j,global_var.hash_codes_uniq{j},'rows');

        clear hash_codes_j;

        global_var.idx_graph{j} = [global_var.idx_graph{j};graph_id*ones(size(idx))];
        global_var.idx_bin{j} = [global_var.idx_bin{j};idx];

        clear idxj idx;
    end;

end
