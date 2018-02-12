function [  ] = classify_dataset_partition( data, params, logger, varargin )
%CLASSIFY_DATASET Summary of this function goes here
%   Detailed explanation goes here

    function [parts2level , n_parts] = get_parts(config, pyr_levels)
        %% Decide the parts according to the config
        switch lower(config)
            case 'comb'
                n_parts = pyr_levels*(pyr_levels+1)/2 ;
                len = pyr_levels:-1:1 ;
                val = 1:pyr_levels ;        
            case 'hier'
                n_parts = pyr_levels*(pyr_levels-1)/2 ;        
                len = pyr_levels-1:-1:1 ;
                val = 1:pyr_levels-1 ; 
            case 'level'
                n_parts = pyr_levels ;
                len = ones(pyr_levels, 1) ;
                val = ones(pyr_levels, 1) ; 
            case 'base'
                if pyr_levels ~= 1
                    warning('config is base but pyr_levels is not one')
                    pyr_levels = 1 ;
                end
                n_parts = pyr_levels ;
                len = 1 ;
                val = 1 ;
            otherwise
                error('classify_dataset_kfold:get_parts:incorrectConfig', ...
                    'Error.\nNot implemented config %s.', config)
        end
        
        % Parts to level correspondence matrix
        temp1 = cumsum(len);
        temp2 = zeros(1, temp1(end));
        temp2(temp1(1:end-1)+1) = 1;
        temp2(1) = 1;
        parts2level = val(cumsum(temp2));
    
    end % function
    
    %% Default values
    [epsi, del, pyr_levels, pyr_reduction, edge_thresh, clustering_func, MAX2,...
        node_label, nits, VERBOSE, task_id, config] = input_parser( varargin ) ;
    
    rng(0);
    
    %% Decide the parts according to the config
    [parts2level , n_parts] = get_parts(config, pyr_levels) ;   
    
    %% Database information
    data.dataset.graphs = [data.dataset.graphs_train , data.dataset.graphs_test];
    data.dataset.clss = [data.dataset.clss_train; data.dataset.clss_test];
    ntrain = size(data.dataset.graphs_train, 2);
    ntest = size(data.dataset.graphs_test, 2);
    ngraphs = size(data.dataset.graphs, 2);
    classes = unique(data.dataset.clss);
    nclasses = size(classes, 1);
    if VERBOSE
        fprintf('Dataset Information\n\tNumber of graph:%d\t(Train %d\tTest %d)\n\tNumber of classes: %d\n',...
            ngraphs,ntrain,ntest, nclasses) ;
    end
    
    %% Create histogram indices  
    % Initialize storage
    for i = 1:n_parts        
        M{i} = uint32(ceil(2*(params.T(1:MAX2(parts2level(i)))*log(2)+log(1/del))/epsi^2)) ;
        global_var(i).idx_graph = cell(MAX2(parts2level(i))-2, 1) ;
        global_var(i).idx_bin = cell(MAX2(parts2level(i))-2, 1) ;
        global_var(i).hash_codes_uniq = cell(MAX2(parts2level(i))-2, 1) ;
    end
    
    %% Iterate whole dataset
    for i = 1:ngraphs
        if VERBOSE
            fprintf('Graph: %d. ',i);
            tic;
        end 
        
        if ~strcmpi(config, 'base')
            H = generateHierarchy( data.dataset.graphs(i), pyr_levels, clustering_func, pyr_reduction, edge_thresh ) ;

            hier_graph = cell(n_parts, 1) ;
            hc = 1 ;

            % Construct hierarchy           
            for i_ = 1:pyr_levels
                if ~strcmpi(config, 'hier')
                    hier_graph{hc} = getLevel(H, i_) ;
                    hc = hc + 1 ;
                end % if
                if ~strcmpi(config, 'level')
                    for j_ = i_+1:pyr_levels
                        hier_graph{hc} = getSubhierarchy(H, i_, j_) ;
                        hc = hc + 1 ;
                    end  % for
                end  % if
            end  % for
            
        else
            
            hier_graph{n_parts} = data.dataset.graphs(i) ;
            
        end % if
        
        % Embedding
        for j = 1:n_parts
            if any(hier_graph{j}.am(:))
                [ global_var(j) ] = graphlet_embedding(hier_graph{j} , i , M{j} , global_var(j), MAX2(parts2level(j)) , node_label ) ;
            end % if
        end % for        
        
        if VERBOSE
            toc
        end 
    end

    % Histogram dimensions
    dim_hists = cell(n_parts,1) ;
    for i = 1:n_parts
        dim_hists{i} = cellfun(@(x) size(x,1) ,global_var(i).hash_codes_uniq);
        clear global_var(i).hash_codes_uniq;
    end
    
    %% Compute histograms and kernels
    histograms = cell(n_parts,1);

    for j = 1:n_parts
        histograms{j} = cell(1, MAX2(parts2level(j))-2);
        for i = 1:MAX2(parts2level(j))-2
            histograms{j}{i} = sparse(global_var(j).idx_graph{i}, global_var(j).idx_bin{i}, 1, ngraphs, dim_hists{j}(i));
        end 
    end 
    
    % All possible combinations
    combinations = cell(1, pyr_levels) ;    
    for j = 1:pyr_levels
        combinations{j} = (1:MAX2(j)-2)' ;
    end
    combinations = allcomb( combinations ) ;
    
    maccs = zeros(size(combinations, 1), 1) ;
    mstds = zeros(size(combinations, 1), 1) ;
    
    w_classes = ones(1, nclasses) ;    
    for i = 1:nclasses
        w_classes(i) = nnz(data.dataset.clss_train == classes(i)) ;        
    end
    w_classes = 1./w_classes ;
    w_classes = w_classes/max(w_classes) ;
    w_str =  [] ;
    for i = 1:nclasses
        w_str = [w_str, sprintf('-w%d %f ', classes(i), w_classes(i))] ;
    end
    
    for c = 1:size(combinations,1)
        
        comb = combinations(c,:);

        % Concat histogram
        comb_hist = [] ;
        for i = 1:length(comb)
            comb_hist = [comb_hist, combine_graphlet_hist(histograms(parts2level == i), comb(i), 'combine') ] ;
        end
        
        % Normalize hist
        X = bsxfun(@times, comb_hist, 1./(sum(comb_hist,2)+eps)) ;
        
        X_train = X(1:ntrain,:) ;
        X_test = X(ntrain+(1:ntest),:) ;

        KM_train = vl_alldist2(X_train',X_train','KL1') ;
        KM_test = vl_alldist2(X_test',X_train','KL1') ;

        %% Evaluate
        % Evaluate nits times to get the accuracy mean and standard deviation
        train_classes = data.dataset.clss(1:ntrain) ;
        test_classes = data.dataset.clss(ntrain+(1:ntest)) ;

        % Training and testing individual kernels

        K_train = [(1:ntrain)' KM_train] ;
        K_test = [(1:ntest)' KM_test] ;

        cs = 5:5:100 ;
        best_cv = 0 ;

        for j = 1:length(cs)

            options = sprintf('-s 0 -t 4 -v %d -c %f %s-b 1 -g 0.07 -h 0 -q',...
                    nits,cs(j), w_str) ;
            model_libsvm = svmtrain(train_classes,K_train,options) ;

            if(model_libsvm>best_cv)
                best_cv = model_libsvm ;
                best_c = cs(j) ;
            end

        end

        options = sprintf('-s 0 -t 4 -c %f %s-b 1 -g 0.07 -h 0 -q',...
            best_c, w_str) ;

        model_libsvm = svmtrain(train_classes,K_train,options) ;

        [~,acc,~] = svmpredict(test_classes,K_test,model_libsvm,'-b 1') ;

        % Mean
        maccs(c) = acc(1) ;
        
    end
    
    clear global_var ;
    
    % Save results
    if strcmpi(node_label, 'unlabel')
        combinations = combinations + 2 ;
    else
        if size(combinations, 2) > 1
            combinations(:, 2:end) = combinations(:, 2:end) + 2 ;
        end
    end 
    for i = 1:size(combinations, 1)
        logger(epsi, del, combinations(i,:), node_label, pyr_levels, pyr_reduction, edge_thresh, func2str(clustering_func), config, nits, maccs(i), mstds(i)) ;
    end 
    
end