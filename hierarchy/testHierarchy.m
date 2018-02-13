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
    addpath('clustering') ;
    addpath(genpath('D:\User\Documentos\MATLAB\matlab_bgl')) ;
    H = generateHierarchy( G, levels, clustering, reduction, delta ) ;
    
    %% Hierarchy operation
    % Separated Levels
    fprintf('Levels\n')
    for i = 1:levels
        fprintf('Level %d\n', i)
        getLevel(H, i)
    end % for
    
    % Subhierarchies
    fprintf('Subhierarchies\n')
    for i = 1:levels
        for j = i:levels
            fprintf('Levels %d, %d\n', i, j)
            getSubhierarchy(H, i, j)
        end % for
    end % for
    
    % Combine levels
    fprintf('Combine Levels\n')
    for i = 1:levels
        for j = i:levels
            fprintf('Levels %d, %d\n', i, j)
            getLevels(H, i, j)
        end % for
    end % for
    
end % function

