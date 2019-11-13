dataset_path = '/home/ad735/Workspace/Datasets/Graphs/STDGraphs' ;
sub_dataset = [] ;
% Respectively in the paper: Pyramidal, Generalized Pyramidal, Hierarchical, Exhaustive
run_hsge(dataset_path, 'MUTAG', sub_dataset) ;
run_hsge(dataset_path, 'PTC', sub_dataset) ;
run_hsge(dataset_path, 'PROTEINS', sub_dataset) ;
run_hsge(dataset_path, 'MAO', sub_dataset) ;
run_hsge(dataset_path, 'ENZYMES', sub_dataset) ;