%% Run classification script
function [] = task_hsge(task_id)

    clc;

    rng(0); 

    addpath(genpath('./clustering'));

    run_params = experiments();

    % Dataset
    dataset_name = 'GREC';

    % Information
    VERBOSE = 0 ;

    eps = run_params{task_id,1}; 
    del = run_params{task_id,2};
    node_label = run_params{task_id,3};
    pyr_level = run_params{task_id,4};
    pyr_reduction = run_params{task_id,5};
    edge_tresh = run_params{task_id,6};
    clustering_func = run_params{task_id,7};
    max2  = run_params{task_id,8};


    if ismember(lower(dataset_name), {'grec','gwhistograph'})
        classify_dataset_partition(dataset_name, 'VERBOSE', VERBOSE, 'epsilon', eps, 'delta', del, ...
            'pyr_levels', pyr_level,'pyr_reduction', pyr_reduction, 'edge_tresh', edge_tresh, ...
            'max2', max2(1:pyr_level), 'label', node_label, 'clustering_func' , clustering_func);
    else
        classify_dataset_kfold(dataset_name, 'VERBOSE', VERBOSE, 'epsilon', eps, 'delta', del, ...
            'pyr_levels', pyr_level,'pyr_reduction', pyr_reduction, 'edge_tresh', edge_tresh, ...
            'max2', max2(1:pyr_level), 'label', node_label, 'clustering_func' , clustering_func);
    end
end