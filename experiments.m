%% Parameters to test. Each row is an experiment
% Embedding
function run_params = experiments()

% SGE
eps_i = [ 0.1 ; 0.05 ] ;
del_i = [ 0.1 ; 0.05 ] ;
max2 = [7; 5; 5];
node_label = {'unlabel', 'label'};
node_label_id = (1:size(node_label,2))';

% Hierarchy
pyr_levels = [ 1 ; 2 ; 3 ] ;
pyr_reduction = [ 2.0 ] ;
delta = [ 0.0 ] ;
clustering_func = { @girvan_newman };
clustering_func_id = (1:size(clustering_func,2))';
config = {'level_pyr', '2level_pyr', '2level_pyr_hier'} ;
config_id = (1:size(config, 2))';

% Embedding
emb_comb = allcomb( { eps_i, del_i, node_label_id } );
% emb_comb = [emb_comb,repmat(max2,size(emb_comb,1),1)];

% Pyramid
pyr_comb = allcomb( { pyr_levels, pyr_reduction, delta, clustering_func_id, config_id } );

flag1 = 0 ;
idx = (pyr_levels == 1) ;
if any(idx)
    idx = find(idx) ;
    pyr_comb(pyr_comb(:, 1) == idx, :) = [] ;
    flag1 = 1 ;
end

flag2 = 0 ;
idx = strcmp(config, 'base') ;
if any(idx)
    idx = find(idx) ;
    pyr_comb(pyr_comb(:, 5) == idx, :) = [] ;
    flag2 = 1 ;
end

if flag1 && flag2
    pyr_comb = [1, 1, 0, 1, 1; pyr_comb];
end

ind_comb = allcomb({(1:size(emb_comb,1))' , (1:size(pyr_comb,1))'});

run_params = [ emb_comb(ind_comb(:,1),:), pyr_comb(ind_comb(:,2),:) ] ;
run_params = num2cell( run_params ) ; 

run_params(:, 3) = node_label([run_params{:, 3}]);
run_params(:, 7) = clustering_func([run_params{:, 7}]);
run_params(:, 8) = config([run_params{:, 8}]);

run_params = [run_params,repmat({max2},size(run_params,1),1)];