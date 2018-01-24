%% Default values

function [eps, del, pyr_levels, pyr_reduction, edge_thresh, clustering_func,...
    max2, node_label, nits, VERBOSE , task_id, config] = input_parser( input )
    VERBOSE = 0 ;
    eps = 0.1 ;
    del = 0.1 ;
    pyr_levels = 1 ;
    pyr_reduction = 2 ;
    edge_thresh = 0 ;
    clustering_func = @girvan_newman ;
    max2 = [7, 5, 5] ;
    node_label = 'unlabel' ;    
    nits = 10 ;    
    task_id = -1;
    config = 'comb' ; % options are 'hier', 'level', 'comb', 'base'
    
    % Parse optional input parameters
    v = 1;
    while v < numel(input)
        switch lower(input{v})
            case 'verbose'
                v = v+1 ;
                VERBOSE = input{v};
            case 'epsilon'            
                v = v+1 ;
                eps = input{v};
            case 'delta'
                v = v+1 ;
                del = input{v};
            case 'pyr_levels'
                v = v+1 ;
                pyr_levels = input{v};
            case 'pyr_reduction'
                v = v+1 ;
                pyr_reduction = input{v};
                assert(pyr_reduction>=1) ;
            case 'edge_thresh'
                v = v+1 ;
                edge_thresh = input{v};
                assert(edge_thresh<=1 && edge_thresh>=0) ;
            case 'clustering_func'
                v = v+1 ;
                clustering_func = input{v};
            case 'max2'
                v = v+1 ;
                max2 = input{v};
            case 'label'
                v = v+1 ;
                node_label = input{v};
            case 'task_id'
                v = v+1 ;
                task_id = input{v};
            case 'nits'
                v = v+1 ;
                nits = input{v};
            case 'config'
                v = v+1 ;
                config = input{v};
            otherwise
                error('hierarchicalSGE:inputParser', 'Unsupported parameter: %s',input{v});        
        end
        v = v+1;
    end
    if ~exist('max2', 'var')
        max2 = 7*ones(pyr_levels,1); % Max size of graphlets in terms of edges
    end
    max2 = uint32(max2);
end