function [ H ] = generateHierarchy( G, levels, clustering_func, reduction, delta )
%GENERATEHIERARCHY Creates a hierarchical graph from an original one
%   Creates a hierarchical graph from an original one

    function [ H ] = addLevel( H, cluster, delta )
    %ADDLEVEL Given a clustering, adds this to the new level
    
        % Create Nodes
        classes = unique(cluster) ;
        n_nodes = length(classes) ;
        
        % Initialize adjacency matrix
        Hii.am = zeros(n_nodes, n_nodes) ; % New level
        Hji.am = zeros(n_nodes, length(cluster)) ; % Hierarchical edges
        
        % Each node information
        for j = 1:length(classes)            
            idx_j = classes(j) == cluster ;
            idx_j = [ false(size(H.am,1)-length(idx_j), 1); idx_j ] ;
            
            % Mean of node features and add a Hierarchical edge
            Hii.nl.values(j) = round( mean( H.nl.values(idx_j, :), 1 ) );
            Hji.am(j, idx_j) = 1 ;
            
            for k = j+1:length(classes)
                idx_k = classes(k) == cluster ;
                idx_k = [ false(size(H.am,1)-length(idx_k), 1); idx_k ] ;
                
                % Create a connection depending on the ratio
                connections = H.am(idx_j, idx_k) ;
                ratio_connection = sum(connections(:)) / numel(connections) ;
                if ratio_connection > delta
                    Hii.am(j,k) = 1 ; Hii.am(k,j) = 1 ;
                end ; % if
            end ; % for
            
        end % for
        
        % Join levels
        H.am = [ H.am , [ zeros(size(H.am,1)-size(Hji.am,2)), transpose(Hji.am) ]; ...
            [ zeros(size(H.am,1)-size(Hji.am,2)); Hji.am ], Hii.am ] ;
        H.nl.values = [ H.nl.values ; Hii.nl.values' ] ;
        H.levels = H.levels + 1 ;
        H.szLevels(end+1) = H.szLevels(end) + n_nodes ;
    end % function

    function H = initHierarchy(G)
    %INITHIERARCHY Initialize a hierarchical graph given the original one
        H.am = G.am ;
        H.nl.values = G.nl.values ;
        H.levels = 1 ;
        H.szLevels = [ size(G.am, 1) ] ;
    end % function
    
    % Initialize the Hierarchical representation
    H = initHierarchy(G);
    
    % Create each hierarchical level
    A = H.am ;
    for i = 2:levels
        num_nodes = floor(size(A,1)/reduction) ;
       
        % Cluser nodes
        cluster = clustering_func( A,  num_nodes) ;
        
        % Add the new level to the hierarchical graph
        H = addLevel( H, cluster, delta ) ;
        
        % Current level adjacency matrix
        A = H.am( H.szLevels(end-1)+1:H.szLevels(end) , H.szLevels(end-1)+1:H.szLevels(end) ) ;
    end % for
    
end

