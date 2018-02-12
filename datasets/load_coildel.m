function [ graphs_train, clss_train, graphs_valid, clss_valid,...
    graphs_test, clss_test] = load_coildel(folder)
    
    %% Load COIL-DEL database

    [fns_train,clss_train] = read_coildel_cxl(fullfile(folder, 'train.cxl')) ;
    [fns_valid,clss_valid] = read_coildel_cxl(fullfile(folder, 'valid.cxl')) ;
    [fns_test,clss_test] = read_coildel_cxl(fullfile(folder, 'test.cxl')) ;

    ntrain = length(fns_train) ; 
    nvalid = length(fns_valid) ; 
    ntest = length(fns_test) ;
    
    v_all = [] ; % for accumulating the vertices
    k = 10 ; % number of clusters for clustering the vertices

    for i = 1:ntrain
        [graphs_train(i).v, graphs_train(i).nl.values, graphs_train(i).e,...
            graphs_train(i).el.values] = read_coildel_gxl(fullfile(folder, fns_train{i})) ;
        graphs_train(i).am = zeros(size(graphs_train(i).nl.values,1),size(graphs_train(i).nl.values,1)) ;
        ind = sub2ind(size(graphs_train(i).am),graphs_train(i).e(:,1),graphs_train(i).e(:,2)) ;
        graphs_train(i).am(ind) = 1 ;
        v_all = [v_all; graphs_train(i).nl.values] ;
    end;

    for i = 1:nvalid
        [graphs_valid(i).v, graphs_valid(i).nl.values, graphs_valid(i).e,...
            graphs_valid(i).el.values] = read_coildel_gxl(fullfile(folder, fns_valid{i})) ;
        graphs_valid(i).am = zeros(size(graphs_valid(i).nl.values,1),size(graphs_valid(i).nl.values,1)) ;
        ind = sub2ind(size(graphs_valid(i).am),graphs_valid(i).e(:,1),graphs_valid(i).e(:,2)) ;
        graphs_valid(i).am(ind) = 1 ;        
        v_all = [v_all; graphs_valid(i).nl.values] ;
    end;

    for i = 1:ntest
        [graphs_test(i).v, graphs_test(i).nl.values, graphs_test(i).e,...
            graphs_test(i).el.values] = read_coildel_gxl(fullfile(folder, fns_test{i})) ;
        graphs_test(i).am = zeros(size(graphs_test(i).nl.values,1),size(graphs_test(i).nl.values,1)) ;
        ind = sub2ind(size(graphs_test(i).am),graphs_test(i).e(:,1),graphs_test(i).e(:,2)) ;
        graphs_test(i).am(ind) = 1 ;
        v_all = [v_all; graphs_test(i).nl.values] ;
    end;
    
    cl = kmeans(v_all, k, 'EmptyAction', 'singleton', 'MaxIter', 1000) ;
    
    start_idx = 1 ;
    end_idx = 0 ;
    
    for i = 1:ntrain
        sz = size(graphs_train(i).nl.values, 1) ;
        end_idx = end_idx + sz ;
        graphs_train(i).nl.values = cl(start_idx:end_idx, :) ;
        start_idx = start_idx + sz ;        
    end;
    
    for i = 1:nvalid
        sz = size(graphs_valid(i).nl.values, 1) ;
        end_idx = end_idx + sz ;
        graphs_valid(i).nl.values = cl(start_idx:end_idx, :) ;
        start_idx = start_idx + sz ;
    end;
    
    for i = 1:ntest
        sz = size(graphs_test(i).nl.values, 1) ;
        end_idx = end_idx + sz ;
        graphs_test(i).nl.values = cl(start_idx:end_idx, :) ;
        start_idx = start_idx + sz ;
    end;
end