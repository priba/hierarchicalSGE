%% Run classification script
function [] = run_hsge(dataset_path, dataset_name)

    clc;

    rng(0); 

    % Set parameters
    params = set_parameters() ;

    % Set paths
    addpath('./clustering/')
    addpath('./libs/')
    add_paths( ) ;
    
    % Load dataset
    % data = load_data(dataset_name, dataset_path) ;

    % Print information
    VERBOSE = 1 ;

    % SGE
    eps_i = [ 0.1 , 0.05 ] ;
    del_i = [ 0.1 , 0.05 ] ;
    max2 = [7, 5, 3] ;
    node_label = 'unlabel' ;

    % Hierarchy
    pyr_levels = [ 3 ] ;
    
    clustering_func = get_clustering( 'girvan_newman' ) ; % girvan_newman ; % grPartition ;
    
    pyr_reduction = 2 ;
    delta = 0.1 ;
    config = 'comb' ;

    % Standard error
    nits = 10 ;

    for eps = eps_i
        for del = del_i
            for pyr_level = pyr_levels
                if strcmp(data.type, 'kfold')
                    classify_dataset_kfold(data, params, 'VERBOSE', VERBOSE, 'epsilon', eps, 'delta', del, ...
                        'pyr_levels', pyr_level, 'pyr_reduction', pyr_reduction, 'delta', delta, ...
                        'max2', max2(1:pyr_level), 'label', node_label, 'clustering_func' , clustering_func, ...
                        'config', config);
                end
            end 
        end 
    end

    % Remove paths
    remove_paths( ) ;
    rmpath('./libs/')
    rmpath('./clustering/')
end
