function [  ] = testHierarchy( mutag_path, levels, clustering, reduction, delta )
%TESTHIERARCHY Load the graphs specified in path and generate the hierarchy
%   Load the graphs specified in path and generate the hierarchy
%   Example:
%       testHierarchy( '/media/priba/PPAP/Datasets/STDGraphs/MUTAG.mat', 3, @girvan_newman, 2, 0.1 )

    % Load data
    G = load(mutag_path) ;
    
    % Select specific graph
    idx = 1 ; % Graph index for testing purpose
    
    Gl = G.lmutag(idx) ;
    G = G.MUTAG(idx) ;
    
    % Hierarchy
    addpath('hierarchy')
    H = generateHierarchy( G, levels, clustering, reduction, delta ) ;
    
    % Hierarchy operation
    for i = 1:levels
        getLevel(H, i)
    end % for
    
    for i = 1:levels
        for j = i:levels
            getSubhierarchy(H, i, j)
        end % for
    end % for
    rmpath('hierarchy')
    
end % function

