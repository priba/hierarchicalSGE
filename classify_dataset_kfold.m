function [  ] = classify_dataset_kfold( data, params, varargin )
%CLASSIFY_DATASET Summary of this function goes here
%   Detailed explanation goes here    
    
    % Output folder
    if ~exist( params.p_out , 'dir' )
        mkdir( params.p_out ) ;
    end
    
    % Output file
    params.headerSpec = 'Dataset: %s (%d graphs; %d classes; %d iterations)\n';
    params.sgeSpec = '\t*Stochastic Graphlet Embedding:\n\t\tEpsilon: %f\n\t\tDelta: %f\n';
    params.pyrSpec = '\t*Pyramidal:\n\t\tLevels: %d\n\t\tReduction: %f\n\t\tEdge Threshold: %f\n\t\tClustering function: %s\n';
    params.sepSpec = '----------------------------------------------------\n';    
    
    %% Default values
    [epsi, del, pyr_levels, pyr_reduction, delta, clustering_func, MAX2,...
        node_label, nits, VERBOSE, task_id, config] = input_parser( varargin ) ;
    rng(0);
    
    %% Decide the parts according to the config
    
    if strcmp(config, 'comb')
        n_parts = pyr_levels*(pyr_levels+1)/2 ;
        len = pyr_levels:-1:1 ;
        val = 1:pyr_levels ;        
    elseif strcmp(config, 'hier')
        n_parts = pyr_levels*(pyr_levels-1)/2 ;        
        len = pyr_levels-1:-1:1 ;
        val = 1:pyr_levels-1 ; 
    elseif strcmp(config, 'level')
        n_parts = pyr_levels ;
        len = ones(pyr_levels, 1) ;
        val = ones(pyr_levels, 1) ; 
    else
        error('Wrong configuration') ;
    end
    
    % Parts to level correspondence matrix
    temp1 = cumsum(len);
    temp2 = zeros(1, temp1(end));
    temp2(temp1(1:end-1)+1) = 1;
    temp2(1) = 1;
    parts2level = val(cumsum(temp2));
    
    clear temp1 temp2 ;

    %% Database information
    ngraphs = size(data.dataset.graphs,2);
    classes = unique(data.dataset.clss);
    nclasses = size(classes,1);
    if VERBOSE
        fprintf('Dataset Information\n\tNumber of graph: %d\n\tNumber of classes: %d\n',...
            ngraphs, nclasses) ;
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% comment the following line  %%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     ngraphs = 5 ; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for i = 1:ngraphs
        
        if VERBOSE
            fprintf('Graph: %d. ',i) ;
            tic ;
        end
        
        H = generateHierarchy( data.dataset.graphs(i), pyr_levels, clustering_func, pyr_reduction, delta ) ;
        
        if strcmp(config, 'comb')
            
            hier_graph = cell(n_parts, 1) ;
            hc = 1 ;
            % Construct hierarchy           
            for i_ = 1:pyr_levels
                hier_graph{hc} = getLevel(H, i_) ;
                hc = hc + 1 ;
                for j_ = i_+1:pyr_levels
                    hier_graph{hc} = getSubhierarchy(H, i_, j_) ;
                    hc = hc + 1 ;
                end % for
            end % for
            
        elseif strcmp(config, 'hier')
            
            hier_graph = cell(n_parts, 1) ;
            hc = 1 ;
            % Construct hierarchy           
            for i_ = 1:pyr_levels                
                for j_ = i_+1:pyr_levels
                    hier_graph{hc} = getSubhierarchy(H, i_, j_) ;
                    hc = hc + 1 ;
                end % for
            end % for
            
        elseif strcmp(config, 'level')            
            
            hier_graph = cell(n_parts, 1) ;
            % Construct hierarchy           
            for i_ = 1:pyr_levels
                hier_graph{i} = getLevel(H, i_) ;
            end % for
            
        else
            error('Wrong configuration');           
        end       
        
        % Embedding
        for j = 1:n_parts
            if any(hier_graph{j}.am(:))
                if (j > 1)
                    [ global_var(j) ] = graphlet_embedding(hier_graph{j} , i , M{j} , global_var(j), MAX2(parts2level(j)) , node_label) ;
                else
                    [ global_var(j) ] = graphlet_embedding(hier_graph{j} , i , M{j} , global_var(j), MAX2(parts2level(j)) , node_label ) ;
                end 
            end 
        end 
                
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
    
    maccs = zeros(size(combinations, 1), 1);
    mstds = zeros(size(combinations, 1), 1);
    
    for c = 1:size(combinations,1)
        
        comb = combinations(c,:);
        
        % Concat histogram
        comb_hist = [];
        for i = 1:length(comb)
            comb_hist = [comb_hist, combine_graphlet_hist(histograms(parts2level == i), comb(i), 'not_combine') ];
        end
        
        % Normalize hist
        comb_hist = bsxfun(@times, comb_hist, 1./(sum(comb_hist,2)+eps));
        
        X_train = comb_hist;
        X_test = comb_hist;

        KM_train = vl_alldist2(X_train',X_train','KL1');
        KM_test = vl_alldist2(X_test',X_train','KL1');


        %% Evaluate
        % Evaluate nits times to get the accuracy mean and standard deviation
        accs = zeros(nits,1);
        for it = 1:nits
            train_set = [];

            for i = classes'
                idx = find(data.dataset.clss == i);
                lngth_idx = length(idx);
                p90 = round(lngth_idx*0.9);
                train_set = [train_set;randsample(idx,p90)];

            end

            train_set = sort(train_set);
            test_set = setdiff(1:ngraphs,train_set')';

            train_classes = data.dataset.clss(train_set);
            test_classes = data.dataset.clss(test_set);

            ntrain_set = size(train_set,1);
            ntest_set = size(test_set,1);

            % Training and testing individual kernels

            K_train = [(1:ntrain_set)' KM_train(train_set,train_set)];
            K_test = [(1:ntest_set)' KM_test(test_set,train_set)];

            cs = 5:5:100;
            best_cv = 0;

            for j = 1:length(cs)

                options = sprintf('-s 0 -t 4 -v %d -c %f -b 1 -g 0.07 -h 0 -q',...
                        nits,cs(j));
                model_libsvm = svmtrain(train_classes,K_train,options);

                if(model_libsvm>best_cv)
                    best_cv = model_libsvm;
                    best_c = cs(j);
                end;

            end;

            options = sprintf('-s 0 -t 4 -c %f -b 1 -g 0.07 -h 0 -q',...
                best_c);

            model_libsvm = svmtrain(train_classes,K_train,options);

            [~,acc,~] = svmpredict(test_classes,K_test,model_libsvm,'-b 1');
            accs(it) = acc(1);
        end ;

        % Mean and standard deviation
        maccs(c) = mean(accs);
        mstds(c) = std(accs)./sqrt(nits);
    end
    
    clear global_var;
    
    % Save results
    if task_id<0
        fileID = fopen([params.p_out filesep data.dataset.name '_' node_label '.txt'],'a') ;
    else
        fileID = fopen([params.p_out filesep data.dataset.name '_' node_label '_' num2str(task_id) '.txt'],'a') ;
    end
    
    fprintf(fileID,params.headerSpec, data.dataset.name, ngraphs, nclasses, nits) ;
    fprintf(fileID,params.sgeSpec, epsi , del) ;
    fprintf(fileID,params.pyrSpec, pyr_levels , pyr_reduction , delta , func2str(clustering_func)) ;
    
    if strcmpi(node_label, 'unlabel')
        combinations = combinations + 2;
    else
        if size(combinations, 2) > 1
            combinations(:, 2:end) = combinations(:, 2:end) + 2;
        end ;
    end ;
    for i = 1:size(combinations,1)
        fprintf(fileID, 't = ');
        if VERBOSE
            fprintf('t = ');
        end ;
        for j = 1:size(combinations,2)
            fprintf(fileID, '%d\t', combinations(i,j)) ;
            if VERBOSE
            	fprintf('%d\t', combinations(i,j)) ;
            end ;
        end ;
        fprintf(fileID, '%.2f \\pm %.2f \n', maccs(i),mstds(i));
        if VERBOSE
            fprintf('%.2f \\pm %.2f \n', maccs(i),mstds(i));
        end ;
    end;
    fprintf(fileID,params.sepSpec) ;
    fclose(fileID);   
    
end