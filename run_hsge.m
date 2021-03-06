%% Run classification script
function [] = run_hsge(dataset_path, dataset_name, sub_dataset, output_path)

    clc;

    rng(0); 
    
    % Check input parameters
    if nargin < 4
        output_path = [ './output/', dataset_name, '/'] ;
    end % if

    if ~exist(output_path, 'dir')
        mkdir(output_path)
    end % if
    
    d = dir( [ output_path, '/*.csv' ]) ;
    fileId = fopen(fullfile(output_path, [int2str(length(d)), '_run.csv']), 'w') ;
    clear d ;
    
    % Header
    fprintf(fileId,'Epsilon;Delta;T;Labelled;Levels;Reduction;Edge_Threshold;Clustering;Config;Iterations;;Mean;Std\n') ;
    % Logger
    logger = @(eps, del, t, label, level, reduction, del_pyr, clustering_func, config, nits, maccs, mstds) ...
        fprintf(fileId,'%f;%f;%s;%s;%d;%f;%f;%s;%s;%d;;%f;%f\n', eps, del, int2str(t), label, level, reduction, del_pyr, clustering_func, config, nits, maccs, mstds) ;
    
    % Set parameters
    params = set_parameters() ;

    % Set paths
    root_path = fileparts(mfilename('fullpath')) ;
    addpath(fullfile(root_path, '/libs/')) ;
    add_paths(root_path) ;
    
    % Load dataset
    data = load_data(dataset_name, sub_dataset, dataset_path) ;

    % Print information
    VERBOSE = 1 ;

    % SGE
    eps = 0.05 ;
    del = 0.05 ;
    max2 = [7, 5, 3] ;
    node_label = 'unlabel' ; % { 'unlabel' , 'label' } ;

    % Hierarchy
    pyr_level = 2 ; %[ 1 , 2 , 3 ] ;
    
    clustering_func = get_clustering( 'girvan_newman' ) ; % girvan_newman ; % grPartition ;
    
    pyr_reductions = [1.5, 2.0, 3.0] ;
    edge_thresh = 0 ;
%     config = '2level_pyr_hier' ;% { 'base', 'comb', 'hier', 'level' } ;
    configs = {'2level_pyr', '2level_pyr_hier', 'comb', 'level'} ;

    % Standard error
    nits = 5 ;

    for config = configs        
        for pyr_reduction = pyr_reductions
            if strcmp(data.type, 'kfold')                                        
                classify_dataset_kfold(data, params, logger, 'VERBOSE', VERBOSE, 'epsilon', eps, 'delta', del, ...
                    'pyr_levels', pyr_level, 'pyr_reduction', pyr_reduction, 'edge_thresh', edge_thresh, ...
                    'max2', max2(1:pyr_level), 'label', node_label, 'clustering_func' , clustering_func, ...
                    'config', config{:}, 'nits', nits) ;
            else
                classify_dataset_partition(data, params, logger, 'VERBOSE', VERBOSE, 'epsilon', eps, 'delta', del, ...
                    'pyr_levels', pyr_level, 'pyr_reduction', pyr_reduction, 'edge_thresh', edge_thresh, ...
                    'max2', max2(1:pyr_level), 'label', node_label, 'clustering_func' , clustering_func, ...
                    'config', config{:}, 'nits', nits) ;                    
            end
        end       
    end

%     fclose(logger);
    fclose(fileId);  
    
    % Remove paths
    remove_paths( ) ;
    rmpath('./libs/')

end
