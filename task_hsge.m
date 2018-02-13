%% Run classification script
function [] = task_hsge(task_id, nits, dataset_path, dataset_name, sub_dataset, output_path)

    clc;
    rng(0); 
      
    % Check input parameters
    if nargin < 5
        output_path = [ './output/', dataset_name, '/'] ;
    end % if
    
    if nargin < 4
        sub_dataset = [] ;
        output_path = [ './output/', dataset_name, '/'] ;        
    end % if    

    if ~exist(output_path, 'dir')
        mkdir(output_path)
    end % if
        
    fileId = fopen(fullfile(output_path, [sprintf('%02d', task_id), '_run.csv']), 'w') ;
    
    % Header
%     fprintf(fileId,'Epsilon;Delta;T;Labelled;Levels;Reduction;Edge_Threshold;Clustering;Config;Iterations;;Mean;Std\n') ;
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
    
    % Information
    VERBOSE = 1 ;
    
    % Number of iterations nits = 10    
    
    run_params = experiments();

    eps = run_params{task_id, 1}; 
    del = run_params{task_id, 2};
    node_label = run_params{task_id, 3};
    pyr_level = run_params{task_id, 4};
    pyr_reduction = run_params{task_id, 5};
    edge_thresh = run_params{task_id, 6};
    clustering_func = run_params{task_id, 7};
    config = run_params{task_id, 8};
    max2  = run_params{task_id, 9};
    
    if strcmp(data.type, 'kfold')
        
        if nits <= 1
            nits = 10 ;
        end
        
        classify_dataset_kfold(data, params, logger, 'VERBOSE', VERBOSE, 'epsilon', eps, 'delta', del, ...
        'pyr_levels', pyr_level, 'pyr_reduction', pyr_reduction, 'edge_thresh', edge_thresh, ...
        'max2', max2(1:pyr_level), 'label', node_label, 'clustering_func' , clustering_func, ...
        'config', config, 'nits', nits, 'task_id', task_id) ;
    
    else
        
        if nits > 1
            
            classify_dataset_partition_iter(data, params, logger, 'VERBOSE', VERBOSE, 'epsilon', eps, 'delta', del, ...
            'pyr_levels', pyr_level, 'pyr_reduction', pyr_reduction, 'edge_thresh', edge_thresh, ...
            'max2', max2(1:pyr_level), 'label', node_label, 'clustering_func' , clustering_func, ...
            'config', config, 'nits', nits, 'task_id', task_id) ;
        
        else
            
            classify_dataset_partition(data, params, logger, 'VERBOSE', VERBOSE, 'epsilon', eps, 'delta', del, ...
            'pyr_levels', pyr_level, 'pyr_reduction', pyr_reduction, 'edge_thresh', edge_thresh, ...
            'max2', max2(1:pyr_level), 'label', node_label, 'clustering_func' , clustering_func, ...
            'config', config, 'nits', nits, 'task_id', task_id) ;
        
        end
    end
end